import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'Personal_page.dart';
import 'Stuff.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_bar.dart';

class Contacts extends StatefulWidget {

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts>
    with SingleTickerProviderStateMixin {
  //let say map has element e
  //e.key is department name(comp eng).
  // e.val is list of personal in the computer engineering
  List<List<Stuff>>  academic_personals = List<List<Stuff>>();
  List<List<Stuff>>  administiration_personals = List<List<Stuff>>();
  List<String> departments = List<String>();

  Widget eng_faculty;
  List<String> eng_faculty_departments;
  List<String> eng_deps;

  Widget fund_sci_faculty;
  List<String> fund_sci_faculty_departments;
  List<String> fund_sci_deps;

  Widget buss_admn_faculty;
  List<String> buss_admn_departments;
  List<String> buss_admn_deps;

  Widget archt_faculty;
  List<String> archt_departments;
  List<String> archt_deps;

  Widget institute;
  List<String> institute_departments;
  List<String> institute_deps;

  Widget included_to_rectorate;
  List<String> included_to_rectorate_departments;
  List<String> included_to_rectorate_deps;

  //List<Widget> grp;
  TabController _controller;
  int _selectedIndex = 0;
  String local = "locaaaal";

  TextStyle style1 = TextStyle(
    fontSize: 18.0,
  );

  Widget
  management_widget(  )
  {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: ExpansionTile(
        key: Key("key2"),
        title: Text( "Yönetim Kadrosu" ),
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int person_index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: GestureDetector(
                    child: Text(
                      "name",
                      style: style1,
                    ),
                    onTap: (){
                      //Navigator.of(context).push( MaterialPageRoute(builder: (context) => Personal_page( academic_personals[ department_index ][person_index] ) ) );
                    },
                  ),

                );

              },
              itemCount: 3)
        ],
      ),
    );

  }

  Widget
  create_eng_faculty_tile( String fac_name, List<String> departments, List<String> deps )
  {
    return ExpansionTile(

      key: Key( fac_name ),
      title: Text( fac_name ),
      children: [
      ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical, shrinkWrap: true,
          itemBuilder: (BuildContext context, int department_index) {
            return Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: ExpansionTile(
                key: Key("key"),
                title: Text( departments[ department_index ] ),
                children: [
                  new MyExpansionTile( department_index , "Akademil Kadro", deps[ department_index ]),
                  management_widget(),
                ],
              ),

            );
          },
          itemCount: departments.length),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    //grp = contact_groups();

    eng_faculty_departments = [ "Bilgisayar Mühendisliği", "Biyomühendislik", "Çevre Mühendisliği", "Elektronik Mühendisliği", "Endüstri Mühendisliği", "İnşaat Mühendisliği",
      "harita Mühendisliği", "Kimya Mühendisliği", "Makine Mühendisliği", "Malzeme Bilimi ve Mühendisliği"];
    eng_deps = [ "bil", "biy", "cev", "elk", "end", "ins", "hrt", "kmy", "mkn", "mlz" ];
    eng_faculty = create_eng_faculty_tile( "Mühendislik Fakültesi", eng_faculty_departments, eng_deps );

    fund_sci_faculty_departments = [ "Fizik", "Kimya", "Matematik", "Moleküler Biyoloji ve Genetik" ];
    fund_sci_deps = [ "fiz", "kim", "mat", "mol"  ];
    fund_sci_faculty = create_eng_faculty_tile( "Temel Bilimler Fakültesi" ,fund_sci_faculty_departments, fund_sci_deps );

    buss_admn_departments = [ "İktisat", "İşletme", "Strateji Bilimi" ];
    buss_admn_deps = [ "ikt", "isl", "str" ];
    buss_admn_faculty = create_eng_faculty_tile( "İşletme Fakültesi", buss_admn_departments, buss_admn_deps );


    archt_departments = [ "Mimarlık", "Şehir ve Bölge Planlama", "Endüstriyel Tasarım" ];
    archt_deps = [ "mim", "seh", "ets" ];
    archt_faculty = create_eng_faculty_tile( "Mimarlık Fakültesi", archt_departments, archt_deps );

    institute_departments = [ "Sosyal Bilimler", "Nanoteknoloji", "Yer ve Deniz Bilimleri", "Savunma Teknolojileri" ];
    institute_deps = [ "sos", "nan", "yer", "sav" ];
    institute = create_eng_faculty_tile( "Enstitüler", institute_departments, institute_deps );

    included_to_rectorate_departments = [ "Beden Eğitimi ve Spor Bölümü", "Türkçe Hazırlık Bölümü", "Yabancı Diller Bölümü" ];
    included_to_rectorate_deps = [ "bed", "tur", "yab" ];
    included_to_rectorate = create_eng_faculty_tile( "Rektörlüğe Bağlı Bölümler", included_to_rectorate_departments, included_to_rectorate_deps );

  }

  @override
  Widget build(BuildContext context) {
    globals.app_title = "Akademik Kadro & Yönetim Kadrosu";
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          child: IconButton( icon: Icon( Icons.search, size: 35 ),
            onPressed: () async{ showSearch(context: context, delegate: CitySearch()); }, ),
          alignment: Alignment.centerRight,
        ),
        eng_faculty,
        fund_sci_faculty,
        buss_admn_faculty,
        archt_faculty,
        institute,
        included_to_rectorate,
        ExpansionTile(
          title: Text( "Rektörlüğe Bağlı Kordinatörlükler" ),
          key: Key( "key16" ),
          children: [],
        ),
      ],

    );

  }

}


class MyExpansionTile extends StatefulWidget {
  final int id;
  final String title;
  final String dep;
  MyExpansionTile (this.id, this.title, this.dep);
  @override
  State createState() => new MyExpansionTileState();
}

class MyExpansionTileState extends State<MyExpansionTile> {
  PageStorageKey _key;
  Completer<http.Response> _responseCompleter = new Completer();

  @override
  Widget build(BuildContext context) {
    _key = new PageStorageKey('${widget.id}');
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child:    new ExpansionTile(
          key: _key,
          title: new Text(widget.title),
          onExpansionChanged: (bool isExpanding) {
            if (!_responseCompleter.isCompleted) {
              var uri =
              Uri.parse( 'https://us-central1-campus-live-307312.cloudfunctions.net/app/api/' + "acd" + '/' + widget.dep ); //'https://us-central1-campus-live-307312.cloudfunctions.net/app/api/' + acd_mng + '/' + dep
              _responseCompleter.complete(http.get(uri));
              print("Getting Expansion Item # ${widget.id}");
            }
          },
          children: <Widget>[
            new FutureBuilder(
              future: _responseCompleter.future,
              builder:
                  (BuildContext context, AsyncSnapshot<http.Response> response) {
                //print( ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: In Builder function" );
                if (!response.hasData) {
                  return const Center(
                    child: const Text('Loading...'),
                  );
                } else if (response.data.statusCode != 200) {
                  return const Center(
                    child: const Text('Error loading data'),
                  );
                } else {
                  //List<dynamic> json_data = json.decode(response.data.body);
                  List<Widget> reasonList = [];
                  String s;
                  s =  response.data.body;
                  //print( ":::::::::::::::" + s );
                  List<dynamic> ls = jsonDecode(s);

                  List<Stuff> users = ls.map((ls) => Stuff.from_map(ls)).toList();
                  //return users;

                  users.forEach((element) {
                    reasonList.add(new ListTile(
                      //dense: true,
                      title: new Text( element.acd_rank + element.name ),
                      onTap: () {
                        print("PRESSSSSSSSSSSSSSSSSSSSSSSSSSEDDDDDDDDDDDDDDDD");
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => Personal_page( element )));
                      },
                    ));
                  });
                  return Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: new Column(children: reasonList),
                  );
                }
              },
            )
          ],
        ),

    );


  }
}








/*Widget
  expansion( String dep ) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
    );
    return FutureBuilder(
      future: take_data( "acd", dep ), //
      builder: (BuildContext context, AsyncSnapshot snapshot){
        //print(snapshot.data);
        if(snapshot.data == null){
          return Container(
              child: Center(
                  child: Text("Loading...")
              )
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                //leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data[index].picture),),
                title: Text(snapshot.data[index].name ),
                subtitle: Text( snapshot.data[index].eposta ),
                onTap: (){
                  //take_data();
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => Personal_page(snapshot.data[index])));

                },
              );
            },
          );
        }
      },
    );
  }*/


/*Future<List<Stuff>> take_data( String acd_mng, String dep ) async {
    print( "CALLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL" );

    var uri =
    Uri.parse('https://us-central1-campus-live-307312.cloudfunctions.net/app/api/' + acd_mng + '/' + dep );
    print( "In takeeeeeeeeeeeeeeeeeeeeeeeee" );
    var response = await http.get(uri);



    if (response.statusCode == 200) {
      String s;
      s =  response.body;
      print( ":::::::::::::::" + s );
      List<dynamic> data = jsonDecode(s);

      Stuff stf = Stuff.from_map( data[0] );
      //print( stf );

      //print( data[0][ "study_areas" ] );
      //std_ls = jsonDecode( data[0][ "study_areas" ] );
      //print( data[0][ "study_areas" ][0] );
      print( "uppppppppppp" );
      List<Stuff> users = data.map((data) => Stuff.from_map(data)).toList();
      return users;
      print( users[0] );

      //print( s );
    } else {
      print( "failllllllllllllllllllllllllllllll" );
      print('Request failed with status: ${response.statusCode}.');
    }

  }*/

/*Widget
  department_widget( String dep )
  {

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: ExpansionTile(
        onExpansionChanged: (bool isExpanding) {
          if( isExpanding )
          {
            print( "iffffffffffffffffffffffffffffffffffffff" );
            setState(() {
              //w = expansion( dep );
            });
          }
        }  ,
        key: Key("key1"),
        title: Text( "Akademik Kadro" ),
        children: [
          w,

        ],
      ),
    );
  }*/