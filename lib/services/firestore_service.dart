import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/models/trip_model.dart';
import 'package:trip_contribute/services/preference_service.dart';
class DatabaseManager{
  FirebaseFirestore get _fireStore {
    final FirebaseFirestore fireStoreInstance =
    FirebaseFirestore.instance
      ..settings = const Settings(persistenceEnabled: true);
    return fireStoreInstance;
  }

  final PreferenceService _preferenceService = PreferenceService();
  Future<String> setUserData(ProfileModel userData, String userID,BuildContext context) async {
      try {
        _fireStore.collection('user').doc(userID).set(
          userData.toJson(),
          SetOptions(
            merge: true,
          ),
        );
        await _preferenceService.setString(PreferenceService.User_Name, userData.name);
      await _preferenceService.setString(
          PreferenceService.User_PhoneNo, userData.mobileNo.substring(3));
      await _preferenceService.setBool(PreferenceService.userLogin, true);

      print('data added $userData');
    } on Exception catch (e) {
      log('Exception $e');
    }

    return userID;
  }

  Future<bool> userProfileAlreadyStore(String userMobileNo) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _fireStore
        .collection('user')
        .where('mobileNo', isEqualTo: userMobileNo)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<String> setMembersData(
    Map<String, dynamic> data,
    String tripID,
  ) async {
    try {
      _fireStore.collection('Trip').doc(tripID).set(
            data,
            SetOptions(
              merge: true,
            ),
      );
    } on Exception catch (e) {
      log('Exception $e');
    }
    return '';
  }

  Future<ProfileModel?> getSingleUserList(String userID) async {
    final DocumentSnapshot <Map<String, dynamic>>doc =
    await _fireStore.collection('user').doc(userID).get();
    if(doc.exists) {
      try {
        final ProfileModel user = ProfileModel.fromJson(doc.data()!);
        print('user $user');
        return user;
      } catch (e) {
        throw Exception(e.toString());
      }
    }else{
      return null;
    }
  }


  Future<TripModel?> getSingleTripMemberList(String userID) async {
    final DocumentSnapshot <Map<String, dynamic>>doc =
    await _fireStore.collection('Members').doc(userID).get();
    if(doc.exists) {
      try {
        final TripModel user = TripModel.fromJson(doc.data()!);
        print('Members $user');
        return user;
      } catch (e) {
        throw Exception(e.toString());
      }
    }else{
      return null;
    }
  }

}