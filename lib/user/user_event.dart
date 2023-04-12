import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/models/trip_member_model.dart';

abstract class UserEvent extends Equatable{
const UserEvent();

@override
List<Object> get props => [];
}


class LoadUser extends UserEvent{
   const LoadUser(this.userData);

  final List<ProfileModel> userData;


  @override
  List<Object> get props => [userData];

}

class AddUser extends UserEvent{

   AddUser({required this.name,required this.email,required this.mobileNo,required this.context,});
  final String name;
  final String email;
  final String mobileNo;
  final BuildContext context;


}

class AddMemberDetails extends UserEvent{

  const AddMemberDetails({required this.tripName,required this.id,required this.tripMemberDetails,});
  final String tripName;
  final String id;
  final List<TripMemberModel> tripMemberDetails;

}

class GetUserData extends UserEvent{
  const  GetUserData();

  @override
  List<Object> get props => [];
}


class GetTripData extends UserEvent{
  const  GetTripData();

  @override
  List<Object> get props => [];
}


