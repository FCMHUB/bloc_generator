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
			if(int.parse(counter) >= 20) {
				print(
					"Looks like you hit 20!\n"
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