import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/models/trip_model.dart';
import 'package:trip_contribute/services/firestore_service.dart';
import 'package:trip_contribute/services/preference_service.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/user/user_state.dart';


class UserBloc extends Bloc<UserEvent,UserState>{
  UserBloc() : super(UserLoading()) {
    on<LoadUser>(_onLoadUser);
    on<AddUser>(_onAddUserDetails);
    on<AddMemberDetails>(_onAddMemberDetails);
    on<GetUserData>(_onGetUserData);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

   String userMobileNumber = '';

  /// Store local key-value pair data.
  final PreferenceService _preferenceService = PreferenceService();

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) {
    emit(
      UserLoaded(userData: event.userData),
    );
  }

  Future<void> _onAddUserDetails(AddUser event, Emitter<UserState> emit) async {
    await _preferenceService.init();
    await _preferenceService.setUserPhoneNo(event.mobileNo.substring(3));
    print('setUserPhoneNo ${event.mobileNo.substring(3)}');
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

  Future<void> _onAddMemberDetails(AddMemberDetails event, Emitter<UserState> emit) async {
    try {
      final TripModel memberData = TripModel(event.tripName, event.tripMemberName,event.tripMemberMno);
      DatabaseManager().setMembersData(memberData.toJson(), '7777777777');
    }on Exception catch (e) {
      log('addUser Exception $e');
    }
  }

  Future<void> _onGetUserData(GetUserData event, Emitter<UserState> emit) async {
   await _preferenceService.init();
     //\\String  userPhoneNo = '';//7777777777

     userMobileNumber = _preferenceService.getUserPhoneNo('USERPHONENO')?? '';

    print('_phoneNumber $userMobileNumber');
    emit(UserLoading());
    await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final ProfileModel? profileData = await DatabaseManager().getSingleUserList(userMobileNumber);
      emit(GetSingleUser(userData:profileData!));
    } catch (exception) {
      emit( ProfileError(exception.toString()));
    }
  }

}