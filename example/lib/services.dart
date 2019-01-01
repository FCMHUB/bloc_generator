import "dart:async";
import "package:bloc_annotations/bloc_annotations.dart";
import "bloc.dart";

class SetService extends InputService<int> {
	@override
	void init(Sink<int> sink) async {
		await Future.delayed(Duration(seconds: 10));
		sink.add(10);
	}
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

class TutorialService extends TriggerService<TestBLoC> {
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
			"                                                                       \n"
		);
		print(
			"Mappers provide the bridge between inputs and outputs.                 \n"
			"They are async functions that take in the input from the input         \n"
			"stream and any yeilded values are added to the output stream.          \n"
			"                                                                       \n"
		);
		print(
			"Values store the latest value of an output on the BLoC for easy        \n"
			"refrence, especially useful for mappers that want the last value from  \n"
			"another output.                                                        \n"
			"                                                                       \n"
			"Paramaters are values that the BLoC receives on initialization.        \n"
			"                                                                       \n"
			"This print is in a service, it can do anything you want.               \n"
			"                                                                       \n"
		);
		print(
			"There are 5 types of services; input, output, BLoC, trigger and mapper.\n"
			"Input and output take in a Stream or Sink, respective of their         \n"
			"type, from the BLoC. They can then use it to modify the BLoC           \n"
			"or receive updates from the BLoC.                                      \n"
			"                                                                       \n"
			"BLoC services take in the entire BLoC and have access to               \n"
			"everything on the BLoC.                                                \n"
			"                                                                       \n"
			"Trigger services have access to the entire BLoC but must be triggerd by\n"
			"other code that has access to the BLoC e.g. through a provider.        \n"
			"                                                                       \n"
			"Mapper services are the same as a normal mapper but they are stored in \n"
			"a seperate class so they can be reused and tested seperately.          \n"
			"                                                                       \n"
		);
		print(
			"A provider will make the BLoC available to all widgets below itself in \n"
			"the widget tree. It can also retrieve the BLoC for you through the     \n"
			"\"of\" method.                                                         \n"
			"                                                                       \n"
			"A disposer wraps a provider but will automatically call the dispose    \n"
			"method for you when it goes out of context.                            \n"
			"                                                                       \n"
		);
		print(
			"Before running your app you must generate the BLoC. Information on this\n"
			"can be found in the \"flutter_bloc_generator\" README.                 \n"
			"                                                                       \n"
			"The annotations are available in the \"flutter_bloc_annotations\"      \n"
			"package, the generator commands are available in the                   \n"
			"\"flutter_bloc_generator\" package and providers and disposers are     \n"
			"available in the \"flutter_bloc_provider\" package.                    \n"
			"                                                                       \n"
		);
	}
}

class StringifyMapper extends MapperService<int, String> {
	Stream<String> map(int inputData) async* {
		yield inputData.toString();
	}
}