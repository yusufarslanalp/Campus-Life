import 'package:flutter/material.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'globals.dart' as globals;
import 'Map_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<String> locations = [];
  List<String> road_choice_ls = ["Yürüyerek - En kısa yol", "Yürüyerek - Gölgelik yol", "Arabayla" ];

  @override
  void initState() {
    //super.initState();
    globals.locations.forEach((k, v) => this.locations.add(k));
  }

  String start_point;
  String end_point;
  String road_choice;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yol Tarifi Al"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropDownField(

                    onValueChanged: (dynamic value) {
                      start_point = value;
                    },

                    value: start_point,
                    required: false,
                    hintText: 'Bir konum seçin',
                    labelText: 'Nereden: ',
                    items: locations,
                  ),
                ]),
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropDownField(
                    onValueChanged: (dynamic value) {
                      end_point = value;
                    },
                    value: end_point,
                    required: false,
                    hintText: 'Bir konum seçin',
                    labelText: 'Nereye: ',
                    items: locations,
                  ),
                ]),
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropDownField(
                    onValueChanged: (dynamic value) {
                      road_choice = value;
                    },
                    value: road_choice,
                    required: false,
                    labelText: 'Yol tercihi: ',
                    items: road_choice_ls,
                  ),
                ]),
          ),
          ElevatedButton(
             onPressed: () {
               print( "Start:::::::::::::::::::::::::::"+ start_point.toString() );
               print( "end:::::::::::::::::::::::::::"+ end_point.toString() );

               Navigator.pop(context, true);
               globals.map_sample_ref.set_route_info( start_point, end_point, road_choice);

               //MapSampleState.set_points( start_point, end_point );

            }, child: Text("Rotamı Bul")
          ),
        ],
      ),
    );
  }
}
