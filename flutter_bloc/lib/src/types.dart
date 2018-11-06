abstract class Service<T> {
	void init(Sink<T> sink);
	void dispose();
}