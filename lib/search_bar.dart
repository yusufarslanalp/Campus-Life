import 'dart:async';

import 'package:campus_life/Stuff.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'Personal_page.dart';


class CitySearch extends SearchDelegate<String> {
  Completer<http.Response> _responseCompleter = new Completer();
  Completer<http.Response> _responseCompleter2 = new Completer();

  CitySearch (){
    print( "CONSTRUNCTOR" );
    //wrap_get_data();
  }

  List<String> cities = [
    'Berlin',
    'Paris',
    'Munich',
    'Hamburg',
    'London',
  ];      /**/

  List<String> recentCities = [
    'Berlin',
    //'Munich',
    //'London',
  ];

  bool has_list = false;
  List<String> names_and_deps;
  List<String> names = [];
  Map<String, String> name_to_dep = new Map<String, String>();



  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
          showSuggestions(context);
        }
      },
    )
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  Widget
  get_stuff( String stuff_name, String stuff_dep ) // TURN GET_SUFF FUNCTİON IN TO STATEFULL WIDGET
  {

    print( 'https://us-central1-campus-live-307312.cloudfunctions.net/app/api/get_stuff/${stuff_dep}/${stuff_name}' );
    print( "HEREEEEEEEEEEEEEEEEEEEEEE 1111111111111111111111111111" );
    if (!_responseCompleter2.isCompleted) {
      print( "HEREEEEEEEEEEEEEEEEEEEEEE 2222222222222222222222222222222" );

      var uri =
      Uri.parse( 'https://us-central1-campus-live-307312.cloudfunctions.net/app/api/get_stuff/${stuff_dep}/${stuff_name}' ); //'https://us-central1-campus-live-307312.cloudfunctions.net/app/api/' + acd_mng + '/' + dep
      _responseCompleter2.complete(http.get(uri));
    }


    return new FutureBuilder(
      future: _responseCompleter2.future,
      builder:
          (BuildContext context, AsyncSnapshot<http.Response> response) {
        print( ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: In Builder function" );
        if (!response.hasData) {
          print( ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: In Builder function" );
          return CircularProgressIndicator();
        } else if (response.data.statusCode != 200) {
          return CircularProgressIndicator();
        } else {
          String json_str = response.data.body;
          print( "BELOWWWWWWwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww" );
          print( json_str );
          print( "Upppppppppppppppppppppppppppppppppppppppppppppppp" );

          for( int i = 0; i < 500; i++ )
          {
            i += 1;
            i -= 1;
          }

          print( Stuff.from_json( json_str ) );
          Stuff s = Stuff.from_json( json_str );




          //return ElevatedButton(onPressed: (){ Navigator.push(context, new MaterialPageRoute(builder: (context) => Personal_page( s ))); }, child: Text( "BTN" ));
          return Personal_page( s );
          //return Personal_page( s );
        }
      },
    );

  }

  @override
  Widget buildResults(BuildContext context){

  print( query );
  print( name_to_dep[query] );
    return get_stuff( query, name_to_dep[query]);
  }

  @override ///////////////////////////////////////////////////////////////////
  Widget buildSuggestions(BuildContext context) {

    if( has_list == false )
    {
      if (!_responseCompleter.isCompleted) {
        var uri =
        Uri.parse( 'https://us-central1-campus-live-307312.cloudfunctions.net/app/api/get_all_names' ); //'https://us-central1-campus-live-307312.cloudfunctions.net/app/api/' + acd_mng + '/' + dep
        _responseCompleter.complete(http.get(uri));
      }


      return new FutureBuilder(
        future: _responseCompleter.future,
        builder:
            (BuildContext context, AsyncSnapshot<http.Response> response) {
          //print( ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: In Builder function" );
          if (!response.hasData) {
            return const Center(
              child: const Text('Loading...'), //
            );
          } else if (response.data.statusCode != 200) {
            return const Center(
              child: const Text('Error loading data'),
            );
          } else {
            String json_str = response.data.body;
            //print( json_str );
            Map<String, dynamic> map = jsonDecode( json_str );
            names_and_deps = (map['ls'] as List)?.map((item) => item as String)?.toList();

            print( names_and_deps[0] );

            for( int i = 0; i < names_and_deps.length; i +=2 )
            {
              names.add( names_and_deps[i] );
              name_to_dep[ names_and_deps[i] ] = names_and_deps[ i+1 ];
            }
            print( "DONE ----------------------------------------------------------------------------------------------------------------------------------" );
            has_list = true;
            /*return const Center(
              child: const Text('DONE'),
            );
            print( "HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEE" );*/

            final suggestions = names.where((city) {
              final cityLower = city.toLowerCase();
              String queryLower = query.toLowerCase();
              queryLower = queryLower.trim();

              print( "****************************************************************************************************************" );
              return cityLower.contains(queryLower); //.startsWith(queryLower);
            }).toList();

            return buildSuggestionsSuccess(suggestions);
          }
        },
      );
    }
    else
    {
      final suggestions = names.where((city) {
        final cityLower = city.toLowerCase();
        String queryLower = query.toLowerCase();
        queryLower = queryLower.trim();

        print( "****************************************************************************************************************" );
        return cityLower.contains(queryLower); //.startsWith(queryLower);
      }).toList();

      return buildSuggestionsSuccess(suggestions);

      return const Center(
        child: const Text(''), //
      );
    }









  }

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
      final suggestion = suggestions[index];
      //final queryText = suggestion.substring(0, query.length);
      //final remainingText = suggestion.substring(query.length);

      return ListTile(
        onTap: () {
          query = suggestion;

          // 1. Show Results
          showResults(context);

          // 2. Close Search & Return Result
          // close(context, suggestion);

          // 3. Navigate to Result Page
          //  Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => ResultPage(suggestion),
          //   ),
          // );
        },
        leading: Icon(Icons.location_city),
        // title: Text(suggestion),
        title: Text( suggestion ),
      );
    },
  );
}

















/*class LocalSearchAppBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text( "Some title" ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            showSearch(context: context, delegate: CitySearch());

            // final results = await
            //     showSearch(context: context, delegate: CitySearch());

            // print('Result: $results');
          },
        )
      ],
      backgroundColor: Colors.purple,
    ),
    body: Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Local Weather Search',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 64,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}*/

