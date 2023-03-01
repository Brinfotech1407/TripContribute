import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:trip_contribute/models/profile_model.dart';
import 'package:trip_contribute/tripUtils.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_state.dart';

class CrateTripScreen extends StatefulWidget {
  CrateTripScreen({Key? key, required this.tripName}) : super(key: key);
  final String tripName;

  @override
  State<CrateTripScreen> createState() => _CrateTripScreenState();
}

class _CrateTripScreenState extends State<CrateTripScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<String> selectedList = <String>[];
  List<String> addMemberList = <String>[];

  @override
  void initState() {
    selectedList.add(widget.tripName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            if (state is GetSingleUser) {
              return Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: createTripHeaderView(
                          userName: state.userData.name)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String tripName = selectedList[index];
                        return Card(
                          margin: const EdgeInsets.all(12),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8)),
                              side: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 8),
                                        child: Text(
                                          tripName,
                                          style: const TextStyle(),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          DateTime.now().toString(),
                                      ),

                                      /*IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.only(right: 8),
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),*/
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.yellowAccent,
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Text('Bhavika'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
              }else if (state is UserLoading) {
              return _buildLoading();
               }else {
              return const Text('data not fetched!');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildShowAddMemberModalBottomSheet(context);
        },
        backgroundColor: Colors.black,
        child: IconButton(
          onPressed: () {
            setState(() {
              buildShowAddMemberModalBottomSheet(context);
            });
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
  Padding createTripHeaderView({required String userName}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0,left: 8.0,top: 8.0),
            child:  Text(
              'Hello',
              textAlign: TextAlign.left,
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userName,
              textAlign: TextAlign.left,
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> buildShowAddMemberModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Column(
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
                        if (_nameController.text.isNotEmpty &&
                            _phoneController.text.isNotEmpty) {
                         /* final ProfileModel data = ProfileModel(
                              mobileNo: _phoneController.text,
                              name: _nameController.text,
                              email: '',
                              id: '');*/

                          addMemberList.add(_nameController.text);
                        }else{
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            title: 'Oops...',
                            text:
                            'Please Enter Proper Details',
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: TripUtils()
                          .bottomButtonDesignView(buttonText: 'Add')),
                )
              ],
            );
          },
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
          borderSide: BorderSide(width: 1, color: Colors.grey),
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
            width: 1.0,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ));
  }

  Widget nameFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextFormField(
        controller: _nameController,
        autofillHints: const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Name'),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please enter your name';
          } else if (value.length <= 2) {
            return 'Please enter your name more then 2 char';
          }
          return null;
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
          Pattern pattern =
              r'^(?:\+?1[-.●]?)?\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$';
          RegExp regex = RegExp(pattern.toString());
          if (!regex.hasMatch(value!)) {
            return 'Enter a valid phone number';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
