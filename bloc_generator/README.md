# bloc_generator

## Installation

```yaml
dev_dependencies:
  build_runner: <latest_version>
  bloc_generator: <latest_version>
```

### Output

`bloc_generator` outputs a `.bloc.dart` file in the same directory as the file using the
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

An extensive example can be found in the root
[example/](https://github.com/CallumIddon/bloc_generator/tree/master/example) directory.