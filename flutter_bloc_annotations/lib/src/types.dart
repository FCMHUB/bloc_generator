import "dart:async";
import "package:meta/meta.dart";

/// Specifies the methods that the generated BLoC code will call when requiring a service.
/// [init] is called when the service is started and [dispose] is called when the BLoC is disposed.
abstract class InputService<T> {
  void init(Sink<T> sink);
  void dispose();
}

/// Specifies the methods that the generated BLoC code will call when requiring a service.
/// [init] is called when the service is started, [listen] is called when the stream is updated and
/// [dispose] is called when the BLoC is disposed.
abstract class OutputService<T> {
  StreamSubscription<T> _subscription;

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
