import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

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
  final double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
              VxShimmer(
                gradient:const LinearGradient(
              colors: [

                Color.fromRGBO(38, 38, 38, 0.4),
              Color.fromRGBO(107, 105, 105, 1)
              ],
                  begin: Alignment(6.123234262925839e-17, 1),
                  end: Alignment(-1, 6.123234262925839e-17),
                ),
                primaryColor: Colors.lightBlueAccent,
                secondaryColor: Colors.black,
                child: Text(
                  'Trip\nContribute',
                  textAlign: TextAlign.right,
                  style: buildTextStyle(),
                ),
              ),
          ],
            ),
          );
        },
      ),
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(fontSize: 35,fontFamily: 'Italiana');
  }
}
