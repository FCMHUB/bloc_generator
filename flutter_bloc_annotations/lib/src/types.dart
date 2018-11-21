import "dart:async";
import "package:meta/meta.dart";

/// A service that adds items to a input on a BLoC. [init] is called when the BLoC starts the
/// service and [dispose] when the BLoC closes the service.
abstract class InputService<T> {
  void init(Sink<T> sink);
  void dispose() {}
}

/// A service that takes an output from a BLoC. Automatically calles [listen] when the stream from
/// the BLoC is updated. Optionally [init] is called when the BLoC starts the service and [dispose]
/// when the BLoC closes the service.
abstract class OutputService<T> {
  StreamSubscription<T> _subscription;
  StreamSubscription<T> get subscription => _subscription;

  @mustCallSuper
  void init(Stream<T> stream) {
    _subscription = stream.listen(listen);
  }

  void listen(T inputData);

  @mustCallSuper
  void dispose() {
    _subscription?.cancel();
  }
}

/// A service that taken in an entire BLoC. Useful if you want access to multiple inputs and outputs
/// on the BLoC in one service. Also useful for passing variables to services.
abstract class BLoCService<T> {
  void init(T bloc);
  void dispose() {}
}

/// A service that can be triggered by anything with access to the BLoC. Takes in the entire bloc
/// when triggered. Useful for validating and submitting forms.
abstract class TriggerService<T> {
  Future<void> trigger(T bloc);
  void dispose() {}
}

/// A service that acts as a BLoCMapper that can be reused between BLoCs.
abstract class MapperService<INPUTTYPE, OUTPUTTYPE> {
  OUTPUTTYPE map(INPUTTYPE inputData);
  void dispose() {}
}

/// A MapperrService that is asynchronous.
abstract class AsyncMapperService<INPUTTYPE, OUTPUTTYPE> {
  Future<OUTPUTTYPE> map(INPUTTYPE inputData);
  void dispose() {}
}
