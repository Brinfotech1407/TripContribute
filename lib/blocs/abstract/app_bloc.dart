import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

/// Takes any event [E] as the parameter and returns the corresponding state [S]
typedef AsyncEventDispatcher<E extends AppEvent<E, S, B>,
        S extends AppState<E, S, B>, B extends AppBloc<E, S>>
    = Future<S> Function(E event);

// ignore: lines_longer_than_80_chars
/// The abstract class that all the Actions like [OkDoneAction], [ChatAction], [MessageAction] implements.
abstract class AppEvent<E extends AppEvent<E, S, B>,
    S extends AppState<E, S, B>, B extends AppBloc<E, S>> {
  final Completer<S> _c = Completer<S>();

  // ignore: lines_longer_than_80_chars
  /// The future that is completed by [_c] completer.
  ///
  /// The future that is completed when [complete] is called in [_subscribeCompletion]
  /// or when [completeError] is called in [onError].
  Future<S> get _future async => _c.future;

  void _subscribeCompletion(Future<S> _f) {
    _f.then<void>((S value) {
      _c.complete(value);
    }).catchError(onError);
  }

  bool canHandleError(Object? error) => false;

  void onError(Object error, StackTrace stackTrace) {
    _c.completeError(error, stackTrace);
  }

  Stream<S> reduce(B bloc);
}

abstract class AppState<E extends AppEvent<E, S, B>,
    S extends AppState<E, S, B>, B extends AppBloc<E, S>> {
  @protected
  @BuiltValueField(serialize: false)
  AsyncEventDispatcher<E, S, B>? get dispatch;

  @protected
  S setDispatcher(AsyncEventDispatcher<E, S, B> dispatcher);
}

abstract class AppBloc<E extends AppEvent<E, S, AppBloc<E, S>>,
    S extends AppState<E, S, AppBloc<E, S>>> extends Bloc<E, S> {
  // start old  bloc code
  //AppBloc(S initialState) : super(initialState);
  // end old bloc code

  // start new bloc code
  AppBloc(S initialState) : super(initialState) {
    on<E>((E event, Emitter<S> emit) {
      Stream<S> reducer = event.reduce(this).asBroadcastStream();
      event._subscribeCompletion(reducer.last);
      return emit.forEach(
        reducer.cast<S>(),
        onData: (S state) => state,
      );
    }, transformer: eventTransformers());
  }

  EventTransformer<E> eventTransformers() => sequential<E>();
  // end new bloc code

  Future<S> _asyncDispatch(E event) {
    add(event);
    return event._future;
  }

  @override
  @mustCallSuper
  S get state => super.state.setDispatcher(_asyncDispatch);

  /*@override
  @mustCallSuper
  void onEvent(E event) {
    super.onEvent(event);
    if (event is AppEvent) {
      Stream<S> reducer = event.reduce(this).asBroadcastStream();
      reducer = reducer.handleError(
        event.onError,
        test: event.canHandleError,
      );
      event._subscribeCompletion(reducer.last);
      reducer.listen((S event) {
        emit(event);
      });
      //yield* reducer;
    } else {
      assert(false, '$event is not a $AppEvent');
    }
  }*/

  // start old bloc code
  /*@override
  @protected
  Stream<S> mapEventToState(E event) async* {
    if (event is AppEvent) {
      Stream<S> reducer = event.reduce(this).asBroadcastStream();
      reducer = reducer.handleError(
        event.onError,
        test: event.canHandleError,
      );
      event._subscribeCompletion(reducer.last);
      yield* reducer;
    } else {
      assert(false, '$event is not a $AppEvent');
    }
  }*/
  // end old bloc code
}
