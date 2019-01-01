import "dart:async";
import "package:meta/meta.dart";

abstract class BLoCTemplate {
  void dispose();
}

abstract class Service {
  void dispose() {}
}

/// A service that adds items to a input on a BLoC. [init] is called when the BLoC starts the
/// service and [dispose] when the BLoC closes the service.
abstract class InputService<T> extends Service {
  void init(Sink<T> sink);
}

/// A service that takes an output from a BLoC. Automatically calles [listen] when the stream from
/// the BLoC is updated. Optionally [init] is called when the BLoC starts the service and [dispose]
/// when the BLoC closes the service.
abstract class OutputService<T> extends Service {
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
abstract class BLoCService<T> extends Service {
  void init(T bloc);
}

/// A service that can be triggered by anything with access to the BLoC. Takes in the entire bloc
/// when triggered. Useful for validating and submitting forms.
abstract class TriggerService<T> extends Service {
  Future<void> trigger(T bloc);
}

/// A service that acts as a BLoCMapper that can be reused between BLoCs.
abstract class MapperService<I, O> extends Service {
  Stream<O> map(I inputData);
}
