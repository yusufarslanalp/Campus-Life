import 'globals.dart' as globals;
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'graph.dart';
import 'Select_route_page.dart';
import 'dart:io';

import 'listen_location.dart';

import 'search_bar.dart';
import 'dart:math' as math;
import 'dart:math';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState()
  => globals.map_sample_ref = MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMap map;
  MapType map_type;
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition camera_position;

  Graph graph = new Graph( 148 );
  ListenLocation listen_location;
  List<double> current_locataion = null;

  Set<Marker> _markers = HashSet<Marker>();
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Polyline> _polylines = HashSet<Polyline>();

  List<LatLng> campus_border = List<LatLng>();
  List<LatLng> route_lines = List<LatLng>();
  List<LatLng> test_square = List<LatLng>();

  List<List<LatLng>> sinle_lines = List<List<LatLng>>(); //////////////////////////////////

  //double lat = 40.996429; //ev
  //double longi = 28.843090; //ev
  double lat = 40.807473;
  double longi = 29.358800;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: map,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Araba',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'Yürüme',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Detay',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Katmanlar',
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions),
            label: 'Yol Tarifi',
            backgroundColor: Colors.grey,
          ),
        ],
        selectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    print( index );
    if( index == 4 )
    {
      Navigator.push( context, MaterialPageRoute(builder: (context) => App()), );
    }
    if( index == 0 )
    {
      print_all_graph();
    }
    if( index == 1 )
    {
      print( "--------------------------------------Closest Node: " + graph.closest_node( [ 40.808207, 29.362262 ] ).toString() );
    }
    if( index == 2 )
    {
      //lat 1 is end point
      double lat1 = 40.747353;
      double lng1 = 29.805506;
      //lat2 is start poinr
      double lat2 = 40.747800;
      double lng2 = 29.781023;


      double PI = math.pi;
      double dTeta = math.log(math.tan((lat2/2)+(PI/4))/math.tan((lat1/2)+(PI/4)));
      double dLon = (lng1-lng2).abs();
      double teta = math.atan2(dLon,dTeta);
      int direction = (teta * 57.2958).round();
      print( "Direction in degree: " + direction.toString() );
    }
  }

  void
  set_route_info( String start_point, String destination, String road_choice )
  async {
    int closest_node;
    print( start_point );
    print( destination );
    print( "end:::::::::::::::::::::::::::::::" + globals.locations[destination].toString() );
    print( "end:::::::::::::::::::::::::::::::" + globals.locations[start_point].toString() );

    listen_location.stop_wrapper();
    //if dest is current location return;
    if( globals.locations[destination] == -1 ) return;
    //if start point is current location
    if( globals.locations[start_point] == -1 )
    {
      await listen_location.wrapper();

      closest_node = graph.closest_node( current_locataion );
      draw_path( closest_node , globals.locations[destination], road_choice );
    }
    else
    {
      draw_path( globals.locations[start_point] , globals.locations[destination], road_choice );
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      globals.app_title = "Yol Tarifi";
    });

    listen_location = ListenLocation();
    listen_location.map = this;

    camera_position = CameraPosition(
    target: LatLng(40.808683, 29.360131), //okul
    //target: LatLng( 40.996429, 28.843090 ), //ev
    zoom: 14.4746,
    );

    set_campus_border();
    refresh_map();
  }

  void
  refresh_map()
  {
    setState(() {
      map = new GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: camera_position,
        polylines: _polylines,
        markers: _markers,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      );
    });
  }

  void set_campus_border() {
    campus_border.add(LatLng(40.808910, 29.365058));
    campus_border.add(LatLng(40.808497, 29.364973));
    campus_border.add(LatLng(40.808473, 29.365335));
    campus_border.add(LatLng(40.804743, 29.364465));
    campus_border.add(LatLng(40.803012, 29.359144));
    campus_border.add(LatLng(40.802857, 29.354981));
    campus_border.add(LatLng(40.805439, 29.353501));
    campus_border.add(LatLng(40.806003, 29.353549));
    campus_border.add(LatLng(40.806003, 29.353549));
    campus_border.add(LatLng(40.810780, 29.347807));
    campus_border.add(LatLng(40.811087, 29.347811));
    campus_border.add(LatLng(40.811238, 29.346893));
    campus_border.add(LatLng(40.811550, 29.346688));
    campus_border.add(LatLng(40.819053, 29.349012));
    campus_border.add(LatLng(40.818823, 29.350177));
    campus_border.add(LatLng(40.815587, 29.349287));
    campus_border.add(LatLng(40.814872, 29.353724));
    campus_border.add(LatLng(40.820008, 29.355904));
    campus_border.add(LatLng(40.819757, 29.357552));
    campus_border.add(LatLng(40.815280, 29.363064));
    campus_border.add(LatLng(40.813443, 29.363517));
    campus_border.add(LatLng(40.811180, 29.365890));
    campus_border.add(LatLng(40.809617, 29.365723));
    campus_border.add(LatLng(40.809658, 29.364999));
    campus_border.add(LatLng(40.808723, 29.364984));

    _polylines.add(
      Polyline(
        polylineId: PolylineId("campus_border"),
        points: campus_border,
        color: Colors.black,
        width: 3,
      ),
    );

    /*_markers.add( Marker(
      markerId: MarkerId('100'),
      position: LatLng( lat, longi ),
      //infoWindow: InfoWindow(title: 'Roça', snippet: 'Um bom lugar para estar'),
      //icon: Icon( Icons.my_location ).tojso;
    ));*/
  }

  void
  set_test_square()
  {
    test_square.add(LatLng(40.809758, 29.363434));
    test_square.add(LatLng(40.809776, 29.363260));
    test_square.add(LatLng(40.809652, 29.363238));
    test_square.add(LatLng(40.809632, 29.363418));
    test_square.add(LatLng(40.809758, 29.363437));
    _polylines.add(
      Polyline(
        polylineId: PolylineId("test_square"),
        points: test_square,
        color: Colors.red,
        width: 2,
      ),
    );
  }

  void
  print_all_graph()
  {
    print( "Belowwwwwwwww" );
    //graph.create_nodes();
    for( int i = 0; i < graph.size; i++ )
    {
      Node node = graph.graph[i];
      print( i );
      for( int j = 0; j < node.adjacents.length; j++ )
      {
        Node adj = graph.graph[ node.adjacents[j].node_num ];
        _polylines.add(
          Polyline(
            polylineId: PolylineId( i.toString() + "," + j.toString() ),
            points: [ LatLng( node.cordinate[0], node.cordinate[1]), LatLng( adj.cordinate[0], adj.cordinate[1]) ],
            color: Colors.red,
            width: 2,
          ),
        );
      }
    }
    refresh_map();
  }


  void draw_path( int start_node, int end_node, String road_choice ) /*List<List<double>> cordinates*/
  {
    List<List<double>> cordinates;


    //graph.create_nodes();
    cordinates = graph.get_cordinates( graph.shortest_path( start_node, end_node, road_choice ) );

    route_lines = List<LatLng>();
    for( int i = 0; i < cordinates.length; i++ )
    {
      route_lines.add(LatLng( cordinates[i][0] , cordinates[i][1] ));
    }

    _polylines.removeWhere((item) => item.polylineId.value == "route_lines" );
    _polylines.add(
      Polyline(
        polylineId: PolylineId("route_lines"),
        points: route_lines,
        color: Colors.red,
        width: 3,
      ),
    );

    refresh_map();
  }

  void
  set_location( LocationData loc )
  {


    lat = loc.latitude;
    longi = loc.longitude;


    current_locataion = [ lat, longi ];
    print( "CURRENT LOCCCCCCCCCCCCCCCCCCCCCCCCCCC::: " + current_locataion.toString() );


    _markers.clear();
    _markers.add( Marker(
      markerId: MarkerId('100'),
      position: LatLng( lat, longi ),
      //icon: Icon( Icons.my_location ),
    ) );

    refresh_map();
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

}







































/*
  void _setPolygons() {
    List<LatLng> polygonLatLongs = List<LatLng>();
    polygonLatLongs.add(LatLng(40.808910, 29.365058));
    polygonLatLongs.add(LatLng(40.808497, 29.364973));
    polygonLatLongs.add(LatLng(40.808473, 29.365335));
    polygonLatLongs.add(LatLng(40.804743, 29.364465));

    _polygons.add(
      Polygon(
        polygonId: PolygonId("0"),
        points: polygonLatLongs,
        fillColor: Colors.white,
        strokeWidth: 1,
      ),
    );
  }
*/