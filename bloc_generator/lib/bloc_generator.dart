import "package:build/build.dart";
import "package:source_gen/source_gen.dart";

import "package:bloc_generator/src/bloc.dart";

Builder bloc(BuilderOptions options) =>
    PartBuilder([BLoCGenerator(options)], ".bloc.dart");
