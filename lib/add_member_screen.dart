import 'package:flutter/material.dart';
import 'package:trip_contribute/tripUtils.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    /*Future.delayed(Duration(seconds: 1)).then((_) {
      //buildShowModalBottomSheet(context);
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
      bottomSheet: buildShowModalBottomSheet(context),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // buildShowModalBottomSheet(context);
        },
        backgroundColor: Colors.black,
        child: IconButton(
          onPressed: () {
            setState(() {
              //buildShowModalBottomSheet(context);
            });
          },
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

   buildShowModalBottomSheet(BuildContext context) {
      return showModalBottomSheet<void>(
       // isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
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
                    padding: const EdgeInsets.only(top: 8.0,bottom: 18),
                    child: GestureDetector(
                        onTap: () {

                        },
                        child: TripUtils().bottomButtonDesignView(buttonText: 'Add')),
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
        validator: (value) {
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
        validator: (value) {
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
