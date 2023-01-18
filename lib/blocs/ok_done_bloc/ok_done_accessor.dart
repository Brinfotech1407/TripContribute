import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/blocs/abstract/app_connector.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_bloc.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_view_model.dart';
import 'package:trip_contribute/models/okdone_state.dart';

/// Offers access view model for the views to communicate with its environment.
class OkDoneConnector extends AppConnector<OkDoneAction, OkDoneState> {
  const OkDoneConnector({
    Key? key,
    ModelCallback<OkDoneViewModel>? onInitState,
    ModelCallback<OkDoneViewModel>? onDispose,
    required AppWidgetBuilder<OkDoneViewModel> builder,
    AppWidgetBuilderCondition<OkDoneViewModel>? condition,
  }) : super(
          key: key,
          builder: builder,
          condition: condition,
          onInitState: onInitState,
          onDispose: onDispose,
        );

  @override
  Bloc<OkDoneAction, OkDoneState> getBloc(BuildContext context) {
    return BlocProvider.of<OkDoneBloc>(context);
  }
}

/// The main Application Provider.
///
/// This wraps up the [MaterialApp] and is at the
/// root of the widget-tree.
class OkDoneProvider extends StatelessWidget {
  const OkDoneProvider({Key? key, this.child, this.create}) : super(key: key);

  final Widget? child;

  /// Creates [OkDoneBloc] and returns it
  final Create<OkDoneBloc>? create;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OkDoneBloc>(
      create: create!,
      child: child,
    );
  }
}
