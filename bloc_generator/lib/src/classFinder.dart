import "package:analyzer/dart/element/element.dart";

class ClassFinder extends ElementVisitor {
  void Function(Element) field;
  void Function(Element) method;

  ClassFinder({this.field, this.method})
      : assert(field != null),
        assert(method != null);

  visitFieldElement(FieldElement element) => field(element);
  visitMethodElement(MethodElement element) => method(element);

  visitClassElement(ClassElement element) => null;
  visitCompilationUnitElement(CompilationUnitElement element) => null;
  visitConstructorElement(ConstructorElement element) => null;
  visitExportElement(ExportElement element) => null;
  visitFieldFormalParameterElement(FieldFormalParameterElement element) => null;
  visitFunctionElement(FunctionElement element) => null;
  visitFunctionTypeAliasElement(FunctionTypeAliasElement element) => null;
  visitGenericFunctionTypeElement(GenericFunctionTypeElement element) => null;
  visitImportElement(ImportElement element) => null;
  visitLabelElement(LabelElement element) => null;
  visitLibraryElement(LibraryElement element) => null;
  visitLocalVariableElement(LocalVariableElement element) => null;
  visitMultiplyDefinedElement(MultiplyDefinedElement element) => null;
  visitParameterElement(ParameterElement element) => null;
  visitPrefixElement(PrefixElement element) => null;
  visitPropertyAccessorElement(PropertyAccessorElement element) => null;
  visitTopLevelVariableElement(TopLevelVariableElement element) => null;
  visitTypeParameterElement(TypeParameterElement element) => null;
}
