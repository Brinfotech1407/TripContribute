import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:trip_contribute/views/add_member_screen.dart';
import 'package:trip_contribute/tripUtils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 30, bottom: 10),
            child: Text(
              'Profile',
              textAlign: TextAlign.left,
              style: TextStyle(
                  //color: Color.fromRGBO(37, 37, 37, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 30),
            child: Text(
              'First complete your profile details',
              textAlign: TextAlign.left,
              style: TextStyle(
                  // color: Color.fromRGBO(37, 37, 37, 1),
                  fontSize: 14,
                  height: 1),
            ),
          ),
          textFiledViews(),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                submitForm();
                if (_emailController.text.isNotEmpty &&
                    _nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Future.delayed(Duration.zero, () async {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) {
                          return const AddMemberScreen();
                        },));
                    });
                  });
                } else {
                  const SnackBar(content: Text('Please enter proper Details'));
                }
                const SnackBar(content: Text('Please Fill the above details'));
              },
                child:TripUtils().bottomButtonDesignView(buttonText: 'Submit'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget textFiledViews(){
    return Form(
      key: _formKey,
        child: Column(
          children: [
            mobileNumberFormFiledView(),
            nameFormFiledView(),
            emailFormFiledView(),
          ],
        )
    );
  }

  void submitForm() {
    final FormState formState = _formKey.currentState!;
    if (formState.validate()) {
      print( 'form is valid');
      formState.save();
    } else {
      print( 'form is invalid');
    }
  }

  Widget mobileNumberFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: TextFormField(
        controller: _phoneController,
        autofillHints: const [AutofillHints.telephoneNumber],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Enter Mobile number'),
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
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: TextFormField(
        controller: _nameController,
        autofillHints: const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Your Name *'),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your name';
          } else if (value.length <= 2) {
            return 'Please enter your name more then 2 char';
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget emailFormFiledView(){
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: TextFormField(
        controller: _emailController,
        autofillHints: const [AutofillHints.email],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Email'),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern.toString());
          if (!regex.hasMatch(value!)) {
            return 'Enter a valid email';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
