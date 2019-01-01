import "dart:async";
import "package:rxdart/rxdart.dart";
import "package:flutter/material.dart";
import "package:bloc_annotations/bloc_annotations.dart";
import "package:flutter_bloc_example/services.dart";
part "bloc.bloc.dart";

@BLoC()
@BLoCRequireInputService(SetService, "setCounter")
@BLoCRequireOutputService(PrintService, "counter")
@BLoCRequireBLoCService(MaxService)
@BLoCRequireTriggerService(TutorialService)
@BLoCRequireMapperService(StringifyMapper, "setCounter", "counter")
class _Test {
	@BLoCParamater()
	int maxValue;

	@BLoCInput()
	StreamController<int> setCounter = StreamController<int>();
	@BLoCInput()
	StreamController<int> addToCounter = StreamController<int>();

	@BLoCOutput()
	BehaviorSubject<String> counter = BehaviorSubject<String>(seedValue: "0");

	@BLoCValue("counter")
	String currentCounter;

	@BLoCMapper("addToCounter", "counter")
	Stream<String> setAddToCounterBLoC(int inputData) async* {
		yield (int.parse(currentCounter) + inputData).toString();
	}
}