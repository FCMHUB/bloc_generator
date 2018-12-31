# flutter_bloc_annotations

## Installation

```yaml
dependencies:
  flutter_bloc_annotations: <latest_version>
```

## Import Requirements

`flutter_bloc_annotations` uses the `@required` annotation from `package:flutter/material.dart`.
This needs to be imported as the generated `part` file cannot have import statements. Any `services`
that are used also need to be imported.

## Class Member Requirements

All the members of your BLoC class that have annotations must be public as the generated code uses
them. Members without annotations can still be used in `@BLoCMapper` methods as the member is called
and not copied to the output class. `@BLoCValue`s initial data will not be copied to the `BLoC`
class and will have no effect on the initial data.

## Different Controllers

Using `StreamController` isn't required so `rxdart`s `subject`s such as `BehaviourSubject`
can be used as shown in the
[example](https://github.com/CallumIddon/flutter_bloc_generator/tree/master/example/lib/bloc.dart).

## Output Class

The output class can be seen in the generated `.bloc.dart` file. The `BLoC` class defines the inputs
and outputs of the bloc and calls your `@BLoCMappers` when somthing is added to the input streams
and adds the output to the output streams. The `BLoC` class will also create, initialize and dispose
of any services you require.

## Services

Services are automated parts of a `BLoC`. They can be inputs, outputs, consume the entire `BLoC`,
be a mapper or be triggered manually. You can find all the available services
[here](lib/src/types.dart).

## Example

An extensive example can be found in the root
[example/](https://github.com/CallumIddon/flutter_bloc_generator/tree/master/example) directory.