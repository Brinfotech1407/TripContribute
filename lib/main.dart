import 'package:flutter/material.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_accessor.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_bloc.dart';
import 'package:trip_contribute/models/okdone_state.dart';
import 'package:trip_contribute/views/auth_views/login_screen.dart';
import 'package:trip_contribute/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Contribute',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Jost',
      ),
      home: const MyHomePage(),
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
    return OkDoneProvider(
      create: (BuildContext context) => OkDoneBloc(
          initialState:
              OkDoneState((OkDoneStateBuilder b) => b.isLoading = false)),
      child: const Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
