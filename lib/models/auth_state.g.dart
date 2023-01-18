// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AuthState> _$authStateSerializer = new _$AuthStateSerializer();

class _$AuthStateSerializer implements StructuredSerializer<AuthState> {
  @override
  final Iterable<Type> types = const [AuthState, _$AuthState];
  @override
  final String wireName = 'AuthState';

  @override
  Iterable<Object?> serialize(Serializers serializers, AuthState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'isLoginLoading',
      serializers.serialize(object.isLoginLoading,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  AuthState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'isLoginLoading':
          result.isLoginLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$AuthState extends AuthState {
  @override
  final bool isLoginLoading;
  @override
  final Future<AuthState> Function(AuthAction)? dispatch;

  factory _$AuthState([void Function(AuthStateBuilder)? updates]) =>
      (new AuthStateBuilder()..update(updates))._build();

  _$AuthState._({required this.isLoginLoading, this.dispatch}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        isLoginLoading, r'AuthState', 'isLoginLoading');
  }

  @override
  AuthState rebuild(void Function(AuthStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthStateBuilder toBuilder() => new AuthStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    final dynamic _$dynamicOther = other;
    return other is AuthState &&
        isLoginLoading == other.isLoginLoading &&
        dispatch == _$dynamicOther.dispatch;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoginLoading.hashCode);
    _$hash = $jc(_$hash, dispatch.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthState')
          ..add('isLoginLoading', isLoginLoading)
          ..add('dispatch', dispatch))
        .toString();
  }
}

class AuthStateBuilder implements Builder<AuthState, AuthStateBuilder> {
  _$AuthState? _$v;

  bool? _isLoginLoading;
  bool? get isLoginLoading => _$this._isLoginLoading;
  set isLoginLoading(bool? isLoginLoading) =>
      _$this._isLoginLoading = isLoginLoading;

  Future<AuthState> Function(AuthAction)? _dispatch;
  Future<AuthState> Function(AuthAction)? get dispatch => _$this._dispatch;
  set dispatch(Future<AuthState> Function(AuthAction)? dispatch) =>
      _$this._dispatch = dispatch;

  AuthStateBuilder();

  AuthStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoginLoading = $v.isLoginLoading;
      _dispatch = $v.dispatch;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthState;
  }

  @override
  void update(void Function(AuthStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthState build() => _build();

  _$AuthState _build() {
    final _$result = _$v ??
        new _$AuthState._(
            isLoginLoading: BuiltValueNullFieldError.checkNotNull(
                isLoginLoading, r'AuthState', 'isLoginLoading'),
            dispatch: dispatch);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
