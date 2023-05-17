import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/login/cubit/auth_cubit.dart';
import 'package:trip_contribute/services/preference_service.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/views/auth_views/login_screen.dart';
import 'package:trip_contribute/views/create_trip.dart';
import 'package:trip_contribute/views/splash_screen.dart';

import 'login/cubit/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //when app load then firebase also initialize
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc()
            ..add(const UserPreferenceServiceInit()),
        ),
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
        ),
      ],
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
              return CrateTripScreen(userName: state.firebaseUser.displayName);
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
  final PreferenceService _preferenceService = PreferenceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: Future<dynamic>.delayed(const Duration(seconds: 2)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else {
            bool userLogin =
                _preferenceService.getBool(PreferenceService.userLogin) ??
                    false;
            String userName =
                _preferenceService.getString(PreferenceService.User_Name) ?? '';
            if (userLogin) {
              return CrateTripScreen(userName: userName);
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }
}
