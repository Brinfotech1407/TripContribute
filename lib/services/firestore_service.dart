import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/models/trip_model.dart';
import 'package:trip_contribute/services/preference_service.dart';

class DatabaseManager {
  FirebaseFirestore get _fireStore {
    final FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance
      ..settings = const Settings(persistenceEnabled: true);
    return fireStoreInstance;
  }

  final PreferenceService _preferenceService = PreferenceService();

  Future<String> setUserData(
      ProfileModel userData, String userID, BuildContext context) async {
    try {
      _fireStore.collection('user').doc(userID).set(
            userData.toJson(),
            SetOptions(
              merge: true,
            ),
          );
      await _preferenceService.setString(
          PreferenceService.User_Name, userData.name);
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

  Future<String> setTripData(
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

  Stream<List<TripModel>> listenTripsData() {
    final Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('Trip');
    return query.snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> event) {
        return event.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                TripModel.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<void> updateTripMember({
    String? id,
    Map<String, dynamic>? newlyAddedMembers,
  }) async {
    final List<dynamic> arrTripMemberData = <dynamic>[newlyAddedMembers];
    try {
      _fireStore.collection('Trip').doc(id).update(
        {
          'tripMemberDetails': FieldValue.arrayUnion(arrTripMemberData),
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
