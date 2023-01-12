import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.centerRight,
           padding: const EdgeInsets.only( right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               Text(
                'Trip',
                textAlign: TextAlign.right,
                style: buildTextStyle(),
              ),
               Text(
                'Contribute',
                textAlign: TextAlign.right,
                style: buildTextStyle(),
              )

            ],
          )),
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(fontSize: 35,fontFamily: 'Italiana');
  }
}
