import 'package:flutter/material.dart';

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
  final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animController!,
        builder: (context, child) {
          return  Container(
            transform: Matrix4.translationValues(
                _containerSizeAnimation!.value * width - width-110, 00, 0.0),
           // width: _containerSizeAnimation!.value * height,
            //height: _containerSizeAnimation!.value * height,
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
  }

  TextStyle buildTextStyle() {
    return const TextStyle(fontSize: 35,fontFamily: 'Italiana');
  }
}
