import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:trip_contribute/blocs/abstract/app_bloc.dart';
import 'package:trip_contribute/models/okdone_state.dart';

typedef EventDispatcher<E, S> = Future<S> Function(E);

/// It is a super class, all kinds of actions performed on [OkDoneBloc].
abstract class OkDoneAction
    extends AppEvent<OkDoneAction, OkDoneState, OkDoneBloc> {}

/// This handles key app specific events like authentication, notification, etc.
class OkDoneBloc extends AppBloc<OkDoneAction, OkDoneState> {
  OkDoneBloc({
    required OkDoneState initialState,
  }) : super(initialState);

  /// This creates [ChatBloc] with the [initState] as the initialState
  /// and also adds the [InitChat] action as the first action.

  @override
  OkDoneState get state {
    final OkDoneState superState = super.state;

    return superState;
  }
}

class RedirectToHomeScreen extends OkDoneAction {
  @override
  Stream<OkDoneState> reduce(OkDoneBloc bloc) async* {
    yield bloc.state;

    await Future<void>.delayed(const Duration(seconds: 3), () {});

    yield bloc.state.rebuild((OkDoneStateBuilder b) => b..isLoading = true);
  }
}
