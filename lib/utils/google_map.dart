// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ree_gig/project_constants.dart';

var latitude = 31.673902811310086, longitude = 74.2793919146061;

class GoogleMapService extends StatefulWidget {
  @override
  _GoogleMapServiceState createState() => _GoogleMapServiceState();
}

class _GoogleMapServiceState extends State<GoogleMapService> {
  Completer<GoogleMapController> _mapController = Completer();
  String _currentAddress = 'Get Location';

  bool _isLoading = false;
  bool _isVisible = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.0,
  );

  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: 'The title of marker')),
  ];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    setState(() {
      _isLoading = true;
    });
    print('Wait we are getting your location');
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Fluttertoast.showToast(
        msg: 'Please turn on your Location', // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        backgroundColor: Colors.red,
      );
      setState(() {
        _isLoading = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Fluttertoast.showToast(
          msg: 'Location permissions are denied', // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM, // location
          backgroundColor: Colors.grey,
        );
        setState(() {
          _isLoading = false;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() {
        _isLoading = false;
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('---------------------------------');
    print('position $position');
    setState(() {
      //Pass the lat and long to the function
      _getAddressFromLatLng(position.latitude, position.longitude);
    });
    return position;
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latitude, longitude,
          localeIdentifier: "en");

      Placemark place = p[0];

      setState(() {
//        _currentAddress = "${place.locality}";
        _currentAddress =
            "${place.subLocality}, ${place.locality}, ${place.country}";
        print('_currentAddress $_currentAddress');
        mapLocation = _currentAddress;
        _isLoading = false;
        _isVisible = true;
      });
    } catch (e) {
      print(e);
      print('Faild to get Address');
      Fluttertoast.showToast(
        msg: 'Faild to get Location Try again', // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        backgroundColor: Colors.grey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onTap: (value) async {
          print('----------------------------------');
          print(value);
          print('----------------------------------');
          _isVisible = true;
          _markers.add(Marker(
            markerId: const MarkerId('1'),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ));
          CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude), zoom: 14.0);

          final GoogleMapController controller = await _mapController.future;

          setState(() {
            latitude = value.latitude;
            longitude = value.longitude;
            _getAddressFromLatLng(latitude, longitude);
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          });
        },
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        zoomControlsEnabled: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: _isVisible,
            child: Card(
              child: ListTile(
//                  leading: Icon(Icons.arrow_back),
                  title: Text(_currentAddress,
                      style: const TextStyle(color: Colors.blue)),
                  trailing: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(color: lightPurple),
                      ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: Material(
              color: whiteColor,
              elevation: 3.0,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                minWidth: 200.0,
                height: 50.0,
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircularProgressIndicator(
                              color: blackColor, strokeWidth: 2.0),
                          const Text('Getting Location...'),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Icon(Icons.location_on),
                          Text('Get Current Location'),
                        ],
                      ),
                onPressed: () {
                  _determinePosition().then((value) async {
                    print('my current location');
                    print('${value.latitude} ${value.longitude}');
                    print('-------------------------');
                    _markers.add(Marker(
                      markerId: const MarkerId('1'),
                      position: LatLng(value.latitude, value.longitude),
                      infoWindow: const InfoWindow(title: 'My new Location'),
                    ));
                    CameraPosition cameraPosition = CameraPosition(
                        target: LatLng(value.latitude, value.longitude),
                        zoom: 14.0);

                    final GoogleMapController controller =
                        await _mapController.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition));
                    latitude = value.latitude;
                    longitude = value.longitude;
                    setState(() {});
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
