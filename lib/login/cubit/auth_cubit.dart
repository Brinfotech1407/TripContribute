import 'package:bloc/bloc.dart';
import 'package:trip_contribute/login/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState()) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      //profile view set then put the condition
      emit(AuthLoggedInState(currentUser));
    } else {
      emit(AuthLoggedOutState());
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationOTP;

  void sendOTP(String phoneNo) async {
    emit(AuthLoadingState());
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      codeSent: (String verificationId, int? forceResendingToken) {
        _verificationOTP = verificationId;
        emit(AuthCodeSentState());
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        signInWithPhone(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException error) {
        emit(AuthErrorState(error.message.toString()));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
       // _verificationOTP = verificationId;
      },
    );
  }

  void verifyOTP(String otp) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationOTP!, smsCode: otp);
    signInWithPhone(credential);
  }

  void signInWithPhone(PhoneAuthCredential phoneAuthCredential) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (userCredential.user != null) {
        emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (ex) {
      emit(AuthErrorState(ex.message.toString()));
    }
  }
}
