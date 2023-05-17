import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:trip_contribute/tripUtils.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/user/user_state.dart';
import 'package:trip_contribute/views/create_trip.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {Key? key, required this.currentPhoneNumber, required this.context})
      : super(key: key);
  final String currentPhoneNumber;
  final BuildContext context;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _phoneController.text = widget.currentPhoneNumber;
    print('current user${widget.currentPhoneNumber}');
    super.initState();
  }

  @override
  Widget build(BuildContext contexts) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc()
            ..add(UserProfileAlreadyStore(mobileNo: widget.currentPhoneNumber)),
          child: BlocListener<UserBloc, UserState>(
            listener: (BuildContext context, UserState state) {
              if (state is UserLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Users added!')));
              }
              if (state is UserCheckAlready) {
                if (state.isUSerAlreadyProfile) {
                  Navigator.of(contexts).push(MaterialPageRoute<void>(
                    builder: (_) {
                      return CrateTripScreen(
                        userName: _nameController.text,
                      );
                    },
                  ));
                }
              }
            },
            // ignore: always_specify_types
            child: BlocBuilder<UserBloc, UserState>(
              builder: (BuildContext context, UserState state) {
                /*if (state is UserCheckAlready) {
                  return const Center(child: CircularProgressIndicator());
                } else {*/
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        child: InkWell(
                          onTap: () {
                            submitForm();
                            if (_emailController.text.isNotEmpty &&
                                _nameController.text.isNotEmpty &&
                                _phoneController.text.isNotEmpty) {
                              contexts.read<UserBloc>().add(AddUser(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    mobileNo: _phoneController.text,
                                    context: contexts,
                                  ));
                              Navigator.of(contexts)
                                  .push(MaterialPageRoute<void>(
                                builder: (_) {
                                  return CrateTripScreen(
                                    userName: _nameController.text,
                                  );
                                },
                              ));
                            } else {
                              QuickAlert.show(
                                context: contexts,
                                type: QuickAlertType.info,
                                text:
                                    'Please provide your name, email, and phone number before submitting.',
                              );
                            }
                          },
                          child: TripUtils()
                              .bottomButtonDesignView(buttonText: 'Submit'),
                        ),
                      ),
                    ]);
                // }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget textFiledViews() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            mobileNumberFormFiledView(),
            nameFormFiledView(),
            emailFormFiledView(),
          ],
        ));
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

  Widget mobileNumberFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: TextFormField(
        controller: _phoneController,
        autofillHints: const [AutofillHints.telephoneNumber],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Enter Mobile number'),
        keyboardType: TextInputType.phone,
        readOnly: true,
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
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: TextFormField(
        controller: _nameController,
        autofillHints: const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Your Name *'),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please enter your name';
          } else if (value.length <= 2) {
            return 'Your name must be at least 2 characters long';
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget emailFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: TextFormField(
        controller: _emailController,
        autofillHints: const [AutofillHints.email],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Email'),
        keyboardType: TextInputType.emailAddress,
        validator: (String? value) {
          const Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          final RegExp regex = RegExp(pattern.toString());
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
