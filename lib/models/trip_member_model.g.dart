// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripMemberModel _$TripMemberModelFromJson(Map<String, dynamic> json) =>
    TripMemberModel(
      (json['tripMemberName'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      (json['tripMemberMno'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TripMemberModelToJson(TripMemberModel instance) =>
    <String, dynamic>{
      'tripMemberName': instance.tripMemberName,
      'tripMemberMno': instance.tripMemberMno,
    };
