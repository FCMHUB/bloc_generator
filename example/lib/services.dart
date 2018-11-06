import "package:flutter_bloc/flutter_bloc.dart";

class SetService extends Service<int> {
	@override
	void init(Sink<int> sink) async {
		await Future.delayed(Duration(seconds: 10));
		sink.add(10);
	}

	@override
	void dispose() {}
}

class AddService extends Service<int> {
	@override
	void init(Sink<int> sink) async {
		await Future.delayed(Duration(seconds: 20));
		sink.add(5);
	}

	@override
	void dispose() {}
}