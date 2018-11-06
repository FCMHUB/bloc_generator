class BLoC {
  final bool provider;
  final bool disposer;

  const BLoC({this.provider = true, disposer = true})
      : assert(provider != null),
        assert(disposer != null),
        this.disposer = provider ? disposer : false;
}

class BLoCInput {
  const BLoCInput();
}

class BLoCOutput {
  const BLoCOutput();
}

class BLoCValue {
  final String outputName;
  const BLoCValue(this.outputName) : assert(outputName != null);
}

class BLoCMapper {
  final String inputName;
  final String outputName;

  const BLoCMapper(this.inputName, this.outputName)
      : assert(inputName != null),
        assert(outputName != null);
}

class BLoCService {
  final String serviceName;
  final String inputName;

  const BLoCService(this.serviceName, this.inputName)
      : assert(serviceName != null),
        assert(inputName != null);
}
