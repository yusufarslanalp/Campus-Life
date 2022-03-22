import 'package:flutter/material.dart';
import 'globals.dart' as globals;


class Dining extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globals.app_title = "Yemekhane";


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 350,
          child: Image.asset(
            'assets/yemek_listesi.jpg',
            fit: BoxFit.contain,
          ),
        ),
        ElevatedButton(onPressed: (){}, child: Text( "Yemekhaneye Git" )),

      ],
    );




  }
}