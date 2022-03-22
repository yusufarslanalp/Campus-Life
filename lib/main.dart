import 'dart:io';

import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'Personal_page.dart';
import 'Contacts.dart';
import 'Map_page.dart';
import 'MTransportation.dart';
import 'dining.dart';
import 'Read_file.dart';
import 'Stuff.dart';
import 'graph.dart';
import 'search_bar.dart';

import 'package:dcdg/dcdg.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {

  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  TabBarDemo(), //LocalSearchAppBarPage(), // Serach_bar()  //Read_file()

    );
  }
}

class TabBarDemo extends StatefulWidget {
  int goto_tab;
  TabBarDemo.tab( this.goto_tab );

  TabBarDemo(  )
  {
    goto_tab = 0;
  }

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo>
    with SingleTickerProviderStateMixin {

  List<Widget> grp;
  TabController _controller;
  int _selectedIndex = 0;
  String local = "locaaaal";
  Contacts contacts = Contacts();


  List<Widget> list = [
    Tab(icon: Icon(Icons.contacts)),
    Tab(icon: Icon(Icons.emoji_transportation)),
    Tab(icon: Icon(Icons.map)),
    Tab(icon: Icon(Icons.food_bank)),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    print( "LENNNNNNNNNNNN: " + list.length.toString() );



    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());


    });

    _controller.animateTo( widget.goto_tab );

    print( "HEREEEEEEEEEEEE: " + list.length.toString() );

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            onTap: (index) {
              // Should not used it as it only called when tab options are clicked,
              // not when user swapped
            },
            controller: _controller,
            tabs: list,
          ),
          title: Text( globals.app_title ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            contacts,
            MTransportation(),
            MapSample(),
            Dining(),
          ],
        ),
      ),
    );
  }







}

