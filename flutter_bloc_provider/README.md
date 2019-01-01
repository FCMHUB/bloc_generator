# flutter_bloc_provider

## Installation

```yaml
dependencies:
  flutter_bloc_provider: <latest_version>
```

## Provider

A `BLoCProvider<BLoC>` is an `Inherited Widget` that allows the `BLoC` to be accessible to all
sub widgets. Calling `BLoCProvider<BLoC>.of(context)` will return the `BLoC` from the tree.

Make sure you call the `dispose` method of the `BLoCProvider` when you are done with it to close
any open streams and stop any services.

## Disposer

A `BLoCDisposer<BLoC>` is a `Stateful Widget` that wraps a child in a `BLoCProvider`. The disposer
will automatically call the dispose method on the provider when it loses context.

## Example

An extensive example can be found in the root
[example/](https://github.com/CallumIddon/bloc_generator/tree/master/example) directory.