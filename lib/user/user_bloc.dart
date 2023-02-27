import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/services/firestore_service.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/user/user_state.dart' show GetUser, ProfileError, UserLoaded, UserLoading, UserState;

class UserBloc extends Bloc<UserEvent,UserState>{
  UserBloc() : super(UserLoading()) {
    on<LoadUser>(_onLoadUser);
    on<AddUser>(_onAddUserDetails);
    on<GetUserData>(_onGetUserData);
  }



  void _onLoadUser(LoadUser event, Emitter<UserState> emit) {
    emit(
      UserLoaded(userData: event.userData),
    );
  }

  void _onAddUserDetails(AddUser event, Emitter<UserState> emit) {
    try {
      DatabaseManager().setUserData(event.userData.toJson(), event.userData.id!);
    }on Exception catch (e) {
      log('addBlog Exception $e');
    }
  }

  Future<void> _onGetUserData(GetUserData event, Emitter<UserState> emit) async {
    emit(UserLoading());
   // await Future.delayed(const Duration(seconds: 1));

    try {
      final ProfileModel? profileData = await DatabaseManager().getSingleBlogList(event.userId);
      emit(GetUser(userData:profileData!));
    } catch (exception) {
      emit(const ProfileError("Failed to fetch data. is your device online?"));
    }
  }

}