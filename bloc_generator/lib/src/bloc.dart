// Copyright 2019 Callum Iddon
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';

import 'package:build/build.dart';

import 'package:source_gen/source_gen.dart';

import 'package:bloc_annotations/bloc_annotations.dart';

import 'package:bloc_generator/src/class_finder.dart';
import 'package:bloc_generator/src/metadata.dart';

enum ServiceMetadataType { input, output, bloc, trigger, mapper }

class ServiceMetadata {
  final ServiceMetadataType type;
  final List<ElementAnnotation> metadata;

  ServiceMetadata(this.type, this.metadata)
      : assert(type != null),
        assert(metadata != null);
}

class BLoCGenerator extends GeneratorForAnnotation<BLoC> {
  BuilderOptions options;
  BLoCGenerator(this.options);

  @override
  Stream<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async* {
    final String name = element.name[0] == '_' ? element.name.substring(1) : element.name;
    final String bloc = '${name}BLoC';

    final List<ServiceMetadata> allServices = <ServiceMetadata>[];
    if (findMetadata(element, '@BLoCRequireInputService')) {
      allServices.add(ServiceMetadata(ServiceMetadataType.input, getMetadata(element, '@BLoCRequireInputService')));
    }
    if (findMetadata(element, '@BLoCRequireOutputService')) {
      allServices.add(ServiceMetadata(ServiceMetadataType.output, getMetadata(element, '@BLoCRequireOutputService')));
    }
    if (findMetadata(element, '@BLoCRequireBLoCService')) {
      allServices.add(ServiceMetadata(ServiceMetadataType.bloc, getMetadata(element, '@BLoCRequireBLoCService')));
    }
    if (findMetadata(element, '@BLoCRequireTriggerService')) {
      allServices.add(ServiceMetadata(ServiceMetadataType.trigger, getMetadata(element, '@BLoCRequireTriggerService')));
    }
    if (findMetadata(element, '@BLoCRequireMapperService')) {
      allServices.add(ServiceMetadata(ServiceMetadataType.mapper, getMetadata(element, '@BLoCRequireMapperService')));
    }

    final StringBuffer services = StringBuffer();
    final StringBuffer servicesInit = StringBuffer();
    final StringBuffer servicesTrigger = StringBuffer();
    final StringBuffer servicesDispose = StringBuffer();

    final StringBuffer mappers = StringBuffer('');

    for (final ServiceMetadata service in allServices) {
      for (final ElementAnnotation metadata in service.metadata) {
        final List<String> inputs = findInputs(metadata);
        final String serviceType = inputs[0];
        final String serviceName = '${inputs[0][0].toLowerCase()}${inputs[0].substring(1)}';
        final String inputName = service.type == ServiceMetadataType.bloc || service.type == ServiceMetadataType.trigger
            ? 'this'
            : inputs[1];

        services.writeln('final $serviceType $serviceName = $serviceType();\n');

        if (service.type != ServiceMetadataType.trigger && service.type != ServiceMetadataType.mapper) {
          servicesInit.writeln('$serviceName.init($inputName);');
        } else if (service.type == ServiceMetadataType.mapper) {
          mappers.write('''
            _${inputs[1]}.stream.listen((inputData) {
              $serviceName.map(inputData).forEach((newData) {
                _${inputs[2]}.sink.add(newData);
              });
            });
         ''');
        } else if (service.type == ServiceMetadataType.trigger) {
          final String triggerName = 'trigger${serviceName[0].toUpperCase()}'
              '${serviceName.substring(1)}';
          servicesTrigger.writeln('Future<void> $triggerName() async => await '
              '$serviceName.trigger(this);');
        }
        servicesDispose.writeln('$serviceName.dispose();');
      }
    }

    final StringBuffer parameters = StringBuffer('');
    final StringBuffer parametersList = StringBuffer('');
    final StringBuffer namedParameters = StringBuffer('');

    for (final ElementAnnotation metadata in element.metadata) {
      if (metadata.toString().contains('@BLoCParameter')) {
        final String parameterType = findInputs(metadata)[0];
        final String parameterName = findInputs(metadata)[1];
        parametersList.writeln('$parameterType $parameterName,');
        namedParameters.writeln('$parameterName: $parameterName,');
      }
    }

    final StringBuffer controllers = StringBuffer('');
    final StringBuffer controllersDisposer = StringBuffer('');

    final StringBuffer values = StringBuffer('');
    final StringBuffer valueUpdaters = StringBuffer('');

    final Map<String, String> currentValues = <String, String>{};

    element.visitChildren(ClassFinder(field: (Element element) {
      final String inputType = findType(element);
      final String inputName = findName(element);

      final bool isInput = findMetadata(element, '@BLoCInput');
      final bool isOutput = findMetadata(element, '@BLoCOutput');
      final bool isInputOutput = findMetadata(element, '@BLoCInOut');
      final bool isValue = findMetadata(element, '@BLoCValue');
      final bool isExported = findMetadata(element, '@BLoCExportMember');

      String templateType;
      if (isInput || isOutput || isInputOutput) {
        templateType = findTemplateType(element);
      }

      final String name = inputName[0] == '_' ? inputName.substring(1) : inputName;

      if (isInput || isOutput || isInputOutput) {
        controllers.writeln('$inputType get _$inputName => template.$inputName;');
      } else if (isValue) {
        values.writeln('$inputType get $name => template.$inputName;\n');

        for (final ElementAnnotation metadata in getMetadata(element, '@BLoCValue')) {
          final String output = findInputs(metadata)[0];
          currentValues[output] = name;
          valueUpdaters.write('''
                _$output.stream.listen((inputData) {
                  template.$inputName = inputData;
                });
              ''');
        }
      }

      if (isInput) {
        controllers.writeln('Sink<$templateType> get $name => _$inputName.sink;');
      }
      if (isOutput || isInputOutput) {
        controllers.writeln('Stream<$templateType> get $name => _$inputName.stream;');
      }

      if (isInputOutput) {
        controllers
            .writeln('Sink<$templateType> get set${name[0].toUpperCase()}${name.substring(1)} => _$inputName.sink;');
        controllers
            .writeln('$templateType get current${name[0].toUpperCase()}${name.substring(1)} => _$inputName.value;');
      }

      if (isInput || isOutput || isInputOutput) {
        controllers.writeln();
        controllersDisposer.writeln('_$inputName?.close();');
      }

      if (isExported) {
        parameters.writeln('$inputType get $inputName => template.$inputName;');
      }
    }, method: (Element element) {
      if (findMetadata(element, '@BLoCMapper')) {
        for (final ElementAnnotation metadata in getMetadata(element, '@BLoCMapper')) {
          final List<String> inputs = findInputs(metadata);
          final String name = findName(element);

          mappers.write('''
            _${inputs[0]}.stream.listen((inputData) {
              template.$name(inputData).forEach((newData) {
                _${inputs[1]}.sink.add(newData);
              });
            });
          ''');
        }
      }
    }));

    yield '''
      class $bloc extends BLoCTemplate {
        final ${element.name} template;

        $parameters

        $services

        $controllers

        $values

        $servicesTrigger

        $bloc${parametersList.toString() == '' ? '()' : '''
        ({
          $parametersList
        })
        '''} : template = ${element.name}($namedParameters) {
          $valueUpdaters

          $mappers

          $servicesInit
        }

        @override
        void dispose() {
          template.dispose();

          $servicesDispose
          $controllersDisposer
        }
      }
    ''';
  }
}
