# flutter_bloc_annotations

## Usage

To import the annotations and `Service` abstract class add `flutter_bloc_annotations` to your
`pubspec.yaml`.

```yaml
dependencies:
  flutter_bloc_annotations: <latest_version>
```

## Import Requirements

`flutter_bloc_annotations` uses `InheritedWidget`, `StatefulWidget`, `State`, `Widget` and
`BuildContext` from `package:flutter/material.dart`. This needs to be imported as the generated
`part` file cannot have import statements. Any `services` that are used also need to be imported.

## Class Member Requirements

All the members of your BLoC class that have annotations must be public as the generated code uses
them. Members without annotations can still be used in `@BLoCMapper` methods as the member is called
and not copied to the output class. `@BLoCValue`s initial data will not be copied to the `BLoC`
class and will have no effect on the initial data.

## Different Controllers

Using `StreamController` isn't required so `rxdart`s `subject`s such as `BehaviourSubject`
can be used as shown in the
[example](https://github.com/CallumIddon/flutter_bloc_generator/tree/master/example/lib/bloc.dart).

## Output Classes

The output classes can be seen in the generated `.bloc.dart` file. Generally a `BLoC`, `Provider`
and `Disposer` are created. The `BLoC` class defines the inputs and outputs of the bloc and calls
your `@BLoCMappers` when somthing is added to the input streams and adds the output to the output
streams. The `BLoC` class will also create, initialize and dispose of any services you require.

## Services

Services are automatic inputs to a `BLoC` that are initialized when the bloc is created. This makes
it easier to make database connections that automatically add to the `BLoC` while still being
testable without creating a an entire `BLoC` to add to as they only require a `Sink` to add to.

## Examples

```dart
// main.dart
import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";
import "service.dart";
part "main.bloc.dart";

@BLoC()
@BLoCService("TestService", "setCounter")
class _Test {
  @BLoCInput()
  StreamController<int> setCounter = StreamController<int>();

  @BLoCOutput()
  StreamController<int> counter = StreamController<int>();

  @BLoCValue("counter")
  int counterValue;

  @BLoCMapper("setCounter", "counter")
  int setCounterToCounter(int inputData, int currentData) => inputData;
}
```

```dart
// service.dart
import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";

class TestService extends InputService<int> {
  @override
  void init(Sink<int> sink) async {
    await Future.delayed(Duration(seconds: 10));
    sink.add(10);
  }

  @override
  void dispose() {}
}
```

More extensive examples can be found in the root
[example/](https://github.com/CallumIddon/flutter_bloc_generator/tree/master/example) directory.