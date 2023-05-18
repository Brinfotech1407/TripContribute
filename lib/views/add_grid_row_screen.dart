import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_controller/form_controller.dart';
import 'package:trip_contribute/models/trip_grid_data.dart';
import 'package:trip_contribute/utils/grid_notes_utils.dart';
import 'package:trip_contribute/views/widgets/type_ahead_form_field.dart';

class AddGridRowScreen extends StatefulWidget {
  const AddGridRowScreen({
    Key? key,
    required this.arrColumnList,
    required this.arrNotesData,
  }) : super(
          key: key,
        );

  final List<TripGridColumn>? arrColumnList;
  final List<dynamic>? arrNotesData;

  @override
  _AddGridRowScreenState createState() => _AddGridRowScreenState();
}

class _AddGridRowScreenState extends State<AddGridRowScreen> {
  final FormController controller = FormController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final Map<String, TextEditingController> mapTextController =
      <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    buildTextControllerForTextInputView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildElement(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildElement(BuildContext context) {
    final List<Widget> arrChildList = <Widget>[];

    for (final TripGridColumn currentColumn in widget.arrColumnList ?? []) {
      print('isNumericColumn${currentColumn.showAutoSuggestion.toString()}');
      if (currentColumn.isNumericColumn) {
        arrChildList.add(
          FormBuilderTextField(
            name: currentColumn.name!,
            maxLength: 10,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Please Enter ${currentColumn.name!}',
              labelText: currentColumn.name!.toUpperCase(),
            ),
            validator:
                getFormValidators(context: context, column: currentColumn),
          ),
        );
      } else {
        if (currentColumn.showAutoSuggestion!) {
          arrChildList.add(
            FormBuilderField<String?>(
              name: currentColumn.name!,
              onChanged: (String? val) => debugPrint(val.toString()),
              builder: (FormFieldState<String?> field) {
                return InputDecorator(
                  decoration: const InputDecoration(
                    disabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  child: TypeAheadView(
                    controller: mapTextController[currentColumn.name],
                    currentColumn: currentColumn,
                    arrSuggestionList: widget.arrNotesData,
                    onSuggestionSelected: (String suggestion) {
                      mapTextController[currentColumn.name]!.text = suggestion;
                    },
                    validator: getFormValidators(
                        context: context, column: currentColumn),
                    onSaved: (String? value) {
                      mapTextController[currentColumn.name]!.text = value!;
                      field.didChange(value);
                    },
                  ),
                );
              },
            ),
          );
        }
      }
    }

    arrChildList.add(buildSubmitButton());

    return arrChildList;
  }

  FormFieldValidator<String> getFormValidators({
    required BuildContext context,
    required TripGridColumn column,
  }) {
    final List<FormFieldValidator<String>> arrValidationList =
        <FormFieldValidator<String>>[];

    if (column.isRequired!) {
      arrValidationList.add(FormBuilderValidators.required());
    }
    return FormBuilderValidators.compose(arrValidationList);
  }

  Widget buildSubmitButton() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton(
        child: const Text('Add'),
        onPressed: () {
          addRows(false);
        },
      ),
    );
  }

  void addRows(bool sendMessage) {
    /*  _formKey.currentState!.save();

    final Map<String, dynamic> arrUpdatedMap = getUpdatedMap();
    if (_formKey.currentState!.validate()) {
      final NotesCreateData notesCreateData = NotesCreateData(
            (NotesCreateDataBuilder b) {
          b
            ..needsToSendMessage = sendMessage
            ..arrNewlyAddedRecord = arrUpdatedMap;
        },
      );

      Navigator.pop(context, notesCreateData);
    } else {
      Container();
    }*/
  }

  void buildTextControllerForTextInputView() {
    for (final TripGridColumn gridColumn in widget.arrColumnList ?? []) {
      if (gridColumn.isFreeTextColumn) {
        mapTextController.putIfAbsent(
            gridColumn.name!, () => TextEditingController());
      }
    }
  }
}
