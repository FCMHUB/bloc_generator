import "dart:async";
import "package:rxdart/rxdart.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_bloc_example/services.dart";
part "bloc.bloc.dart";

@BLoC()
@BLoCService("SetService", "setCounter")
@BLoCService("AddService", "addToCounter")
class _Test {
	@BLoCInput()
	StreamController<int> setCounter = StreamController<int>();
	@BLoCInput()
	StreamController<int> addToCounter = StreamController<int>();

	@BLoCOutput()
	BehaviorSubject<String> counter = BehaviorSubject<String>(seedValue: "0");

	@BLoCValue("counter")
	String currentCounter;

	@BLoCMapper("setCounter", "counter")
	String setCounterBLoC(int intputData, String currentData) => intputData.toString();

	@BLoCMapper("addToCounter", "counter")
	String setAddToCounterBLoC(int inputData, String currentData) =>
		(int.parse(currentData) + inputData).toString();
}