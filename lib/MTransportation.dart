import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Map_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Bus {
  String name;
  List<int> hours = [];
  List<int> minutes = [];
  int bus_index;
  String display = "Loading...";
  String title;
  String web_page;

  Future<String> take_data(  ) async {
    print( "CALLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL" );
    var uri =
    Uri.parse('https://us-central1-campus-live-307312.cloudfunctions.net/app/api/get_vehicle/' + this.name );
    print( "In takeeeeeeeeeeeeeeeeeeeeeeeee" );
    var response = await http.get(uri);



    if (response.statusCode == 200) {
      String s;
      if(response.body.isNotEmpty) {
        s =  response.body;
      }
      else return "done";

      //print( s );
      Map<String, dynamic> map = jsonDecode( s );
      List<String> str_hours = (map['hours'] as List)?.map((item) => item as String)?.toList();
      List<String> str_ninutes = (map['minutes'] as List)?.map((item) => item as String)?.toList();

      hours = str_hours.map(int.parse).toList();
      minutes = str_ninutes.map(int.parse).toList();
      print( hours );
      print( minutes );
      first_bus();
      //print( "REUTRNEDDDDDDDDDDDDDDDDDDDDDDDDDDD" );
      return "done";

    } else {
      //print( "ELSEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE" );
      print('Request failed with status: ${response.statusCode}.');
      return "done";
    }



  }

  void foo() async{
    display = "Loading...";
    await take_data();
    print( "ENDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD" );
  }

  String first_bus(  ) {
    int c_hour = DateTime.now().hour;
    int c_minute = DateTime.now().minute;
    int c_time = 60 * c_hour + c_minute;
    int bus_time;
    display = "En Yakın Otobüs: ";

    for( int i = 0; i < hours.length; i++ )
    {
      //print( "GELDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII" );
      bus_time = hours[i] * 60 + minutes[i];
      if( bus_time > c_time )
      {
        bus_index = i;
        display += hours[i].toString() + ":" + minutes[i].toString();
        return display;
      }
    }
  }

  String next()
  {
    display = "";
    String next;
    if( bus_index < hours.length-1 )
    {
      bus_index += 1;
      next = hours[ bus_index ].toString() + ":" + minutes[bus_index].toString();
    }
    else {
      bus_index = 0;
      next = hours[ bus_index ].toString() + ":" + minutes[bus_index].toString();
    }
    display = next;
    return next;
  }

  String prew()
  {
    display = "";
    String next;
    if( bus_index != 0 )
    {
      bus_index -= 1;
      next = hours[ bus_index ].toString() + ":" + minutes[bus_index].toString();
    }
    else {
      bus_index = hours.length-1;
      next = hours[ bus_index ].toString() + ":" + minutes[bus_index].toString();
    }
    return next;
  }


  Bus(this.name, this.title) {}

  Bus.factory(this.name, this.title, this.hours, this.minutes ) {}
}





class MTransportation extends StatefulWidget {
  @override
  _MTransportationState createState() => _MTransportationState();
}

class _MTransportationState extends State<MTransportation> {
  TextStyle style1 = TextStyle(
    fontSize: 20.0,
  );
  TextStyle style2 = TextStyle(
    fontSize: 15.0,
  );

  int changed = 0;

  //Widget chart490;

  Bus bus490;
  Bus bus440;
  Bus bus501;
  Bus bus503;
  Bus bus504;

  Bus ring_fund_sciences;
  Bus ring_main_gate;

  Bus marmaray_uskudar;
  Bus marmaray_gebze;

  @override
  void initState() {

    List<int> hours490;
    List<int> minutes490;

    bus490 = Bus( "bus490" ,"490 GTÜ-Muallimköy");
    bus490.take_data().then((value) {setState(() {});});
    bus490.web_page = 'https://www.kocaeli.bel.tr/tr/main/hatlar/490/muallimkoy-gebze-otogar-yeni-mahalle-gebze-te-otobus-sefer-saatleri-ve-duraklari';

    bus440 = Bus( "bus440" , "440 GTÜ - Yavuz Selim Merkez");
    bus440.take_data().then((value) {setState(() {});});
    bus440.web_page = 'https://www.kocaeli.bel.tr/tr/main/hatlar/440/yavuz-selim-gebze-farabi-dh-gebze-teknik-otobus-sefer-saatleri-ve-duraklari';


    bus503 = Bus( "bus503" , "503 (E-5 Kapısından geçer)");
    bus503.take_data().then((value) {setState(() {});});
    bus503.web_page = 'https://www.kocaeli.bel.tr/tr/main/hatlar/503/kentonu-gebze-teknik-uni-nenehatun-istasyon-f-otobus-sefer-saatleri-ve-duraklari';


    bus504 = Bus( "bus504" , "504 (E-5 Kapısından geçer)");
    bus504.take_data().then((value) {setState(() {});});
    bus504.web_page = 'https://www.kocaeli.bel.tr/tr/main/hatlar/504/kent-kentonu-gebze-teknik-uni-ssogutler-farab-otobus-sefer-saatleri-ve-duraklari';


    List<int> hoursMGate = [
      8, 10, 11, 12, 15
    ];

    List<int> minutesMGate = [
      30, 35, 45, 45, 35
    ];


    List<int> hoursRFund = [
      9, 11, 12, 13, 16
    ];

    List<int> minutesRFund = [
      15, 10, 0, 15, 15
    ];

    ring_main_gate = Bus.factory( "ging_mgate" ,"Ana Kapı Ring", hoursMGate, minutesMGate );
    ring_main_gate.first_bus();
    ring_main_gate.web_page = 'https://www.gtu.edu.tr/kategori/1693/0/display.aspx';


    ring_fund_sciences = Bus.factory( "ring_fsci", "Temel Bilimler Ring", hoursRFund, minutesRFund );
    ring_fund_sciences.first_bus();
    ring_fund_sciences.web_page = 'https://www.gtu.edu.tr/kategori/1693/0/display.aspx';








    marmaray_uskudar = Bus.factory( "ring_fsci", "Marmaray (Üskükadar Yönü)", hoursRFund, minutesRFund );
    //marmaray_uskudar.first_bus();
    marmaray_uskudar.web_page = 'https://www.gtu.edu.tr/kategori/1693/0/display.aspx';

    marmaray_gebze = Bus.factory( "ring_fsci", "Marmaray (Gebze Yönü)", hoursRFund, minutesRFund );
    //marmaray_gebze.first_bus();
    marmaray_gebze.web_page = 'https://www.gtu.edu.tr/kategori/1693/0/display.aspx';

  }


  Widget
  bus_chart( Bus bus )
  {
    return Container(
      //width: double.infinity,
      //height: double.infinity,
      //color: Colors.yellow,
      decoration: myBoxDecoration(),
      margin: EdgeInsets.all( 20 ),
      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue,
            child: Center( child: Text( bus.title, style: style1, ), ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      bus.display = bus.prew();
                    });
                  },
                  child: Icon( Icons.arrow_back_ios )
              ),
              Text( bus.display, style: style2, ),
              ElevatedButton(onPressed: (){
                print( "Button Presseddddddddddddddddddddd" );
                print( bus.name );
                setState(() {
                  changed += 1;
                  bus.next();
                });
              }, child: Icon( Icons.arrow_forward_ios ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _launchURL( bus.web_page ),
                child: Text( "Ayrıntılar" ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push( MaterialPageRoute( builder: (context) => MapSample() ) );
                },
                child: Text( "Yol Tarifi" ),
              )
            ],
          ),
        ],

      ),
    );


  }


  _launchURL( String url ) async {
    print( "lunh url" );
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  @override
  Widget build(BuildContext context) {
    globals.app_title = "Ring & Toplu Taşıma";


    return ListView(
      children: [
        ExpansionTile(
            key: Key("key100"),
            title: Text( "Belediye Otobüsleri" ),
            children: [
                  //chart490,
                  bus_chart( bus490 ),
                  bus_chart( bus440 ),
                  bus_chart( bus503 ),
                  bus_chart( bus504 ),




            ]
        ),
        ExpansionTile(
            key: Key("key2"),
            title: Text( "Ring Servisleri" ),
            children: [
              bus_chart( ring_main_gate ),
              bus_chart( ring_fund_sciences ),

              ]
        ),
        ExpansionTile(
            key: Key("key3"),
            title: Text( "Marmaray" ),
            children: [
              bus_chart(marmaray_uskudar ),
              bus_chart( marmaray_gebze ),


            ]
        ),




      ],

    );


  }
}



