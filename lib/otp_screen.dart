import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:trip_contribute/tripUtils.dart';


import 'profile_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final focusNode = FocusNode();


  @override
  void dispose() {
    otpController.dispose();
    focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TripUtils().buildContainer(),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 30, bottom: 10),
              child: Text(
                'Verifying OTP',
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
        Align(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: otpController,
                    focusNode: focusNode,
                    androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,

                    validator: (value) {
                      return value == '1234' ? null : 'Pin is incorrect';
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade900),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (otpController.text.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => const ProfileScreen()));
                    }
                  });
                },
                child: TripUtils().bottomButtonDesignView(buttonText: 'Verifying OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
