import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:trip_contribute/models/profile_model.dart';
class DatabaseManager{
  FirebaseFirestore get _fireStore {
    final FirebaseFirestore fireStoreInstance =
    FirebaseFirestore.instance
      ..settings = const Settings(persistenceEnabled: true);
    return fireStoreInstance;
  }


  Future<String> setUserData(Map<String, dynamic>? userData, String userID) async {

    if(userData !=null) {
      try {
        _fireStore.collection('user').doc(userID).set(
          userData,
          SetOptions(
            merge: true,
          ),
        );
        print('data added $userData');
      } on Exception catch (e) {
        log('Exception $e');
      }
    }
    return userID;
  }

  Future<String> setMembersData(
      Map<String, dynamic> data,
      String tripID,
      ) async {
    try {
      _fireStore.collection('Members').doc(tripID).set(
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


}