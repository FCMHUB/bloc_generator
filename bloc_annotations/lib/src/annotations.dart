// Copyright 2019 Callum Iddon
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Specifies a class that will be converted to a BLoC.
class BLoC {
  const BLoC();
}

/// Specifies a BLoC class member is an input stream.
class BLoCInput {
  const BLoCInput();
}

/// Specifies a BLoC class member is an output stream.
class BLoCOutput {
  const BLoCOutput();
}

/// Specifies a BLoC class member will store the last value of an output stream
/// called [outputName].
class BLoCValue {
  /// Name of the output stream that will update this value.
  final String outputName;
  const BLoCValue(this.outputName) : assert(outputName != null);
}

/// A parameter that will need to be added to the BLoC class and provided to the
/// BLoC either directly or through a provider or disposer. The parameter will
/// be passed to the constructor of the BLoC with a nameed parameter of [name].
class BLoCParameter {
  /// Type the provided parameter must be.
  final Type type;

  /// Name to give the parameter when passed to the constructor.
  final String name;

  const BLoCParameter(this.type, this.name);
}

/// Allows a member variable to be accessible through the generated BLoC class.
class BLoCExportMember {
  const BLoCExportMember();
}

/// Specifies a BLoC class member that will be called when data is added to the
/// [inputName] stream. The return value will be added to the [outputName]
/// stream.
class BLoCMapper {
  /// The input stream to connect the mapper to.
  final String inputName;

  /// The output stream to connect the mapper to.
  final String outputName;

  const BLoCMapper(this.inputName, this.outputName)
      : assert(inputName != null),
        assert(outputName != null);
}

/// Specifies a MapperService class that will be called when data is added to
/// the [inputName] stream. The return value will be added to the [outputName]
/// stream. Make sure [mapper] is imported in the main file so the bloc can
/// access it.
class BLoCRequireMapperService {
  /// The mapper class to be called.
  final Type mapper;

  /// The input stream to connect the mapper to.
  final String inputName;

  /// The output stream to connect the mapper to.
  final String outputName;

  const BLoCRequireMapperService(this.mapper, this.inputName, this.outputName)
      : assert(mapper != null),
        assert(inputName != null),
        assert(outputName != null);
}

/// Specifies a [service] to be used by the BLoC and will contect to the Sink of
/// the [controllerName].
class BLoCRequireInputService {
  /// The input service class to be used.
  final Type service;

  /// The input stream to connect the service to.
  final dynamic controllerName;

  const BLoCRequireInputService(this.service, this.controllerName)
      : assert(service != null),
        assert(controllerName != null);
}

/// Specifies a [service] to be used by the BLoC and will contected to the
/// Stream of the [controllerName].
class BLoCRequireOutputService {
  /// The output service class to be used.
  final Type service;

  /// The output stream to connect the service to.
  final String controllerName;

  const BLoCRequireOutputService(this.service, this.controllerName)
      : assert(service != null),
        assert(controllerName != null);
}

/// Specifies a [service] to be used by the BLoC and will be provided with the
/// entire BLoC.
class BLoCRequireBLoCService {
  /// The BLoC service class to be used.
  final Type service;

  const BLoCRequireBLoCService(this.service) : assert(service != null);
}

/// Specified a [service] to be used by the BLoC and will be available on the
/// BLoC to be called by your app.
class BLoCRequireTriggerService {
  /// The trigger service to be used.
  final Type service;

  const BLoCRequireTriggerService(this.service) : assert(service != null);
}
