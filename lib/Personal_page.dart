import 'package:cached_network_image/cached_network_image.dart';

import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'main.dart';
import 'Stuff.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Map_page.dart';

class Personal_page extends StatelessWidget {
  Stuff stuff;

  Widget
  study_area_box()
  {
    List<Widget> study_areas = [];

    study_areas.add( Text( "Çalışma Alanları:", style: style2, ) );
    for( int i = 0; i < stuff.study_areas.length; i++ )
    {
      study_areas.add( Text( "•" + stuff.study_areas[i], style: style1, ) );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: study_areas,
      ),
    );
  }


  TextStyle style1 = TextStyle(
    fontSize: 18.0,
  );

  TextStyle style2 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  Personal_page( this.stuff );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( stuff.acd_rank + stuff.name ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push( MaterialPageRoute(builder: (context) => MapSample()        ) );
        },
        child: Text( "Ofise Git" ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Image( image: AssetImage( "assets/sevilgen.jpg" ),),
              Container(
                width: 120, height: 180,

                child:CachedNetworkImage(
                  imageUrl: stuff.image_url,
                  placeholder: (context, url) => Text( "Resim \nYükleniyor...", style: TextStyle( fontSize: 20 ), ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
                //Image.network( stuff.image_url, fit: BoxFit.fill ),
              ),

              Container(
                height: 200,
                padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text( "Bölüm: " + stuff.department, style: TextStyle( fontSize: 16 ) ),
                    Text( "Office: " + stuff.ofis, style: TextStyle( fontSize: 16 ) ),
                    Text( "eposta: " + stuff.eposta, style: TextStyle( fontSize: 16 ) ),
                    Text( "phone: " + stuff.phone, style: TextStyle( fontSize: 16 ) ),

                  ],
                ),

              ),



            ],
          ),
          study_area_box(),

        ],


      ),

    );
  }
}

