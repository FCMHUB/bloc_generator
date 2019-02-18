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

import 'package:flutter/material.dart';

import 'package:bloc_annotations/bloc_annotations.dart';

/// An InheritedWidget that will make the [bloc] accessible to the [child]
/// widget tree. This will not automatically be disposed of, for that
/// functionality see BLoCDisposer<BLoCT>.
/// You can also retrieve a BLoC with the static [of] method by providing the
/// BLoC type and a context that is below the BLoCProvider<BLoCT> or
/// BLoCDisposer<BLoCT> class.
class BLoCProvider<BLoCT extends BLoCTemplate> extends InheritedWidget {
  /// A widget to make the [bloc] accessible to.
  @override
  final Widget child;

  /// The BLoC to make accessible to [child].
  final BLoCT bloc;

  const BLoCProvider({@required this.child, @required this.bloc})
      : assert(child != null),
        assert(bloc != null);

  /// Retrieve a [bloc] from a [context] that is below the [child] of the
  /// BLoCProvider<BLoCT> that made the [bloc] accessible to the widget tree.
  static BLoCT of<BLoCT extends BLoCTemplate>(BuildContext context) {
    final Type providerType = _type<BLoCProvider<BLoCT>>();
    final BLoCProvider<BLoCT> provider = context
        .inheritFromWidgetOfExactType(providerType) as BLoCProvider<BLoCT>;

    if (provider == null) {
      throw FlutterError('Unable to find BLoC of type $BLoCT.\n'
          'Is the provided context from below the provider or disposer?\n'
          'Context provided: $context');
    }
    return provider.bloc;
  }

  static Type _type<T>() => T;

  @override
  bool updateShouldNotify(BLoCProvider<BLoCTemplate> oldWidget) => true;
}
