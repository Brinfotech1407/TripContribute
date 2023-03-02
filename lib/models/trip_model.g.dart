// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel(
      json['tripName'] as String,
      (json['tripMemberName'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['tripMemberMno'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TripModelToJson(TripModel instance) => <String, dynamic>{
      'tripName': instance.tripName,
      'tripMemberName': instance.tripMemberName,
      'tripMemberMno': instance.tripMemberMno,
    };
