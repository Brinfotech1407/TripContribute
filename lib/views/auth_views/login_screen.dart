import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/login/cubit/auth_cubit.dart';
import 'package:trip_contribute/login/cubit/auth_state.dart';
import 'package:trip_contribute/services/preference_service.dart';

import 'package:trip_contribute/tripUtils.dart';
import 'package:trip_contribute/views/auth_views/otp_screen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:trip_contribute/views/create_trip.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PreferenceService _preferenceService = PreferenceService();

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
            BlocConsumer<AuthCubit, AuthState>(
              listener: (BuildContext context, Object? state) {
                if (state is AuthCodeSentState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('successfully login')));
                  Navigator.of(context).push(MaterialPageRoute<Widget>(
                      builder: (_) => const OTPScreen()));
                }
              },
              builder: (BuildContext context, Object? state) {
                if (state is AuthLoadingState) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Align(
                  child: InkWell(
                    onTap: () {
                      if (_phoneController.text.isEmpty) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.info,
                          title: 'Oops...',
                          text:
                              'You forgot to enter the Mobile Number. Please enter the Mobile Number to continue.',
                        );
                      } else if (_phoneController.text.length != 10) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: 'Oops...',
                          text:
                              'The mobile number you entered is invalid. Please enter a valid mobile number.',
                        );
                      } else {
                        final String phoneNo = '+91' + _phoneController.text;
                        BlocProvider.of<AuthCubit>(context).sendOTP(phoneNo,context);
                      }
                      submitForm();
                    },
                    child: TripUtils()
                        .bottomButtonDesignView(buttonText: 'Get OTP'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileNumberFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _phoneController,
          autofillHints: const [AutofillHints.telephoneNumber],
          cursorColor: Colors.black,
          decoration: InputDecoration(
              hintText: 'Enter Mobile number',
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
              disabledBorder: const OutlineInputBorder()),
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
