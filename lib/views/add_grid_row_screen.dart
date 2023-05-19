import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_controller/form_controller.dart';
import 'package:trip_contribute/models/trip_grid_data.dart';
import 'package:trip_contribute/models/trip_member_model.dart';
import 'package:trip_contribute/utils/grid_notes_utils.dart';
import 'package:trip_contribute/views/widgets/type_ahead_form_field.dart';

class AddGridRowScreen extends StatefulWidget {
  const AddGridRowScreen({
    Key? key,
    required this.arrColumnList,
    required this.arrNotesData,
    required this.tripMemberList,
  }) : super(
          key: key,
        );

  final List<TripGridColumn>? arrColumnList;
  final List<dynamic>? arrNotesData;
  final List<TripMemberModel> tripMemberList;

  @override
  _AddGridRowScreenState createState() => _AddGridRowScreenState();
}

class _AddGridRowScreenState extends State<AddGridRowScreen> {
  final FormController controller = FormController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final Map<String, TextEditingController> mapTextController =
      <String, TextEditingController>{};

  Map<String, String> mapFilePicker = <String, String>{};
  Map<String, String>? mediaUploadTrack;
  Map<String, dynamic>? arrNewlyAddedRecord = <String, dynamic>{};
  String? selectedValue;

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
      } else if (currentColumn.name == 'Name') {
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
                  child: TextFormField(
                    controller: mapTextController[currentColumn.name],
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: getFormValidators(
                        context: context, column: currentColumn),
                    onSaved: (String? value) {
                      mapTextController[currentColumn.name]!.text = value!;
                      field.didChange(value);
                    },
                    onTap: () {
                      _showDialog(currentColumn);
                    },
                  ));
            },
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
    _formKey.currentState!.save();

    final Map<String, dynamic>? arrUpdatedMap = getUpdatedMap();
    if (_formKey.currentState!.validate()) {
      arrNewlyAddedRecord = arrUpdatedMap;

      Navigator.pop(context, arrNewlyAddedRecord);
    } else {
      Container();
    }
  }

  void buildTextControllerForTextInputView() {
    for (final TripGridColumn gridColumn in widget.arrColumnList ?? []) {
      if (gridColumn.isFreeTextColumn) {
        mapTextController.putIfAbsent(
            gridColumn.name!, () => TextEditingController());
      }
    }
  }

  Map<String, dynamic>? getUpdatedMap() {
    final Map<String, dynamic> arrMap = _formKey.currentState!.value;

    return arrMap;
  }

  void _showDialog(TripGridColumn currentColumn) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Member list'),
            content: setupAlertDialoadContainer(currentColumn),
          );
        });
  }

  Widget setupAlertDialoadContainer(TripGridColumn currentColumn) {
    return Container(
      // height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 1,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.tripMemberList.length,
        itemBuilder: (BuildContext context, int index) {
          final TripMemberModel arrMember = widget.tripMemberList[index];
          return ListTile(
            title: Text(arrMember.tripMemberName!),
            onTap: () {
              setState(() {
                selectedValue = arrMember.tripMemberName;
                mapTextController[currentColumn.name]!.text =
                    arrMember.tripMemberName!;
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
