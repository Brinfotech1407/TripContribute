
import 'package:trip_contribute/blocs/abstract/app_view_model.dart';



abstract class AuthViewModel implements AppViewModel {
  // Handle loading indicator in login screen
  bool get isLoginLoading;

}
