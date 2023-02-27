
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  String? id;
  String mobileNo;
  String name;
  String email;

  ProfileModel({this.id, required this.mobileNo, required this.name, required this.email});

  @override
  List<Object?> get props => [
    id,
    mobileNo,
    name,
    email,
  ];


  /// Connect the generated [_$ProfileFromJson] function to the `fromJson`
  /// factory.
  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

}
