
import 'package:trip_contribute/blocs/abstract/app_bloc.dart';
import 'package:trip_contribute/models/auth_state.dart';


abstract class AuthAction extends AppEvent<AuthAction, AuthState, AuthBloc> {}

const int timerDuration = 59;
const int timeout = 20;

/// This handles key app specific events like authentication, notification, etc.
class AuthBloc extends AppBloc<AuthAction, AuthState> {
  AuthBloc({
    required AuthState initialState,
  }) : super(initialState);


  @override
  AuthState get state {
    final AuthState superState = super.state;

    return superState;
  }
}


