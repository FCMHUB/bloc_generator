import "dart:async";
import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";

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
	StreamSubscription<String> subscription;

	@override
	void init(Stream<String> stream) async {
		subscription = stream.listen((String inputData) {
			print("Counter set to: $inputData");
		});
	}

	@override
	void dispose() {
		subscription?.cancel();
	}
}