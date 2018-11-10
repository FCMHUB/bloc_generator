import "dart:async";
import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";
import "bloc.dart";

class SetService extends InputService<int> {
	@override
	void init(Sink<int> sink) async {
		await Future.delayed(Duration(seconds: 10));
		sink.add(10);
	}

	@override
	void dispose() {}
}

class PrintService extends OutputService<String> {
	@override
	void listen(String inputData) {
		print("Counter set to: $inputData");
	}
}

class MaxService extends BLoCService<TestBLoC> {
	StreamSubscription<String> _counterSub;

	@override
	void init(TestBLoC bloc) {
		_counterSub = bloc.counter.listen((String counter) {
			if(int.parse(counter) >= bloc.maxValue) {
				print(
					"Looks like you hit ${bloc.maxValue}\n"
					"Resetting..."
				);
				bloc.setCounter.add(0);
			}
		});
	}

	@override
	void dispose() {
		_counterSub.cancel();
	}
}

class TriggeredService extends TriggerService<TestBLoC> {
	@override
	Future<void> trigger(TestBLoC bloc) async {
		print(
			"                                                                       \n"
			"Counter currently set to ${bloc.currentCounter}.                       \n"
			"Tap on the FAB to increase the counter.                                \n"
			"Tap 'Reset Counter' to set the counter to 0.                           \n"
			"                                                                       \n"
		);
		print(
			"A BLoC consists of inputs, outputs, values, mappers and paramaters.    \n"
			"Inputs and outputs must be controllers that provide Streams and Sinks  \n"
			"e.g. StreamController                                                  \n"
			"Optionally a provider and disposer can be created that provide helper  \n"
			"classes. A provider is an Inherited widget that will make the BloC     \n"
			"available by calling 'Provider.of(context)'.                           \n"
			"A disposer is a Stateful widget that will automatically call dispose   \n"
			"when the disposer is disposed by the flutter framework.                \n"
			"                                                                       \n"
		);
		print(
			"Mappers provide the bridge between inputs and outputs.                 \n"
			"They are async functions that take in the input from the input         \n"
			"stream and their return is added to the output stream.                 \n"
			"If a mapper returns null it won't be added to the output stream.       \n"
			"                                                                       \n"
		);
		print(
			"Values store the latest value on the BLoC for easy refrence,           \n"
			"especially in mappers that want the last value from another output.    \n"
			"                                                                       \n"
			"Paramaters are values that the BLoC receives on initialization and     \n"
			"must be passed in the constructor to the BLoC or disposer.             \n"
			"                                                                       \n"
			"This print is in a service, it can do anything you want.               \n"
			"                                                                       \n"
		);
		print(
			"There are 4 types of services; input, output, BLoC and trigger.        \n"
			"Input and output take in a Stream or Sink, respective of their         \n"
			"type, from the BLoC. They can then use it to modify the BLoC           \n"
			"or receive updates from the BLoC.                                      \n"
			"                                                                       \n"
			"BLoC services take in the entire BLoC and have access to               \n"
			"everything on the BLoC.                                                \n"
			"                                                                       \n"
			"Trigger services have access to the entire BLoC but must be triggerd by\n"
			"other code that has access to the BLoC.                                \n"
			"                                                                       \n"
		);
	}

	@override
	void dispose() {}
}