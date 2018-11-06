# flutter_bloc_generator

## Usage

Add `flutter_bloc_generator` and `build_runner` as `dev_dependencies` to make the `build_runner` cli
and `BLoCGenerator` available for generation.

```yaml
dev_dependencies:
  build_runner: <latest_version>
  flutter_bloc_generator: <latest_version>
```

### Output

`flutter_bloc_generator` outputs a `.bloc.dart` file in the same directory as the file using the
annotations. This file is a `part of` file that needs to be a `part` of the original file. To
generate the files use `build_runner`s command line package to build out any annotations. E.g.

```
> flutter packages pub run build_runner build
```

or to watch for changes:

```
> flutter packages pub run build_runner watch
```

## Example

A more extensive example can be found in the root
[example/](https://github.com/CallumIddon/flutter_bloc_generator/tree/master/example) directory.