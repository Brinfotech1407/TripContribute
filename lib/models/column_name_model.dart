import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'column_name_model.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ColumnNameModel {
  ColumnNameModel(this.tripName, this.description, this.amount);

  String? tripName;
  String? description;
  String? amount;

  @override
  List<Object?> get props => [
        tripName,
        description,
        amount,
      ];

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ColumnNameModel.fromJson(Map<String, dynamic> json) =>
      _$ColumnNameModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ColumnNameModelToJson(this);
}
