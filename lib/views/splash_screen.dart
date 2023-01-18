import 'package:flutter/material.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_accessor.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_view_model.dart';
import 'package:trip_contribute/views/auth_views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with
    SingleTickerProviderStateMixin {
   AnimationController? _animController;
   Animation? sizeAnimation;

   Animation? _containerRadiusAnimation,
       _containerSizeAnimation,
       _containerColorAnimation;



  @override
  void initState() {
    super.initState();
    _animController =  AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));

    _containerSizeAnimation = Tween(begin: 0.0, end: 2.0).animate(
        CurvedAnimation(
            curve: Curves.ease, parent: _animController!));


    _animController!.forward();

  }

   @override
   void dispose() {
     _animController!.dispose();
     super.dispose();

   }


@override
  Widget build(BuildContext context) {
    return OkDoneConnector(
      onInitState: (OkDoneViewModel model) {
         model.redirectToHomeScreen();
      },
      condition: (OkDoneViewModel previous, OkDoneViewModel current) {
        if(previous.isLoading ==false && current.isLoading ==true){
          Navigator.of(context).push(
              MaterialPageRoute<List<String>>(
                  builder: (_) =>
                  const LoginScreen()));
        }
        return true;
      },
      builder: (BuildContext context, OkDoneViewModel model) {
        return  Scaffold(
          body: AnimatedBuilder(
            animation: _animController!,
            builder: (BuildContext context, Widget? child) {
              return  Container(
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
                  ));
            },
          ),
        );
      },
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(fontSize: 35,fontFamily: 'Italiana');
  }
}
