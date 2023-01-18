import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/blocs/abstract/app_connector.dart';
import 'package:trip_contribute/models/auth_state.dart';


import 'auth_bloc.dart';
import 'auth_view_model.dart';

/// Offers access view model for the views to communicate with its environment.
class AuthConnector extends AppConnector<AuthAction, AuthState> {
  const AuthConnector({
    Key? key,
    ModelCallback<AuthViewModel>? onInitState,
    ModelCallback<AuthViewModel>? onDispose,
    required AppWidgetBuilder<AuthViewModel> builder,
    AppWidgetBuilderCondition<AuthViewModel>? condition,
  }) : super(
          key: key,
          builder: builder,
          condition: condition,
          onInitState: onInitState,
          onDispose: onDispose,
        );

  @override
  Bloc<AuthAction, AuthState> getBloc(BuildContext context) {
    return BlocProvider.of<AuthBloc>(context);
  }
}

/// The provider for the Auth Bloc.
///
/// Wraps up user-registration module.
class AuthProvider extends StatelessWidget {
  const AuthProvider({Key? key, this.child, this.create, this.value})
      : super(key: key);

  final Widget? child;

  /// Creates [AuthBloc] and returns it
  final Create<AuthBloc>? create;

  final AuthBloc? value;

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      return BlocProvider<AuthBloc>.value(
        value: value!,
        child: child,
      );
    } else {
      return BlocProvider<AuthBloc>(
        create: create!,
        child: child,
      );
    }
  }
}
