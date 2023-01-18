import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Create<T> = T Function(BuildContext context);

typedef AppWidgetBuilder<T> = Widget Function(BuildContext context, T model);

typedef AppWidgetBuilderCondition<T> = bool Function(T previous, T current);

typedef ModelCallback<T> = void Function(T model);

// abstract connector that glues the view with any state management solution
// (BLoC, Provide, Mobx etx)
abstract class AppConnector<A, S> extends StatelessWidget implements Widget {
  const AppConnector({
    Key? key,
    /*required*/ required this.builder,
    this.condition,
    this.onInitState,
    this.onDispose,
  })  : assert(builder != null),
        super(key: key);

  final AppWidgetBuilder<S> builder;
  final AppWidgetBuilderCondition<S>? condition;
  final ModelCallback<S>? onInitState;
  final ModelCallback<S>? onDispose;

  Bloc<A, S> getBloc(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return _AppConnector<A, S>(
      bloc: getBloc(context),
      onInitState: onInitState,
      onDispose: onDispose,
      builder: builder,
      condition: condition,
    );
  }
}

class _AppConnector<A, S> extends StatefulWidget {
  const _AppConnector({
    Key? key,
    /*required*/ required this.bloc,
    /*required*/ required this.builder,
    this.condition,
    this.onInitState,
    this.onDispose,
  }) : super(key: key);

  final Bloc<A, S> bloc;
  final AppWidgetBuilder<S> builder;
  final AppWidgetBuilderCondition<S>? condition;
  final ModelCallback<S>? onInitState;
  final ModelCallback<S>? onDispose;

  @override
  _AppConnectorState<A, S> createState() => _AppConnectorState<A, S>();
}

class _AppConnectorState<A, S> extends State<_AppConnector<A, S>> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call(widget.bloc.state);
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(widget.bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc<A, S>, S>(
      bloc: widget.bloc,
      builder: widget.builder,
      buildWhen: widget.condition,
    );
  }
}
