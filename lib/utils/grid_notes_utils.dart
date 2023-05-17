import 'package:trip_contribute/models/trip_grid_data.dart';

extension GridNoteUtils on TripGridColumn {
  bool get isDateColumn => columnType!.toLowerCase() == 'date';

  bool get isEmailColumn => columnType!.toLowerCase() == 'email';

  bool get isNumericColumn => columnType!.toLowerCase() == 'numeric';

  bool get isFreeTextColumn => columnType!.toLowerCase() == 'free text';

  bool get isFileColumn => columnType!.toLowerCase() == 'file';

  bool get isNoColumn => name!.toLowerCase() == 'no';
}
