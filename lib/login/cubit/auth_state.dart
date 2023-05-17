import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState{}

class AuthInitialState extends AuthState{}

class AuthLoadingState extends AuthState{}

class AuthCodeSentState extends AuthState{}

class AuthCodeVerifiedState extends AuthState{}

class AuthLoggedInState extends AuthState{
  AuthLoggedInState(this.firebaseUser);
  final User firebaseUser;
}

class AuthLoggedOutState extends AuthState{}

class AuthErrorState extends AuthState{
  AuthErrorState(this.error);
  final String error;
}