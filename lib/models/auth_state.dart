import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:meta/meta.dart';
import 'package:trip_contribute/blocs/abstract/app_bloc.dart';
import 'package:trip_contribute/models/serializers.dart';


import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_view_model.dart';

part 'auth_state.g.dart';

abstract class AuthState
    implements
        Built<AuthState, AuthStateBuilder>,
        AuthViewModel,
        AppState<AuthAction, AuthState, AuthBloc> {
  factory AuthState([void Function(AuthStateBuilder) updates]) = _$AuthState;

  AuthState._();

  Map<String, dynamic>? toJson() {
    return serializers.serializeWith(AuthState.serializer, this)
        as Map<String, dynamic>?;
  }

  static AuthState? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(AuthState.serializer, json);
  }

  static Serializer<AuthState> get serializer => _$authStateSerializer;

  @override
  @protected
  AuthState setDispatcher(
    AsyncEventDispatcher<AuthAction, AuthState, AuthBloc> dispatch,
  ) {
    return rebuild((AuthStateBuilder b) => b.dispatch = dispatch);
  }

  // The initial state of the Auth. Once the initAuth action is called
  // and gets list of countries and other dependencies, login screen is shown.
  static AuthState initState() {
    return AuthState((AuthStateBuilder b) {
      b
        ..isLoginLoading = false;
    });
  }

 /* @override
  Future<AuthViewModel> initAuth() {
    return dispatch!(InitAuth());
  }*/
}
