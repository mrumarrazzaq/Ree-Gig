//// ignore_for_file: prefer_const_constructors
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:geocoding/geocoding.dart';
//import 'package:geolocator/geolocator.dart';
////import 'package:velocity_x/velocity_x.dart';
//
//class GetGeoLocation extends StatefulWidget {
//  const GetGeoLocation({Key? key}) : super(key: key);
//
//  @override
//  _GetGeoLocationState createState() => _GetGeoLocationState();
//}
//
//class _GetGeoLocationState extends State<GetGeoLocation> {
//  void initState() {
//    super.initState();
////    fetch();
//  }
//
//  final TextEditingController addressController = TextEditingController();
////  fetch() async {
////    final user = FirebaseAuth.instance.currentUser;
////    print(user!.uid);
////
////    try {
////      await FirebaseFirestore.instance
////          .collection('Users')
////          .doc(user.uid)
////          .get()
////          .then((ds) {
////        address = ds['Address'];
////        print(address);
////      });
////      setState(() {});
////    } catch (e) {
////      print(e.toString());
////    }
////  }
//
//  String address = '';
//  Position? _position;
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//        padding: MediaQuery.of(context).viewInsets,
//        child: Container(
//            child: Wrap(
//          children: <Widget>[
//            Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                  GestureDetector(
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                      child: Icon(
//                        Icons.arrow_back_ios,
//                        size: 25,
//                      )),
//                  Text("Address"),
//                  GestureDetector(
//                    onTap: () async {
//                      if (addressController.text.isNotEmpty) {
////                          update();
//                      }
//                    },
//                    child: Text("Done"),
//                  ),
//                ],
//              ),
//            ),
//            Text(" "),
//            Padding(
//              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
//              child: TextFormField(
//                controller: addressController,
//                validator: (value) {
//                  if (value!.isEmpty) {
//                    return "*required";
//                  }
//                },
//                obscureText: false,
//                decoration: InputDecoration(
//                    hintText: address,
//                    labelStyle: TextStyle(color: Colors.black),
//                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                    border: OutlineInputBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                      borderSide: BorderSide(color: Colors.black, width: 0.5),
//                    ),
//                    focusedBorder: OutlineInputBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                      borderSide: BorderSide(color: Colors.black, width: 2.0),
//                    )),
//              ),
//            ),
//            Text("  "),
//            ElevatedButton(
//              onPressed: () {
//                getLocation();
//              },
//              child: Text("Get Current Location"),
//            ),
//            Text("  "),
//          ],
//        )));
//  }
//
//  getLocation() async {
//    _position = await _determinePosition();
//    print(_position!.latitude);
//    print(_position!.longitude);
//    getAddress();
//  }
//
//  getAddress() async {
//    List<Placemark> placemarks = await placemarkFromCoordinates(
//        _position!.latitude, _position!.longitude);
//    setState(() {
//      addressController.text =
//          "${placemarks[0].subLocality}, ${placemarks[0].street}, "
//          "${placemarks[0].country}";
//    });
//  }
//
//  Future<Position?> _determinePosition() async {
//    bool serviceEnabled;
//    LocationPermission permission;
//
//    // Test if location services are enabled.
//    serviceEnabled = await Geolocator.isLocationServiceEnabled();
//    if (!serviceEnabled) {
//      // Location services are not enabled don't continue
//      // accessing the position and request users of the
//      // App to enable the location services.
//      return Future.error('Location services are disabled.');
//    }
//
//    permission = await Geolocator.checkPermission();
//    if (permission == LocationPermission.denied) {
//      permission = await Geolocator.requestPermission();
//      if (permission == LocationPermission.denied) {
//        // Permissions are denied, next time you could try
//        // requesting permissions again (this is also where
//        // Android's shouldShowRequestPermissionRationale
//        // returned true. According to Android guidelines
//        // your App should show an explanatory UI now.
//        return Future.error('Location permissions are denied');
//      }
//    }
//
//    if (permission == LocationPermission.deniedForever) {
//      // Permissions are denied forever, handle appropriately.
//      return Future.error(
//          'Location permissions are permanently denied, we cannot request permissions.');
//    }
//
//    // When we reach here, permissions are granted and we can
//    // continue accessing the position of the device.
//    return await Geolocator.getCurrentPosition(
//        desiredAccuracy: LocationAccuracy.high);
//  }
//
////  update() async {
////    dynamic close =
////        context.showLoading(msg: "Loading", textColor: Colors.white);
////    final user = FirebaseAuth.instance.currentUser;
////
////    try {
////      await FirebaseFirestore.instance
////          .collection('Users')
////          .doc(user!.uid)
////          .update({
////        'Address': addressController.text,
////      });
////    } catch (e) {
////      print(e.toString());
////    }
////    await Future.delayed(1.milliseconds, close);
////    Navigator.pop(context);
////  }
//}
