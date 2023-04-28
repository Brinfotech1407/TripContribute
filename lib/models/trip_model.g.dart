// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel(
      json['tripName'] as String,
      json['tripId'] as String,
      TripMemberModel.fromJson(
          json['tripMemberDetails'] as Map<String, dynamic>),
      TripGridColumn.fromJson(json['columnNames'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TripModelToJson(TripModel instance) =>
    <String, dynamic>{
      'tripName': instance.tripName,
      'tripId': instance.tripId,
      'tripMemberDetails': instance.tripMemberDetails.toJson(),
      'columnNames': instance.columnNames.toJson(),
    };
