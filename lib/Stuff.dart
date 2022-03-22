import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'dart:convert';

class Stuff
{
  String name;
  String eposta;
  String ofis;
  String phone;
  String department;
  String acd_rank;
  String image_url;
  List<String> study_areas;

  Stuff( this.name, this.eposta, this.ofis, this.phone, this.department );

  Stuff.from_json( String json_str )
  {
    Map<String, dynamic> map = jsonDecode( json_str );
    Stuff.from_map( map );
  }

  Stuff.from_map( Map<String, dynamic> map )
  {
    name = map[ "name" ];
    eposta = map[ "email" ];
    ofis = map[ "office" ];
    phone = map[ "phone" ];
    department = map[ "departmant" ];
    acd_rank = map[ "acd_rank" ];
    image_url = map[ "image_url" ];
    study_areas = (map['study_areas'] as List)?.map((item) => item as String)?.toList();

    print( "///////////////////////////" );
    print( name );
    print( eposta );
    print( ofis );
    print( phone );
    print( department );
    print( acd_rank );
    print( image_url );
    print( study_areas );

  }

  String  toString()
  {
    String result = "";
    result += "Name: " + name + "\n";
    result += "eposta: " + eposta + "\n";
    result += "ofis: " + ofis + "\n";
    result += "phone: " + phone + "\n";
    result += "department: " + department + "\n";
    result += "acd_rank: " + acd_rank + "\n";
    result += "image_url: " + image_url + "\n";
    result += "study_areas: " + study_areas.toString() + "\n";
    return result;
  }
}