import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:trip_contribute/models/trip_grid_data.dart';
import 'package:trip_contribute/views/widgets/auto_complete_service.dart';

class TypeAheadView extends StatefulWidget {
  const TypeAheadView({
    Key? key,
    required this.controller,
    required this.currentColumn,
    required this.arrSuggestionList,
    required this.onSuggestionSelected,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  final TextEditingController? controller;
  final TripGridColumn currentColumn;
  final List<dynamic>? arrSuggestionList;
  final Function(String) onSuggestionSelected;
  final Function(String?) onSaved;
  final FormFieldValidator<String>? validator;

  @override
  _TypeAheadViewState createState() => _TypeAheadViewState();
}

class _TypeAheadViewState extends State<TypeAheadView> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.currentColumn.name!,
          disabledBorder: InputBorder.none,
        ),
      ),
      itemBuilder: (BuildContext context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (BuildContext context, Widget suggestionsBox,
          AnimationController? controller) {
        return suggestionsBox;
      },
      suggestionsCallback: (String pattern) {
        return AutoCompleteService.getSuggestions(
          query: pattern,
          currentColumn: widget.currentColumn,
          arrNotesData: widget.arrSuggestionList!,
        );
      },
      onSuggestionSelected: (String suggestion) {
        widget.onSuggestionSelected(suggestion);
      },
      noItemsFoundBuilder: (BuildContext value) {
        return Container(
          height: 0,
          width: 0,
        );
      },
      validator: widget.validator,
      onSaved: (String? value) {
        widget.onSaved(value);
        /*  mapTextController[currentColumn.name]!.text = value!;
        field.didChange(value);*/
      },
    );
  }
}
