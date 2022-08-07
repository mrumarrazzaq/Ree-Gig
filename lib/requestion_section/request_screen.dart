// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/utils/google_map.dart';

import 'request_category_selection.dart';
import 'request_subCateogory_selection.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _currentLocationController =
      TextEditingController();

  List<bool> isVisible = [true, false, false];
  int selectedValue = 0;
  bool _isLoading = false;
  bool _isSubCategoryVisible = false;
  bool _isUpLoading = false;
  bool _isLocationGetting = false;
  String imagePath = '';
  String _personName = '';
  String _profileImageURL = '';
  var imageUrl;
  String _currentLocation = 'Get Current Location';
  String _customLocation = 'Get Custom Location';
  File? image;
  String _uniqueId = '';

  List<String> categoriesList = [
    'Admin',
    'Finance & Account',
    'Art & Crafts',
    'Freelance',
    'Education',
    'Cleaning Service',
    'Food & Beverages',
    'Construction',
    'House Related',
    'Business',
    'IT',
    'Events',
    'Recruitment',
    'Logistics',
    'Fashion',
    'Others'
  ];
  categoriesStreams() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Categories')
            .orderBy('priority', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: lightPurple,
              strokeWidth: 2.0,
            ));
          }
          if (snapshot.hasData) {
            final List storeCategories = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map id = document.data() as Map<String, dynamic>;
              storeCategories.add(id);
              id['id'] = document.id;
            }).toList();
            return Container();
            //   Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     storeCategories.isEmpty
            //         ? const Text('No Category Find')
            //         : Container(),
            //     for (int i = 0;
            //     i < storeCategories.length;
            //     i++) ...[
            //       categoriesList.add(storeCategories[i]['Category Name'])
            //       // Text(storeCategories[i]['Category Name']),
            //
            //       // DropdownButton(
            //       //   icon: Icon(
            //       //     Icons.keyboard_arrow_down,
            //       //     color: lightPurple,
            //       //   ),
            //       //   iconSize: 32,
            //       //   elevation: 4,
            //       //   underline: Container(
            //       //     height: 0.0,
            //       //   ),
            //       //   items: categoriesList.map<DropdownMenuItem<String>>(
            //       //     (String value) {
            //       //       return DropdownMenuItem<String>(
            //       //         value: value.toString(),
            //       //         child: Text(value.toString()),
            //       //       );
            //       //     },
            //       //   ).toList(),
            //       //   onChanged: (String? newValue) {
            //       //     setState(() {
            //       //       _selectedCategory = newValue!;
            //       //       print(newValue);
            //       //     });
            //       //   },
            //       // ),
            //     ],
            //   ],
            // );
          }
          return Center(
              child: CircularProgressIndicator(
            color: lightPurple,
            strokeWidth: 2.0,
          ));
        });
  }

  assignId() async {
    _uniqueId = await generateUniqueId();
    print('_uniqueId : $_uniqueId');
  }

  Future pickImage() async {
    try {
      final galleryImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (galleryImage == null) return;

      final imageTemporary = File(galleryImage.path);
      setState(() {
        this.image = imageTemporary;
      });
      imagePath = galleryImage.path;

      print('------------------------------------');
      print('Image path : $imagePath');
      // ignore: unused_catch_clause
    } catch (e) {
      print('Pick image from gallery fail');
    }
  }

  uploadImage(String path) async {
    print('Image is Uploading...');

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(
        "Request Images/$currentUserId -- $_uniqueId ${_titleController.text} ${_descriptionController.text}");
    UploadTask uploadTask = ref.putFile(File(path));
    await uploadTask.whenComplete(() async {
      String url = await ref.getDownloadURL();
      print('----------------------------------');
      print('Image URL : $url');
      print('----------------------------------');
      imageUrl = url;
      _isUpLoading = false;
      setState(() {});
    }).catchError((onError) {
      print('---------------------------------------');
      print('Error while uploading image');
      print(onError);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    setState(() {
      _isLocationGetting = true;
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
        _isLocationGetting = false;
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
        setState(() {
          _isLocationGetting = false;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() {
        _isLocationGetting = false;
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('---------------------------------');
    print('position : $position');
    print('---------------------------------');
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
        _currentLocation =
            "${place.subLocality}, ${place.locality}, ${place.country}";
        print('Current Address : $_currentLocation');
        _isLocationGetting = false;
      });
    } catch (e) {
      print(e);
      print('Failed to get Address');
      Fluttertoast.showToast(
        msg: 'Failed to get Location Try again', // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        backgroundColor: Colors.grey,
      );
    }
  }

  Future<void> addRequest(String location) {
    return FirebaseFirestore.instance
        .collection('Requests')
        .add({
          'Created AT': DateTime.now(),
          'User Email': currentUserEmail.toString(),
          'User Name': _personName,
          'Profile Image URL': _profileImageURL,
          'Request Title': _titleController.text,
          'Request Description': _descriptionController.text,
          'Selected Category': selectedCategory,
          'Selected SubCategory': selectedSubCategory,
          'Current Address': location,
          'Request Image URL': imageUrl.toString(),
        })
        .then(
            (value) => print('Request Added Successfully : $currentUserEmail'))
        .catchError((error) => print('Failed to Add Request $error'));
  }

  Future<void> addCurrentUserRequest(String location) {
    return FirebaseFirestore.instance
        .collection('$currentUserEmail Requests')
        .add({
          'Created AT': DateTime.now(),
          'User Email': currentUserEmail.toString(),
          'User Name': _personName,
          'Profile Image URL': _profileImageURL,
          'Request Title': _titleController.text,
          'Request Description': _descriptionController.text,
          'Selected Category': selectedCategory,
          'Selected SubCategory': selectedSubCategory,
          'Current Address': location,
          'Request Image URL': imageUrl.toString(),
        })
        .then(
            (value) => print('Request Added Successfully : $currentUserEmail'))
        .catchError((error) => print('Failed to Add Request $error'));
  }

  fetch() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user!.email);
    print('-------------------------------------');
    print('Current user data is fetching');
    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.email)
          .get()
          .then((ds) {
        _personName = ds['personName'];
        _profileImageURL = ds['imageUrl'];
      });
      print(_personName);
      print(_profileImageURL);
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    fetch();
    assignId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'REE ', style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(
                  text: 'GIG', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8.0),
            Text('Fill in your request',
                style: TextStyle(color: lightPurple, fontSize: 25)),
            const SizedBox(height: 5),
            Container(
              color: lightPurple,
              height: 5,
              width: 180,
            ),
            const SizedBox(height: 8.0),
            image != null
                ? ClipOval(
                    child: Image.file(
                      image!,
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: lightPurple.withOpacity(0.4),
                    radius: 50.0),
            _isUpLoading == true
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: 150,
                            height: 95,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12.0),
                            )),
                      ),
                      Positioned.fill(
                        top: -10,
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: lightPurple,
                            backgroundColor: whiteColor,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 58,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Uploading Image',
                              style: TextStyle(color: whiteColor)),
                        ),
                      ),
                    ],
                  )
                : Container(),
            MyInputField(
              icon: Icons.title,
              hint: 'Enter Title',
              controller: _titleController,
              maxLenght: 30,
            ),
            MyInputField(
              icon: Icons.description,
              hint: 'Enter Description',
              controller: _descriptionController,
              maxLenght: 200,
            ),
            MyInputField(
                icon: Icons.category,
                hint: selectedCategory,
                widget: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: lightPurple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestCategorySelection(),
                      ),
                    );
                  },
                )

                // DropdownButton(
                //   icon: Icon(
                //     Icons.keyboard_arrow_down,
                //     color: lightPurple,
                //   ),
                //   iconSize: 32,
                //   elevation: 4,
                //   underline: Container(
                //     height: 0.0,
                //   ),
                //   items: categoriesList.map<DropdownMenuItem<String>>(
                //     (String value) {
                //       return DropdownMenuItem<String>(
                //         value: value.toString(),
                //         child: Text(value.toString()),
                //       );
                //     },
                //   ).toList(),
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _selectedCategory = newValue!;
                //       print(newValue);
                //     });
                //   },
                // ),
                ),
            Visibility(
              visible: selectedCategory == "Select Category" ? false : true,
              child: MyInputField(
                  icon: Icons.category,
                  hint: selectedSubCategory,
                  widget: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: lightPurple,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestSubCategorySelection(
                            category: selectedCategory,
                          ),
                        ),
                      );
                    },
                  )),
            ),
            RadioListTile<int>(
              value: 0,
              dense: true,
              title: const Text('Get Current Location'),
              secondary: const Text(''),
              groupValue: selectedValue,
              activeColor: lightPurple,
              onChanged: (value) {
                setState(() {
                  selectedValue = 0;
                  isVisible[0] = true;
                  isVisible[1] = false;
                  isVisible[2] = false;
                  _customLocation = 'Get Custom Location';
                  mapLocation = 'Get Map Location';
                  _currentLocationController.clear();
                });
              },
            ),
            Visibility(
              visible: isVisible[0],
              child: ListTile(
                dense: true,
                iconColor: _currentLocation == 'Get Current Location'
                    ? Colors.grey
                    : Colors.green,
                leading: IconButton(
                    onPressed: () async {
                      await _determinePosition();
                    },
                    icon: const Icon(
                      Icons.location_on,
                      size: 30,
                    )),
                title: Text(_currentLocation),
                trailing: _isLocationGetting
                    ? SizedBox(
                        height: 15.0,
                        width: 15.0,
                        child: CircularProgressIndicator(
                            color: lightPurple, strokeWidth: 1.5),
                      )
                    : const SizedBox(height: 0, width: 0),
              ),
            ),
            RadioListTile<int>(
              value: 1,
              dense: true,
              title: const Text('Get Location by Map'),
              secondary: const Text(''),
              groupValue: selectedValue,
              activeColor: lightPurple,
              onChanged: (value) {
                setState(() {
                  selectedValue = 1;
                  isVisible[0] = false;
                  isVisible[1] = true;
                  isVisible[2] = false;
                  _currentLocation = 'Get Current Location';
                  _customLocation = 'Get Custom Location';
                  _currentLocationController.clear();
                });
              },
            ),
            Visibility(
              visible: isVisible[1],
              child: MaterialButton(
                color: lightPurple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleMapService(),
                    ),
                  );
                },
                child: Text('Open Google Map',
                    style: TextStyle(color: whiteColor)),
              ),
            ),
            RadioListTile<int>(
              value: 2,
              dense: true,
              title: const Text('Custom Location'),
              secondary: const Text(''),
              groupValue: selectedValue,
              activeColor: lightPurple,
              onChanged: (value) {
                setState(() {
                  selectedValue = 2;
                  isVisible[0] = false;
                  isVisible[1] = false;
                  isVisible[2] = true;
                  _currentLocation = 'Get Current Location';
                  mapLocation = 'Get Map Location';
                });
              },
            ),
            Visibility(
              visible: isVisible[2],
              child: MyInputField(
                icon: Icons.location_on,
                hint: 'Enter Location',
                controller: _currentLocationController,
                maxLenght: 40,
              ),
            ),
            const SizedBox(height: 8),
            Stack(
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: [
                Container(
                  height: 150.0,
                  width: MediaQuery.of(context).size.width - 40,
                  child: const Text('Upload your images \n ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  decoration: BoxDecoration(
                    border: Border.all(color: lightPurple),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    minWidth: 250,
                    clipBehavior: Clip.antiAlias,
                    onPressed: () {
                      pickImage();
                    },
                    child: Container(
                      height: 100.0,
                      width: 250,
                      child: Column(
                        children: [
                          Icon(Icons.cloud_upload, color: whiteColor, size: 50),
                          Text('Brose to choose file',
                              style: TextStyle(color: whiteColor)),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: lightPurple),
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: MaterialButton(
        color: lightPurple,
        height: 50.0,
        child: _isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      color: whiteColor,
                      strokeWidth: 2.0,
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    'Please Wait...',
                    style: TextStyle(
                      color: whiteColor,
                    ),
                  ),
                ],
              )
            : Text('Submit',
                textAlign: TextAlign.center,
                style: TextStyle(color: whiteColor)),
        onPressed: () {
          print(_currentLocation);
          print(mapLocation);
          if (_currentLocationController.text.isNotEmpty) {
            setState(() {
              _customLocation = _currentLocationController.text;
            });
          }
          print(_customLocation);

          _validateData();
        },
      ),
    );
  }

  _validateData() async {
    setState(() {
      _isLoading = true;
    });
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        image != null &&
        selectedCategory != 'Select Category' &&
        selectedSubCategory != 'Select SubCategory' &&
        (_currentLocation != 'Get Current Location' ||
            _customLocation != 'Get Custom Location' ||
            mapLocation != 'Get Map Location')) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      print('======================================');
      print('_currentLocation :  $_currentLocation');
      print('_customLocation  :  $_customLocation');
      print('mapLocation      :  $mapLocation');
      setState(() {
        _isUpLoading = true;
      });
      await uploadImage(imagePath);
//      if (_isUpLoading == false) {
      if (_currentLocation != 'Get Current Location') {
        print('======================================');
        print('Current Location is set');
        print(_currentLocation);
        await addRequest(_currentLocation);
        await addCurrentUserRequest(_currentLocation);
      }
      if (_customLocation != 'Get Custom Location') {
        print('======================================');
        print('Custom Location is set');
        print(_customLocation);
        await addRequest(_customLocation);
        await addCurrentUserRequest(_customLocation);
      }
      if (mapLocation != 'Get Map Location') {
        print('======================================');
        print('Map Location is set');
        print(mapLocation);
        await addRequest(mapLocation);
        await addCurrentUserRequest(mapLocation);
      }
      setState(() {
        _currentLocation = 'Get Current Location';
        _customLocation = 'Get Custom Location';
        mapLocation = 'Get Map Location';
      });
      await Fluttertoast.showToast(
        msg: 'Request submitted Successfully', // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        backgroundColor: Colors.green,
      );

      Navigator.pop(context);

      setState(() {
        _isLoading = false;
      });
//      }
    } else {
      // ignore: deprecated_member_use
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: ErrorMassage(errorMassage: 'All fields are required'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class ErrorMassage extends StatelessWidget {
  ErrorMassage({Key? key, required this.errorMassage}) : super(key: key);

  String errorMassage;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.warning_amber_outlined,
          color: Colors.white,
        ),
        Text(
          '   $errorMassage',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class MyInputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final IconData? icon;
  int? maxLenght = 10;
  MyInputField({
    required this.hint,
    this.controller,
    this.widget,
    this.icon,
    this.maxLenght,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.only(
          top: 10.0, left: 20.0, right: 20.0, bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: lightPurple, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: widget == null ? false : true,
              autofocus: false,
              keyboardType: TextInputType.text,
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxLenght),
              ],
              controller: controller,
              decoration: InputDecoration(
                  hintText: hint,
//                  isDense: true,
                  hintStyle: TextStyle(fontSize: 15, color: lightPurple),
                  prefixIcon: Icon(icon, color: lightPurple),
//                    prefixText: '',
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  )),
            ),
          ),
          widget == null
              ? Container()
              : Container(
                  child: widget,
                ),
        ],
      ),
    );
  }
}
