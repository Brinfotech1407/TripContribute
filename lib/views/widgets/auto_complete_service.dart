import '../../models/trip_grid_data.dart';

mixin AutoCompleteService {
  static final List<String> arrData = [];

  static List<String> getSuggestions({
    required String query,
    required TripGridColumn currentColumn,
    required List<dynamic> arrNotesData,
  }) {
    arrData
      ..clear()
      ..addAll(
        filterFromColumnName(
          arrNotesData: arrNotesData,
          currentColumn: currentColumn,
        ),
      );

    final List<String> matches = <String>[
      ...arrData
    ]..retainWhere((String s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  static List<String> filterFromColumnName({
    required TripGridColumn currentColumn,
    required List<dynamic> arrNotesData,
  }) {
    final List<String> arrData = <String>[];

    for (final dynamic arrItem in arrNotesData) {
      final Map<String, dynamic> mapValue = arrItem as Map<String, dynamic>;
      if (mapValue.containsKey(currentColumn.name) &&
          mapValue[currentColumn.name] != null) {
        arrData.add(mapValue[currentColumn.name]! as String);
      }
    }

    final List<String> uniqueList = getUniqueList(arrData);

    return uniqueList;
  }

  static List<String> getUniqueList(List<String> arrData) {
    final Set<String> uniqueSet = <String>{};

    final List<String> uniqueList =
        arrData.where((String item) => uniqueSet.add(item)).toList();

    return uniqueList;
  }
}
