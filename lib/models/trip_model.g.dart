// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel(
      json['tripName'] as String,
      json['tripId'] as String,
      (json['tripMemberDetails'] as List<dynamic>?)
          ?.map((e) => TripMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TripModelToJson(TripModel instance) => <String, dynamic>{
      'tripName': instance.tripName,
      'tripId': instance.tripId,
      'tripMemberDetails':
          instance.tripMemberDetails?.map((e) => e.toJson()).toList(),
    };