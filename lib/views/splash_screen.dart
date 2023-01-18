import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animController;
  Animation? sizeAnimation;

  Animation? _containerSizeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
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
          return Container(
              transform: Matrix4.translationValues(
                  _containerSizeAnimation!.value * width - width - 100,
                  00,
                  0.0),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  nameWidget,
                ],
              ));
        },
      ),
    );
  }

  get nameWidget {
    return 'Trip\nContribute'
      .text
      .xl5
      .fontFamily('Italiana')
        .lineHeight(1)
      .size(context.isMobile ?15 :20)
      .align(TextAlign.right)
      .end.bold
      .makeCentered().shimmer(primaryColor: Colors.black).offset(offset: const Offset(0, 0));
  }
}
