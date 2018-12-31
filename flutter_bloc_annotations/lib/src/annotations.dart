/// Specifies a class that will be converted to a BLoC.
///
/// The BLoC class will be called <Name>BLoC.
/// If [provider] is true an inherited widget with name <name>Provider will be generated.
/// This will allow lower widgets to fetch the generated BLoC by calling Provider.of(context).
///
/// If [disposer] is true a stateful widget with name <name>Disposer will be generated.
/// This widget will automatically create and disposer of a provider and bloc automatically with
/// the lifecycle methods of the statefule widget.
class BLoC {
  final bool disposer;

  const BLoC({this.disposer = true}) : assert(disposer != null);
}

/// Specifies a BLoC class member is an input stream
class BLoCInput {
  const BLoCInput();
}

/// Specifies a BLoC class member is an output stream
class BLoCOutput {
  const BLoCOutput();
}

/// Specifies a BLoC class member will store the last value of an output stream called [outputName]
class BLoCValue {
  final String outputName;
  const BLoCValue(this.outputName) : assert(outputName != null);
}

/// A paramater that will need to be added to the BLoC class and provided to the provider or
/// disposer.
class BLoCParamater {
  const BLoCParamater();
}

/// Specifies a BLoC class member that will be called when data is added to the [inputName] stream.
/// The return value will be added to the [outputName] stream.
class BLoCMapper {
  final String inputName;
  final String outputName;

  const BLoCMapper(this.inputName, this.outputName)
      : assert(inputName != null),
        assert(outputName != null);
}

/// Specifies a MapperService class that will be called when data is added to the [inputName]
/// stream. The return value will be added to the [outputName] stream. Make sure [mapper] is
/// imported in the main file so the bloc can access it.
class BLoCRequireMapperService {
  final Type mapper;
  final String inputName;
  final String outputName;

  const BLoCRequireMapperService(this.mapper, this.inputName, this.outputName)
      : assert(mapper != null),
        assert(inputName != null),
        assert(outputName != null);
}

/// Specifies a [service] to be used by the BLoC and will contect to the Sink of the
/// [controllerName].
class BLoCRequireInputService {
  final Type service;
  final String controllerName;

  const BLoCRequireInputService(this.service, this.controllerName)
      : assert(service != null),
        assert(controllerName != null);
}

/// Specifies a [service] to be used by the BLoC and will contected to the Stream of the
/// [controllerName].
class BLoCRequireOutputService {
  final Type service;
  final String controllerName;

  const BLoCRequireOutputService(this.service, this.controllerName)
      : assert(service != null),
        assert(controllerName != null);
}

/// Specifies a [service] to be used by the BLoC and will be provided with the entire BLoC
class BLoCRequireBLoCService {
  final Type service;

  const BLoCRequireBLoCService(this.service) : assert(service != null);
}

/// Specified a [service] to be used by the BLoC and will be available on the BLoC to be called by
/// your app.
class BLoCRequireTriggerService {
  final Type service;

  const BLoCRequireTriggerService(this.service) : assert(service != null);
}
