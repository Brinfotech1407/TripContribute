import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';
import 'package:trip_contribute/blocs/abstract/app_bloc.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_bloc.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_view_model.dart';
import 'package:trip_contribute/models/serializers.dart';

part 'okdone_state.g.dart';

abstract class OkDoneState
    implements
        Built<OkDoneState, OkDoneStateBuilder>,
        OkDoneViewModel,
        AppState<OkDoneAction, OkDoneState, OkDoneBloc> {
  factory OkDoneState([void Function(OkDoneStateBuilder) updates]) =
  _$OkDoneState;

  OkDoneState._();

  Map<String, dynamic>? toJson() {
    return serializers.serializeWith(OkDoneState.serializer, this)
    as Map<String, dynamic>?;
  }

  static OkDoneState? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(OkDoneState.serializer, json);
  }

  static Serializer<OkDoneState> get serializer => _$okDoneStateSerializer;

  @override
  @protected
  OkDoneState setDispatcher(
      AsyncEventDispatcher<OkDoneAction, OkDoneState, OkDoneBloc> dispatch,) {
    return rebuild((OkDoneStateBuilder b) => b.dispatch = dispatch);
  }

  @override
  Future<OkDoneViewModel> redirectToHomeScreen() {
    return dispatch!(RedirectToHomeScreen());
  }
}
