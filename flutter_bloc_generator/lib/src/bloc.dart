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

    List<ElementAnnotation> allServices = <ElementAnnotation>[];
    if (findMetadata(element, "@BLoCRequireInputService")) {
      allServices.addAll(getMetadata(element, "@BLoCRequireInputService"));
    }
    if (findMetadata(element, "@BLoCRequireOutputService")) {
      allServices.addAll(getMetadata(element, "@BLoCRequireOutputService"));
    }
    if (findMetadata(element, "@BLoCRequireBLoCService")) {
      allServices.addAll(getMetadata(element, "@BLoCRequireBLoCService"));
    }
    allServices.forEach((ElementAnnotation metadata) {
      List<String> inputs = findInputs(metadata);
      servicesList[inputs[0]] = {
        "name": "${inputs[0][0].toLowerCase()}${inputs[0].substring(1)}",
        "input": inputs.length > 1 ? inputs[1] : "this"
      };
    });

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

          mappers += """
								_${inputs[0]}.stream.listen((inputData) async {
									final newData = await template.$name(inputData);
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
