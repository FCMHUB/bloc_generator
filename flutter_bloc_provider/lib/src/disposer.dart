import "package:flutter/material.dart";
import "package:bloc_annotations/bloc_annotations.dart";
import "package:flutter_bloc_provider/src/provider.dart";

class BLoCDisposer<BLoCT extends BLoCTemplate> extends StatefulWidget {
  final Widget child;
  final BLoCT bloc;

  BLoCDisposer({@required this.child, @required this.bloc})
      : assert(child != null),
        assert(bloc != null);

  _BLoCDisposerState<BLoCT> createState() => _BLoCDisposerState<BLoCT>();
}

class _BLoCDisposerState<BLoCT extends BLoCTemplate>
    extends State<BLoCDisposer> {
  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BLoCProvider<BLoCT>(child: widget.child, bloc: widget.bloc);
}
