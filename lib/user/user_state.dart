import 'package:equatable/equatable.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/models/trip_model.dart';

abstract class UserState extends Equatable{
  const UserState();

  @override
  List<Object> get props => [];


}

class UserInitial extends UserState {}

class UserLoading extends UserState{
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  const UserLoaded({this.userData = const <ProfileModel>[]});

  final List<ProfileModel> userData;

  @override
  List<Object> get props => [userData];
}

class UserCheckAlready extends UserState {
  const UserCheckAlready({required this.isUSerAlreadyProfile});

  final bool isUSerAlreadyProfile;

  @override
  List<Object> get props => [isUSerAlreadyProfile];
}

class GetSingleUser extends UserState {
  const GetSingleUser({required this.userData});

  final ProfileModel userData;

  @override
  List<Object> get props => [userData];
}

class GetTripMemberData extends UserState{

  const GetTripMemberData({required this.tripMemberData});
  final TripModel tripMemberData;

  @override
  List<Object> get props =>[tripMemberData];

}

class ProfileError extends UserState {
  const ProfileError(this.message);
  final String message;
}

