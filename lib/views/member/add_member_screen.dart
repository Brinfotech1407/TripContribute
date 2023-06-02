import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:trip_contribute/models/trip_member_model.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/utils/tripUtils.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen(
      {Key? key,
      required this.tripName,
      required this.userName,
      required this.userMno,
      required this.tripId})
      : super(key: key);
  final String tripName;
  final String userName;
  final String userMno;
  final String tripId;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<TripMemberModel> arrMemberList = <TripMemberModel>[];

  @override
  void initState() {
    arrMemberList.add(TripMemberModel(widget.userName, widget.userMno));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildHeaderView(context),
            Flexible(
              child: ListView.builder(
                itemCount: arrMemberList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 140,
                    child: Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          side: BorderSide(
                            color: Colors.grey,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              arrMemberList[index].tripMemberName ?? '',
                              style: const TextStyle(fontSize: 17),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                        arrMemberList[index].tripMemberMno ??
                                            '')),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // bottomSheet: buildShowModalBottomSheet(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.text = '';
          _phoneController.text = '';
          buildShowAddMemberModalBottomSheet(context);
        },
        backgroundColor: Colors.black,
        child: IconButton(
          onPressed: () {
            setState(() {
              _nameController.text = '';
              _phoneController.text = '';
              buildShowAddMemberModalBottomSheet(context);
            });
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Row buildHeaderView(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              widget.tripName,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        buildCreateTripIconButton(context),
      ],
    );
  }

  Align buildCreateTripIconButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        padding: const EdgeInsets.only(top: 8, right: 10, bottom: 33),
        alignment: Alignment.topRight,
        onPressed: () {
          if (arrMemberList.isNotEmpty && widget.tripId.isNotEmpty) {
            context.read<UserBloc>().add(UpdateTripMemberData(
                  tripId: widget.tripId,
                  tripMemberDetails: arrMemberList,
                ));
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('members data is added!')));

            Navigator.pop(context);
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              title: 'Oops...',
              text: 'Please fill the proper details',
            );
          }
        },
        icon: const Icon(Icons.check, size: 27),
      ),
    );
  }

  Future<void> buildShowAddMemberModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 55,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Add Trip Member',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 22,
                        onPressed: () {
                          _nameController.clear();
                          _phoneController.clear();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              nameFormFiledView(),
              mobileNumberFormFiledView(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 18),
                child: GestureDetector(
                    onTap: () {
                      if (_nameController.text.length <= 2) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: 'Oops...',
                          text: 'The name must be at least 2 characters long',
                        );
                      } else if (_phoneController.text.length != 10) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: 'Oops...',
                          text:
                              'The mobile number you entered is invalid. Please enter a valid mobile number.',
                        );
                      } else if (_nameController.text.isNotEmpty &&
                          _phoneController.text.isNotEmpty) {
                        setState(() {
                          arrMemberList.add(TripMemberModel(
                              _nameController.text, _phoneController.text));
                          _nameController.clear();
                          _phoneController.clear();
                          Navigator.pop(context);
                        });
                      }
                    },
                    child:
                        TripUtils().bottomButtonDesignView(buttonText: 'Add')),
              )
            ],
          ),
        );
      },
    );
  }

  InputDecoration inputDecoration({required String hintText}) {
    return InputDecoration(
        hintText: hintText,
        focusColor: Colors.black,
        fillColor: Colors.grey.shade100,
        filled: true,
        contentPadding: const EdgeInsets.only(left: 8),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        disabledBorder: const OutlineInputBorder());
  }

  Widget nameFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextField(
        controller: _nameController,
        autofillHints: const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Name'),
        onSubmitted: (String value) {
          setState(() {
            if (value.isNotEmpty) {
              _nameController.clear();
            }
          });
        },
        // keyboardType: TextInputType.text,
      ),
    );
  }

  Widget mobileNumberFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextFormField(
        controller: _phoneController,
        autofillHints: const [AutofillHints.telephoneNumber],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'mobile number'),
        keyboardType: TextInputType.phone,
        validator: (String? value) {
          phoneValidation(value!);
        },
      ),
    );
  }

  String phoneValidation(String value) {
    const String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return 'Successfully added Mobile No';
  }
}
