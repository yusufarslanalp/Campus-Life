import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'main.dart';

//View > Tool Windows > Device File Explorer 
///data/user/0/com.example.campus_life/app_flutter/computer_engineering.txt

class Read_file extends StatelessWidget {

  String data;

  TextStyle style1 = TextStyle(
    fontSize: 20.0,
  );

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/computer_engineering.txt');
  }

  Future<File> write_file() async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString( "Some data" );
  }


  Future<String>  read_file() async {
    try {
      print( "HEREEEEEEEEEEEEEEE111" );
      final file = await _localFile;

      // Read the file.
      String content = await file.readAsString();
      print( content );
      print( file.path );

      return content;
    } catch (e) {
      // If encountering an error, return 0.
      print( e );
      return "ERROR";
    }
  }

  void foo() async{
    //await write_file();
    await read_file();

  }

  @override
  Widget build(BuildContext context) {
    foo();

    String str = '{"acd_rank":"Prof. Dr. ","name":" Fatih Erdoğan SEVİLGEN ","departmant":"Bilgisayar Mühendisliği ","phone":"(262) 605 22 10","email":"sevilgen@gtu.edu.tr","office":"A2 Blok, 206","study_areas":[" Paralel ve Dağıtık Hesaplama Yöntemleri ve Algoritmalar "," Dağıtık Simülasyon Teknikleri "," Sezgisel Optimizasyon Yöntemleri "," Biyoinformatik "," Parçacık Tabanlı Simülasyon Sistemleri"]}';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text( "App Bar" ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {

          },
          child: Text( "Ofise Git" ),
        ),
        body: Text( "Not implementedddd", style: style1,  ),

      ),
    );
  }


}

