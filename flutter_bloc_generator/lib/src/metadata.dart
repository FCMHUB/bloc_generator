import "package:analyzer/dart/element/element.dart";

bool findMetadata(Element element, String metadataName) {
  bool foundMetadata = false;
  for (ElementAnnotation metadata in element.metadata) {
    if (metadata.toSource().startsWith(metadataName)) {
      foundMetadata = true;
      break;
    }
  }
  return foundMetadata;
}

List<ElementAnnotation> getMetadata(Element element, String metadataName) {
  if (!findMetadata(element, metadataName)) {
    throw Exception("$element does not have a $metadataName");
  }
  List<ElementAnnotation> foundMetadata = <ElementAnnotation>[];
  for (ElementAnnotation metadata in element.metadata) {
    if (metadata.toSource().startsWith(metadataName)) {
      foundMetadata.add(metadata);
    }
  }
  return foundMetadata;
}

List<String> findInputs(ElementAnnotation metadata) => metadata
        .toSource()
        .split("(")[1]
        .split(")")[0]
        .split(", ")
        .map((String input) {
      String output = input;
      if (output.startsWith("\"")) {
        output = output.substring(1);
      }
      if (output.endsWith("\"")) {
        output = output.substring(0, output.length - 1);
      }
      return output;
    }).toList();

bool checkMethod(Element element) => element.toString().indexOf("(") != -1;

String findName(Element element) {
  String name = element.toString();
  if (checkMethod(element)) {
    return name.substring(0, name.indexOf("("));
  }
  return name.split(" ").removeLast();
}

String findType(Element element) {
  if (checkMethod(element)) {
    String type = element.toString().split("→").reversed.toList()[0];
    return type.substring(1);
  }
  final List<String> name = element.toString().split(" ").reversed.toList();
  name.removeAt(0);
  return name.join(" ");
}

String findTemplateType(Element element) {
  List<String> typeList = findType(element).split("<");
  typeList.removeAt(0);
  String type = typeList.join("<");
  return type.substring(0, type.length - 1);
}
