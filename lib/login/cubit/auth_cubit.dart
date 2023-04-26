import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trip_contribute/login/cubit/auth_state.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/services/preference_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState()) {
    final User? currentUser = _auth.currentUser;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    preferenceService = PreferenceService();
    preferenceService.init();
    if (currentUser != null) {
      //profile view set then put the condition
      emit(AuthLoggedInState(currentUser));
    } else {
      emit(AuthLoggedOutState());
    }
  }


  final FirebaseAuth _auth = FirebaseAuth.instance;
  late PreferenceService preferenceService;


  String? _verificationOTP;

  void sendOTP(String phoneNo, BuildContext context) async {
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
        print('userCredential ${userCredential.user}');

        final QuerySnapshot<
            Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('user')
            .where('mobileNo', isEqualTo: _auth.currentUser?.phoneNumber)
            .get();

        final List<
            QueryDocumentSnapshot<Map<String, dynamic>>> userDocs = snapshot
            .docs;

        if (snapshot.docs.isNotEmpty) {
          final ProfileModel user =
          ProfileModel.fromJson(userDocs.first.data());

          print('user Data ${user.name}');

          await preferenceService.setString(
              PreferenceService.User_Name, user.name);
          await preferenceService.setString(
              PreferenceService.User_PhoneNo, user.mobileNo);
          await preferenceService.setString(
              PreferenceService.User_Email, user.email);
        }

        emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (ex) {
      emit(AuthErrorState(ex.message.toString()));
    }
  }
}
