class TripGridColumn {
  TripGridColumn({
    this.name,
    this.columnType,
    this.showTotal = false,
    this.showAutoSuggestion = false,
    this.isRequired = false,
  });

  factory TripGridColumn.fromJson(Map<String, dynamic> json) {
    final bool showTotal;
    final bool showAutoSuggestion;
    final bool isRequired;

    if (json.containsKey('showTotal')) {
      showTotal = json['showTotal'] as bool;
    } else {
      showTotal = false;
    }

    if (json.containsKey('showAutoSuggestion')) {
      showAutoSuggestion = json['showAutoSuggestion'] as bool;
    } else {
      showAutoSuggestion = false;
    }

    if (json.containsKey('isRequired')) {
      isRequired = json['isRequired'] as bool;
    } else {
      isRequired = false;
    }

    return TripGridColumn(
      name: json['name'] as String,
      columnType: json['columnType'] as String,
      showTotal: showTotal,
      showAutoSuggestion: showAutoSuggestion,
      isRequired: isRequired,
    );
  }

  String? name;
  String? columnType;
  bool? showTotal;
  bool? showAutoSuggestion;
  bool? isRequired;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['columnType'] = columnType;
    data['showTotal'] = showTotal;
    data['showAutoSuggestion'] = showAutoSuggestion;
    data['isRequired'] = isRequired;
    return data;
  }
}
