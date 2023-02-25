import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:trip_contribute/login/cubit/auth_cubit.dart';
import 'package:trip_contribute/login/cubit/auth_state.dart';
import 'package:trip_contribute/tripUtils.dart';
import 'package:velocity_x/velocity_x.dart';

import 'profile_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    otpController.dispose();
    focusNode.dispose();
    super.dispose();
  }

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
            20.heightBox,
            Align(
              child: VxPinView(
                onEditingComplete: () {},
                onSubmitted: (String value) {
                  value == '123456' ? null : 'Pin is incorrect';
                },
                count: 6,
                size: 45,
                color: Colors.grey,
                obscureText: false,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  print('Test value=$value');
                  setState(() {
                    otpController.text = value;
                  });
                },
              ),
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (BuildContext context, Object? state) {
                if (state is AuthLoggedInState) {
                  Navigator.popUntil(context, (Route route) => route.isFirst);
                  Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                      builder: (_) =>  ProfileScreen(currentUser: state.firebaseUser,)));
                } else if (state is AuthErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.error),
                    duration: const Duration(milliseconds: 600),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              },
              builder: (BuildContext context, Object? state) {
                if (state is AuthLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      if (otpController.text.isEmpty) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.info,
                          title: 'Oops...',
                          text:
                              'You forgot to enter the OTP. Please enter the OTP to continue.',
                        );
                      } else if (state is AuthErrorState) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: 'Oops...',
                          text:
                              'The OTP you entered is incorrect. Please try again',
                        );
                      } else {
                        BlocProvider.of<AuthCubit>(context)
                            .verifyOTP(otpController.text);
                      }
                    },
                    child: TripUtils()
                        .bottomButtonDesignView(buttonText: 'Verifying OTP'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  final PinTheme defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: const TextStyle(
      fontSize: 21,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade400),
    ),
  );
}
