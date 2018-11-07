import "dart:async";
import "package:build/build.dart";
import "package:analyzer/dart/element/element.dart";
import "package:build/src/builder/build_step.dart";
import "package:source_gen/source_gen.dart";

import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";

import "package:flutter_bloc_generator/src/classFinder.dart";
import "package:flutter_bloc_generator/src/metadata.dart";

class BLoCGenerator extends GeneratorForAnnotation<BLoC> {
  BuilderOptions options;
  BLoCGenerator(this.options);

  @override
  Stream<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async* {
    final String name =
        element.name[0] == "_" ? element.name.substring(1) : element.name;
    final String bloc = "${name}BLoC";

    final Map<String, Map<String, String>> servicesList =
        <String, Map<String, String>>{};
    if (findMetadata(element, "@BLoCService")) {
      getMetadata(element, "@BLoCService")
          .forEach((ElementAnnotation metadata) {
        List<String> inputs = findInputs(metadata);
        servicesList[inputs[0]] = {
          "name": "${inputs[0][0].toLowerCase()}${inputs[0].substring(1)}",
          "input": inputs[1]
        };
      });
    }

    String services = "";
    String servicesInit = "";
    String servicesDispose = "";

    servicesList.keys.forEach((String service) {
      final String serviceName = servicesList[service]["name"];
      final String inputName = servicesList[service]["input"];

      services += "$service $serviceName = $service();\n";
      servicesInit += "$serviceName.init($inputName);\n";
      servicesDispose += "$serviceName.dispose();\n";
    });

    String controllers = "";
    String controllersInit = "";
    String controllersDisposer = "";

    String values = "";
    String valueUpdaters = "";

    String mappers = "";

    Map<String, String> currentValues = <String, String>{};

    element.visitChildren(ClassFinder(field: (Element element) {
      String inputType = findType(element);
      String inputName = findName(element);

      bool isInput = findMetadata(element, "@BLoCInput");
      bool isOutput = findMetadata(element, "@BLoCOutput");
      bool isValue = findMetadata(element, "@BLoCValue");

      String templateType;
      if (isInput || isOutput) {
        templateType = findTemplateType(element);
      }

      String name;
      if (isInput) {
        name = inputName[0] == "_" ? inputName.substring(1) : inputName;
      } else if (isOutput) {
        name = inputName[0] == "_" ? inputName.substring(1) : inputName;
      } else if (isValue) {
        name = inputName[0] == "_" ? inputName.substring(1) : inputName;
      }

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

          mappers += """
								_${inputs[0]}.stream.listen((inputData) {
									_${inputs[1]}.sink.add(template.$name(inputData));
								});
							""";
        });
      }
    }));

    yield """
			class $bloc {
				${element.name} template = ${element.name}();

				$services

				$controllers

				$values

				$bloc() {
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

					$disposer({
						@required this.child
					});

					@override
					$disposerState createState() => $disposerState();
				}

				class $disposerState extends State<$disposer> {
					$bloc bloc = $bloc();

					@override
					void dispose() {
						super.dispose();
						bloc?.dispose();
					}

					@override
					Widget build(BuildContext context) {
						return $provider(
							child: widget.child,
							bloc: bloc
						);
					}
				}
			""";
    }
  }
}
