# bloc_generator

This package is part of a number of packages designed to help create BLoC
architected code in Dart and Flutter. You can view them all in the repository
[here](https://github.com/CallumIddon/bloc_generator).

This README relies on the fact that you have read the main
[README](https://github.com/CallumIddon/bloc_generator/tree/master/README.md).

## Installation

```yaml
dev_dependencies:
  build_runner: <latest_version>
  bloc_generator: <latest_version>
```

### Output

`bloc_generator` outputs a `.bloc.dart` file in the same directory as the
template file using the annotations. This file is a `part of` file that needs to
be a `part` of the original file. To generate the files use `build_runner`s
command line package to build out any annotations. E.g.:

```bash
$ pub run build_runner build
```

or to watch for changes:

```bash
$ pub run build_runner watch
```

or using the flutter tool:

```bash
$ flutter packages pub run build_runner build
```
