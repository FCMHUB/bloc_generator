import "package:flutter/material.dart";
import "package:bloc_annotations/bloc_annotations.dart";

class BLoCProvider<BLoCT extends BLoCTemplate> extends InheritedWidget {
  final Widget child;
  final BLoCT bloc;

  BLoCProvider({@required this.child, @required this.bloc})
      : assert(child != null),
        assert(bloc != null);

  static BLoCT of<BLoCT extends BLoCTemplate>(BuildContext context) {
    final Type providerType = _type<BLoCProvider<BLoCT>>();
    final BLoCProvider provider =
        context.inheritFromWidgetOfExactType(providerType) as BLoCProvider;

    if (provider == null) {
      throw FlutterError("Unable to find BLoC of type $BLoCT.\n"
          "Is the provided context from below the provider or disposer?\n"
          "Context provided: $context");
    }
    return provider.bloc;
  }

  static Type _type<T>() => T;

  @override
  bool updateShouldNotify(BLoCProvider old) => true;
}
