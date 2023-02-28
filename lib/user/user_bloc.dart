import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/services/firestore_service.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/user/user_state.dart';

class UserBloc extends Bloc<UserEvent,UserState>{
  UserBloc() : super(UserLoading()) {
    on<LoadUser>(_onLoadUser);
    on<AddUser>(_onAddUserDetails);
  //  on<GetUserData>(_onGetUserData);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) {
    emit(
      UserLoaded(userData: event.userData),
    );
  }

  void _onAddUserDetails(AddUser event, Emitter<UserState> emit) {
    try {

      final ProfileModel userData = ProfileModel(
        name: event.name,
        email: event.email,
        mobileNo: event.mobileNo,
        id: _auth.currentUser?.uid,
      );

      DatabaseManager().setUserData(userData.toJson(), event.mobileNo.substring(3));
    }on Exception catch (e) {
      log('addUser Exception $e');
    }
  }

 /* Future<void> _onGetUserData(GetUserData event, Emitter<UserState> emit) async {
    emit(UserLoading());
   // await Future.delayed(const Duration(seconds: 1));

    try {
      final ProfileModel? profileData = await DatabaseManager().getSingleBlogList(event.userId);
      emit(GetUser(userData:profileData!));
    } catch (exception) {
      emit(const ProfileError("Failed to fetch data. is your device online?"));
    }
  }*/

}