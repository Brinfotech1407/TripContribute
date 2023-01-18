

import 'package:flutter/material.dart';

import 'package:trip_contribute/tripUtils.dart';
import 'package:trip_contribute/views/auth_views/otp_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TripUtils().buildContainer(),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 30, bottom: 10),
              child: Text(
                'Login Account',
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
                'Hello, Welcome back to our account',
                textAlign: TextAlign.left,
                style: TextStyle(
                    // color: Color.fromRGBO(37, 37, 37, 1),
                    fontSize: 14,
                    height: 1),
              ),
            ),
            mobileNumberFormFiledView(),
            Align(
              child: InkWell(
                onTap: () {
                  setState(() {
                    submitForm();
                    if (_phoneController.text.isNotEmpty) {
                    Navigator.of(context).push(
                        MaterialPageRoute<Widget>(
                            builder: (_) => const OTPScreen()));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('successfully login')));
                    } else {
                      const SnackBar(
                          content: Text('Please enter proper Details'));
                    }
                    const SnackBar(
                        content: Text('Please Fill the above details'));
                  });
                },
                child: TripUtils().bottomButtonDesignView(buttonText: 'Get OTP')
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileNumberFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10,top: 20),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _phoneController,
          autofillHints:  const [AutofillHints.telephoneNumber],
          cursorColor: Colors.black,
          decoration: InputDecoration(
              hintText: 'Enter Mobile number',
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
              disabledBorder: const OutlineInputBorder(

              )),
          keyboardType: TextInputType.phone,
          validator: (String? value) {
            const Pattern pattern =
                r'^(?:\+?1[-.●]?)?\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$';
            final RegExp regex = RegExp(pattern.toString());
            if (!regex.hasMatch(value!)) {
              return 'Enter a valid phone number';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  void submitForm() {
    final FormState formState = _formKey.currentState!;
    if (formState.validate()) {
      print('form is valid');
      formState.save();
    } else {
      print('form is invalid');
    }
  }
}
