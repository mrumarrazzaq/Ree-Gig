import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';

class FreelancersReviews extends StatefulWidget {
  FreelancersReviews({Key? key, required this.email}) : super(key: key);

  String email;
  @override
  _FreelancersReviewsState createState() => _FreelancersReviewsState();
}

class _FreelancersReviewsState extends State<FreelancersReviews> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _reviewController = TextEditingController();
  int _reviewStars = 0;
  bool _isLoading = false;
  List<IconData> starIcon = [
    Icons.star_border,
    Icons.star_border,
    Icons.star_border,
    Icons.star_border,
    Icons.star_border,
  ];
  List<Color> starIconColor = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
  ];
  List<bool> _set = [
    true,
    true,
    true,
    true,
    true,
  ];
  String _time = '0:00 AM';
  setStars(int stars) {
    for (int i = 0; i <= stars; i++) {
      starIcon[i] = Icons.star;
      starIconColor[i] = Colors.yellow;
    }
  }

  resetStars(int stars) {
    for (int i = stars; i < 5; i++) {
      starIcon[i] = Icons.star_border;
      starIconColor[i] = Colors.black;
    }
  }

  saveReview() async {
    final json = {
      'Person Name': personName,
      'Profile Image Url': imageURL,
      'Review Text': _reviewController.text,
      'Stars': _reviewStars,
      'Created At': currentDateTime,
      'Time': _time,
    };
    await FirebaseFirestore.instance
        .collection('Reviews ${widget.email}')
        .doc('$currentUserEmail')
        .set(json);
    print('Review Save Successfully');
  }

  String personName = '';
  String imageURL = '';
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
        personName = ds['personName'];
        imageURL = ds['imageUrl'];
      });
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    fetch();
    _time = formatTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('------------------------------');
    print(_time);
    return Scaffold(
        body: Stack(
//      shrinkWrap: true,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
                color: darkPurple,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
          ),
        ),
        Positioned.fill(
          top: 2,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Reviews ${widget.email}')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: lightPurple,
                            strokeWidth: 2.0,
                          ));
                        }
                        final List storeReviews = [];

                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map id = document.data() as Map<String, dynamic>;
                          storeReviews.add(id);
//                  print('==============================================');
//                  print(storeRequests);
//                  print('Document id : ${document.id}');
                          id['id'] = document.id;
                        }).toList();
                        return Column(
                          children: [
                            storeReviews.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 30.0),
                                    child: Text(
                                      'No Reviews yet',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container(),
                            for (int i = 0; i < storeReviews.length; i++) ...[
                              CustomReviews(
                                title: storeReviews[i]['Person Name'],
                                description: storeReviews[i]['Review Text'],
                                imagePath: storeReviews[i]['Profile Image Url'],
                                starSize: 18,
                                starValue: storeReviews[i]['Stars'],
                              ),
                            ],
                          ],
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
        widget.email == currentUserEmail
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 120.0, vertical: 10.0),
                  child: Material(
                    color: lightPurple,
                    elevation: 3.0,
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      minWidth: 200.0,
                      height: 50.0,
                      splashColor: whiteColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.edit, color: whiteColor),
                          Text('Write Review',
                              style: TextStyle(color: whiteColor)),
                        ],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                content: SizedBox(
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              splashColor: Colors.yellow
                                                  .withOpacity(0.4),
                                              onPressed: () {
                                                setState(() {
                                                  if (_set[0]) {
                                                    setStars(0);
                                                    _reviewStars = 1;
                                                    _set[0] = false;
                                                    print('1 set');
                                                  } else {
                                                    resetStars(1);
                                                    _set[0] = true;
                                                    print('4 reset');
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                starIcon[0],
                                                color: starIconColor[0],
                                              )),
                                          IconButton(
                                              splashColor: Colors.yellow
                                                  .withOpacity(0.4),
                                              onPressed: () {
                                                setState(() {
                                                  if (_set[1]) {
                                                    setStars(1);
                                                    _reviewStars = 2;
                                                    _set[1] = false;
                                                    print('2 set');
                                                  } else {
                                                    resetStars(2);
                                                    _set[1] = true;
                                                    print('3 reset');
                                                  }
                                                });
                                              },
                                              icon: Icon(starIcon[1],
                                                  color: starIconColor[1])),
                                          IconButton(
                                              splashColor: Colors.yellow
                                                  .withOpacity(0.4),
                                              onPressed: () {
                                                setState(() {
                                                  if (_set[2]) {
                                                    setStars(2);
                                                    _reviewStars = 3;
                                                    _set[2] = false;
                                                    print('3 set');
                                                  } else {
                                                    resetStars(3);
                                                    _set[2] = true;
                                                    print('2 reset');
                                                  }
                                                });
                                              },
                                              icon: Icon(starIcon[2],
                                                  color: starIconColor[2])),
                                          IconButton(
                                              splashColor: Colors.yellow
                                                  .withOpacity(0.4),
                                              onPressed: () {
                                                setState(() {
                                                  if (_set[3]) {
                                                    setStars(3);
                                                    _reviewStars = 4;
                                                    _set[3] = false;
                                                    print('4 set');
                                                  } else {
                                                    resetStars(4);
                                                    _set[3] = true;
                                                    print('1 reset');
                                                  }
                                                });
                                              },
                                              icon: Icon(starIcon[3],
                                                  color: starIconColor[3])),
                                          IconButton(
                                              splashColor: Colors.yellow
                                                  .withOpacity(0.4),
                                              onPressed: () {
                                                setState(() {
                                                  setStars(4);
                                                  _reviewStars = 5;
//                                                  _set[0] = false;
//                                                  _set[1] = false;
//                                                  _set[2] = false;
//                                                  _set[3] = false;
                                                  print('5 set');
                                                });
                                              },
                                              icon: Icon(starIcon[4],
                                                  color: starIconColor[4])),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            cursorColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              isDense: true,
//                                            fillColor: lightPurple,
//                                            filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              hintText: 'Write Review',
                                              hintStyle:
                                                  TextStyle(color: lightPurple),
//                        labelText: 'Password',
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: lightPurple,
                                                    width: 1.5),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: lightPurple,
                                                    width: 1.5),
                                              ),
//                        labelStyle: TextStyle(color: defaultUIColor),

                                              prefixText: '  ',
                                            ),
                                            controller: _reviewController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please write review';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                resetStars(0);
                                                _reviewStars = 0;
                                                _reviewController.clear();
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                          TextButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  print(_reviewStars);
                                                  print(_reviewController.text);
                                                  _isLoading = true;
                                                });
                                                await saveReview();
                                                _isLoading = false;
                                                resetStars(0);
                                                _reviewStars = 0;
                                                _reviewController.clear();
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: _isLoading
                                                ? SizedBox(
                                                    width: 10,
                                                    height: 10,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: lightPurple,
                                                            strokeWidth: 1.0))
                                                : const Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                          ),
                                        ],
                                      ),
//                                      SizedBox(
//                                        width:10,
//                                          height:10,
//                                          child: CircularProgressIndicator(color: lightPurple,strokeWidth: 1.0)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
      ],
    ));
  }
}
