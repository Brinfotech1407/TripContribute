import 'package:equatable/equatable.dart';
import 'package:trip_contribute/models/profile_model.dart';

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

  const AddUser({required this.name,required this.email,required this.mobileNo});
  final String name;
  final String email;
  final String mobileNo;


}

class AddMemberDetails extends UserEvent{

  const AddMemberDetails({required this.tripName,required this.tripMemberName,required this.tripMemberMno});
  final String tripName;
  final  List<String> tripMemberName;
  final  List<String> tripMemberMno;


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



