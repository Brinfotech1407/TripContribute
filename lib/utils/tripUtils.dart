import 'package:flutter/material.dart';

class TripUtils {
  Container buildContainer() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 10, top: 8,bottom: 10),
      child: Column(
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
      ),
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(fontSize: 28,fontFamily: 'Italiana');
  }

 Widget bottomButtonDesignView({required String buttonText}){
     return Container(
       width: 301,
       height: 50,
       margin: const EdgeInsets.only(top: 20),
       alignment: Alignment.center,
       decoration: BoxDecoration(
         border: Border.all(
           color: const Color.fromRGBO(180, 176, 176, 1),
         ),
         gradient: const LinearGradient(
             begin: Alignment(6.123234262925839e-17, 1),
             end: Alignment(-1, 6.123234262925839e-17),
             colors: [
               Color.fromRGBO(0, 0, 0, 1),
               Color.fromRGBO(107, 105, 105, 1)
             ]),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, bottom: 8, top: 8, right: 18),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildLoading() => const Center(child: CircularProgressIndicator());

  static List<String> arrAlphabets = <String>[];

  static List<String> getAlphabetsList() {
    arrAlphabets
      ..clear()
      ..add('')
      ..add('A')
      ..add('B')
      ..add('C')
      ..add('D')
      ..add('E')
      ..add('F')
      ..add('G')
      ..add('H')
      ..add('I')
      ..add('J')
      ..add('K')
      ..add('L')
      ..add('M')
      ..add('N')
      ..add('O')
      ..add('P')
      ..add('Q')
      ..add('R')
      ..add('S')
      ..add('T')
      ..add('U')
      ..add('W')
      ..add('X')
      ..add('Y')
      ..add('Z');

    return arrAlphabets;
  }
}
