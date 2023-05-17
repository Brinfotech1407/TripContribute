import 'package:json_annotation/json_annotation.dart';
import 'package:trip_contribute/models/trip_grid_data.dart';
import 'package:trip_contribute/models/trip_member_model.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'trip_model.g.dart';


/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class TripModel {
  TripModel(
      this.tripName, this.tripId, this.tripMemberDetails, this.columnNames);

  String tripName;
  String tripId;
  List<TripMemberModel>? tripMemberDetails;
  List<TripGridColumn>? columnNames;

  @override
  List<Object?> get props => [
        tripName,
        tripId,
        tripMemberDetails,
        columnNames,
      ];

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory TripModel.fromJson(Map<String, dynamic> json) => _$TripModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TripModelToJson(this);
}
