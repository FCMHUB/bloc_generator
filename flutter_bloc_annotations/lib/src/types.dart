/// Specifies the methods that the generated BLoC code will call when requiring a service.
/// [init] is called when the service is started and [dispose] is called when the BLoC is disposed.
abstract class Service<T> {
  void init(Sink<T> sink);
  void dispose();
}
