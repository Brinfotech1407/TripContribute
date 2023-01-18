// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'okdone_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OkDoneState> _$okDoneStateSerializer = new _$OkDoneStateSerializer();

class _$OkDoneStateSerializer implements StructuredSerializer<OkDoneState> {
  @override
  final Iterable<Type> types = const [OkDoneState, _$OkDoneState];
  @override
  final String wireName = 'OkDoneState';

  @override
  Iterable<Object?> serialize(Serializers serializers, OkDoneState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.isLoading;
    if (value != null) {
      result
        ..add('isLoading')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  OkDoneState deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OkDoneStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'isLoading':
          result.isLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$OkDoneState extends OkDoneState {
  @override
  final bool? isLoading;
  @override
  final Future<OkDoneState> Function(OkDoneAction)? dispatch;

  factory _$OkDoneState([void Function(OkDoneStateBuilder)? updates]) =>
      (new OkDoneStateBuilder()..update(updates))._build();

  _$OkDoneState._({this.isLoading, this.dispatch}) : super._();

  @override
  OkDoneState rebuild(void Function(OkDoneStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OkDoneStateBuilder toBuilder() => new OkDoneStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    final dynamic _$dynamicOther = other;
    return other is OkDoneState &&
        isLoading == other.isLoading &&
        dispatch == _$dynamicOther.dispatch;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, dispatch.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OkDoneState')
          ..add('isLoading', isLoading)
          ..add('dispatch', dispatch))
        .toString();
  }
}

class OkDoneStateBuilder implements Builder<OkDoneState, OkDoneStateBuilder> {
  _$OkDoneState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  Future<OkDoneState> Function(OkDoneAction)? _dispatch;
  Future<OkDoneState> Function(OkDoneAction)? get dispatch => _$this._dispatch;
  set dispatch(Future<OkDoneState> Function(OkDoneAction)? dispatch) =>
      _$this._dispatch = dispatch;

  OkDoneStateBuilder();

  OkDoneStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _dispatch = $v.dispatch;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OkDoneState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OkDoneState;
  }

  @override
  void update(void Function(OkDoneStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OkDoneState build() => _build();

  _$OkDoneState _build() {
    final _$result =
        _$v ?? new _$OkDoneState._(isLoading: isLoading, dispatch: dispatch);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
