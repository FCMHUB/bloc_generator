/// A full example is available a https://github.com/CallumIddon/flutter_bloc_generator/example

// main.dart
import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";
import "service.dart";
part "main.bloc.dart";

@BLoC()
@BLoCService("TestService", "setCounter")
class _Test {
  @BLoCInput()
  StreamController<int> setCounter = StreamController<int>();

  @BLoCOutput()
  StreamController<int> counter = StreamController<int>();

  @BLoCValue("counter")
  int counterValue;

  @BLoCMapper("setCounter", "counter")
  int setCounterToCounter(int inputData, int currentData) => inputData;
}

// service.dart
import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";

class TestService extends Service<int> {
  @override
  void init(Sink<int> sink) async {
    await Future.delayed(Duration(seconds: 10));
    sink.add(10);
  }

  @override
  void dispose() {}
}