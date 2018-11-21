import "dart:async";
import "package:build/build.dart";
import "package:analyzer/dart/element/element.dart";
import "package:build/src/builder/build_step.dart";
import "package:source_gen/source_gen.dart";

import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";

import "package:flutter_bloc_generator/src/classFinder.dart";
import "package:flutter_bloc_generator/src/metadata.dart";

enum ServiceMetadataType { input, output, bloc, trigger, mapper, asyncMapper }

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
  Stream<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async* {
    final String name =
        element.name[0] == "_" ? element.name.substring(1) : element.name;
    final String bloc = "${name}BLoC";

    List<ServiceMetadata> allServices = <ServiceMetadata>[];
    if (findMetadata(element, "@BLoCRequireInputService")) {
      allServices.add(ServiceMetadata(ServiceMetadataType.input,
          getMetadata(element, "@BLoCRequireInputService")));
    }
    if (findMetadata(element, "@BLoCRequireOutputService")) {
      allServices.add(ServiceMetadata(ServiceMetadataType.output,
          getMetadata(element, "@BLoCRequireOutputService")));
    }
    if (findMetadata(element, "@BLoCRequireBLoCService")) {
      allServices.add(ServiceMetadata(ServiceMetadataType.bloc,
          getMetadata(element, "@BLoCRequireBLoCService")));
    }
    if (findMetadata(element, "@BLoCRequireTriggerService")) {
      allServices.add(ServiceMetadata(ServiceMetadataType.trigger,
          getMetadata(element, "@BLoCRequireTriggerService")));
    }
    if (findMetadata(element, "@BLoCRequireMapperService")) {
      allServices.add(ServiceMetadata(ServiceMetadataType.mapper,
          getMetadata(element, "@BLoCRequireMapperService")));
    }
    if (findMetadata(element, "@BLoCRequireAsyncMapperService")) {
      allServices.add(ServiceMetadata(ServiceMetadataType.asyncMapper,
          getMetadata(element, "@BLoCRequireAsyncMapperService")));
    }

    String services = "";
    String servicesInit = "";
    String servicesTrigger = "";
    String servicesDispose = "";

    String mappers = "";

    allServices.forEach((ServiceMetadata service) {
      service.metadata.forEach((ElementAnnotation metadata) {
        List<String> inputs = findInputs(metadata);
        String serviceType = inputs[0];
        String serviceName =
            "${inputs[0][0].toLowerCase()}${inputs[0].substring(1)}";
        String inputName = service.type == ServiceMetadataType.bloc ||
                service.type == ServiceMetadataType.trigger
            ? "this"
            : inputs[1];

        services += "$serviceType $serviceName = $serviceType();\n";

        if (service.type != ServiceMetadataType.trigger &&
            service.type != ServiceMetadataType.mapper &&
            service.type != ServiceMetadataType.asyncMapper) {
          servicesInit += "$serviceName.init($inputName);\n";
        } else if (service.type == ServiceMetadataType.mapper ||
            service.type == ServiceMetadataType.asyncMapper) {
          bool future = service.type == ServiceMetadataType.asyncMapper;
          mappers += """
				_${inputs[1]}.stream.listen((inputData) ${future ? "async" : ""} {
					final newData = ${future ? "await" : ""} $serviceName.map(inputData);
					if(newData != null) {
						_${inputs[2]}.sink.add(newData);
					}
				});
			""";
        } else if (service.type == ServiceMetadataType.trigger) {
          final String triggerName = "trigger${serviceName[0].toUpperCase()}"
              "${serviceName.substring(1)}";
          servicesTrigger +=
              "Future<void> $triggerName() async => await $serviceName.trigger(this);\n";
        }
        servicesDispose += "$serviceName.dispose();\n";
      });
    });

    String controllers = "";
    String controllersInit = "";
    String controllersDisposer = "";

    String values = "";
    String valueUpdaters = "";

    String paramaters = "";
    String paramatersList = "";
    String paramatersInit = "";
    String paramatersPasser = "";
    List<String> paramatersAssert = <String>[];
    String paramatersInput = "";

    Map<String, String> currentValues = <String, String>{};

    element.visitChildren(ClassFinder(field: (Element element) {
      String inputType = findType(element);
      String inputName = findName(element);

      bool isInput = findMetadata(element, "@BLoCInput");
      bool isOutput = findMetadata(element, "@BLoCOutput");
      bool isValue = findMetadata(element, "@BLoCValue");
      bool isParamater = findMetadata(element, "@BLoCParamater");

      String templateType;
      if (isInput || isOutput) {
        templateType = findTemplateType(element);
      }

      String name = inputName[0] == "_" ? inputName.substring(1) : inputName;

      if (isInput || isOutput) {
        controllers += "$inputType _$inputName;\n";
        controllersInit += "_$inputName = template.$inputName;\n";
      } else if (isValue) {
        values += "$inputType get $name => template.$inputName;\n\n";

        getMetadata(element, "@BLoCValue")
            .forEach((ElementAnnotation metadata) {
          String output = findInputs(metadata)[0];
          currentValues[output] = name;
          valueUpdaters += """
								_$output.stream.listen((inputData) {
									template.$inputName = inputData;
								});
							""";
        });
      } else if (isParamater) {
        final String setName =
            "set${name[0].toUpperCase()}${name.substring(1)}";
        paramaters += """
							$inputType get $name => template.$name;
							set $setName($inputType value) => template.$name = value;
						""";
        paramatersList += "@required $inputType $name,\n";
        paramatersInit += "this.$setName = $name;\n";
        paramatersPasser += "$name: $name,\n";
        paramatersAssert.add("$name != null");
      }

      if (isInput) {
        controllers += "Sink<$templateType> get $name => _$inputName.sink;\n";
      }
      if (isOutput) {
        controllers +=
            "Stream<$templateType> get $name => _$inputName.stream;\n";
      }

      if (isInput || isOutput) {
        controllers += "\n";
        controllersDisposer += "_$inputName?.close();\n";
      }
    }, method: (Element element) {
      if (findMetadata(element, "@BLoCMapper")) {
        getMetadata(element, "@BLoCMapper")
            .forEach((ElementAnnotation metadata) {
          List<String> inputs = findInputs(metadata);
          String name = findName(element);
          bool future = findType(element).startsWith("Future");

          mappers += """
						_${inputs[0]}.stream.listen((inputData) ${future ? "async" : ""} {
							final newData = ${future ? "await" : ""} template.$name(inputData);
							if(newData != null) {
								_${inputs[1]}.sink.add(newData);
							}
						});
					""";
        });
      }
    }));

    final String paramatersAssertString =
        "assert(${paramatersAssert?.join(" && ")})";

    yield """
			class $bloc {
				${element.name} template = ${element.name}();

				$services

				$controllers

				$values

				$paramaters

				$servicesTrigger

				$bloc${paramatersList == "" ? "()" : """
				({
					$paramatersList
				}) : $paramatersAssertString
				"""} {
					$paramatersInit

					$controllersInit

					$valueUpdaters

					$mappers

					$servicesInit
				}

				void dispose() {
					$servicesDispose
					$controllersDisposer
				}
			}
		""";

    final bool buildProvider = annotation.read("provider").boolValue;
    final String provider = "${name}Provider";

    if (buildProvider) {
      yield """
				class $provider extends InheritedWidget {
					final Widget child;
					final $bloc bloc;

					$provider({
						@required this.child,
						@required this.bloc
					}) : assert(child != null),
						assert(bloc != null),
						super(child: child);

					static $bloc of(BuildContext context) =>
						(context.inheritFromWidgetOfExactType($provider) as $provider).bloc;

					@override
					bool updateShouldNotify(InheritedWidget old) => old.child != child;
				}
			""";
    }

    final bool buildDisposer = annotation.read("disposer").boolValue;
    final String disposer = "${name}Disposer";
    final String disposerState = "_${disposer}State";

    if (buildDisposer) {
      yield """
				class $disposer extends StatefulWidget {
					final Widget child;
					final $bloc bloc;
					$paramatersInput

					$disposer({
						@required this.child,
						bloc,
						${paramatersList != "" ? paramatersList : ""}
					}) : this.bloc = bloc ?? $bloc($paramatersPasser);

					@override
					$disposerState createState() => $disposerState();
				}

				class $disposerState extends State<$disposer> {
					@override
					void dispose() {
						super.dispose();
						widget.bloc.dispose();
					}

					@override
					Widget build(BuildContext context) {
						return $provider(
							child: widget.child,
							bloc: widget.bloc
						);
					}
				}
			""";
    }
  }
}
