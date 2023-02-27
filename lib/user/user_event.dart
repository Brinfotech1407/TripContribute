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

  const AddUser({required this.userData});
  final ProfileModel userData;

  @override
  List<Object> get props => [userData];

}
class GetUserData extends UserEvent{

  const  GetUserData({required this.userId});
  final String userId;

  @override
  List<Object> get props => [userId];
}

