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
    on<UserProfileAlreadyStore>(_onCheckUserAlready);
    on<UserPreferenceServiceInit>(_onPreferenceServiceInit);
    on<AddMemberDetails>(_onAddMemberDetails);
    on<GetTripData>(_onGetTripMemberData);
    on<GetUserData>(_onGetUserData);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userMobileNumber = '';

  /// Store local key-value pair data.
  final PreferenceService preferenceService = PreferenceService();

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) {
    emit(
      UserLoaded(userData: event.userData),
    );
  }

  Future<void> _onAddUserDetails(
    AddUser event,
    Emitter<UserState> emit,
  ) async {
    try {
      final ProfileModel userData = ProfileModel(
        name: event.name,
        email: event.email,
        mobileNo: event.mobileNo,
        id: _auth.currentUser?.uid,
      );
      DatabaseManager()
          .setUserData(userData, event.mobileNo.substring(3), event.context);
    } on Exception catch (e) {
      log('addUser Exception $e');
    }
  }

  Future<bool> _onCheckUserAlready(UserProfileAlreadyStore event,
      Emitter<UserState> emit,) async {
    final String userData = event.mobileNo;
    final bool userAlready =
    await DatabaseManager().userProfileAlreadyStore(userData);
    emit(UserCheckAlready(isUSerAlreadyProfile: userAlready));
    return userAlready;
  }

  Future<void> _onPreferenceServiceInit(UserPreferenceServiceInit event,
      Emitter<UserState> emit) async {
    await preferenceService.init();

    Future<void> preService = preferenceService.init();

    emit(PreferenceServiceInit(preferenceService: preService));
  }


  Future<void> _onAddMemberDetails(AddMemberDetails event,
      Emitter<UserState> emit,) async {
    try {
      final TripModel memberData =
      TripModel(event.tripName, event.id, event.tripMemberDetails);
      DatabaseManager().setMembersData(memberData.toJson(), event.id);
    } on Exception catch (e) {
      log('addUser Exception $e');
    }
  }

  Future<void> _onGetTripMemberData(GetTripData event, Emitter<UserState> emit) async {
    //await preferenceService.init();

    emit(UserLoading());
    await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final TripModel? tripMemberData = await DatabaseManager().getSingleTripMemberList(userMobileNumber);
      emit(GetTripMemberData(tripMemberData:tripMemberData!));
    } catch (exception) {
      emit( ProfileError(exception.toString()));
    }
  }

  Future<void> _onGetUserData(GetUserData event, Emitter<UserState> emit) async {
    //await preferenceService.init();

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
