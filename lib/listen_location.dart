import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'Map_page.dart';


class ListenLocation {
  final Location location = Location();
  MapSampleState map;

  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;

  void wrapper() async{
    await _listenLocation();
  }

  void stop_wrapper() async{
    await _stopListen();
  }

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
        _error = err.code;

      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {

        _error = null;
        map.set_location( currentLocation );
        _location = currentLocation;

    });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }

  void
  foo(){}

}










