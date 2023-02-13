import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/login/cubit/auth_cubit.dart';
import 'package:trip_contribute/views/add_member_screen.dart';
import 'package:trip_contribute/views/auth_views/login_screen.dart';
import 'package:trip_contribute/views/splash_screen.dart';

import 'login/cubit/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //when app load then firebase also initialize
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return BlocProvider(
      create: (BuildContext context) => AuthCubit(),
      child: MaterialApp(
        title: 'Trip Contribute',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Jost',
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (AuthState previous, AuthState current) {
            return previous is AuthInitialState;
          },
          builder: (BuildContext context, AuthState state) {
            if (state is AuthLoggedInState) {
              return const AddMemberScreen();
            } else if (state is AuthLoggedOutState) {
              return const MyHomePage();
            } else {
              return const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: Future<dynamic>.delayed(const Duration(seconds: 2)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
