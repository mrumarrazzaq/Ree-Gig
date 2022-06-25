import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/chat_screen.dart';
import 'package:ree_gig/freelancer_reviews.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';

class FreelancerProfileScreen extends StatefulWidget {
  FreelancerProfileScreen({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userProfileUrl,
    required this.requestCategory,
  }) : super(key: key);
  String userName;
  String userEmail;
  String userProfileUrl;
  String requestCategory;
  @override
  _FreelancerProfileScreenState createState() =>
      _FreelancerProfileScreenState();
}

class _FreelancerProfileScreenState extends State<FreelancerProfileScreen> {
  bool _isFollowButtonPressed = false;

  int intFollowers = 0;
  String stringFollowers = '10';
  int intFollowings = 0;
  String stringFollowings = '37';
  void generateRandom() {
    setState(() {
      intFollowers = Random().nextInt(200) + 1;
      intFollowings = Random().nextInt(600) + 1;
      stringFollowers = intFollowers.toString();
      stringFollowings = intFollowings.toString();
    });
  }

  String _profileImage = '';

  saveFavourite() async {
    await FirebaseFirestore.instance
        .collection('$currentUserEmail Favourite')
        .add({
      'userName': widget.userName,
      'userEmail': widget.userEmail,
      'requestCategory': widget.requestCategory,
      'userProfileUrl': widget.userProfileUrl,
    });
    await Fluttertoast.showToast(
      msg: 'Added to Favourite Successfully', // message
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.BOTTOM, // location
      backgroundColor: Colors.green,
    );
  }

  fetch() async {
    print('-------------------------------------');
    print('Current user data is fetching');
    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(widget.userEmail)
          .get()
          .then((ds) {
        _profileImage = ds['imageUrl'];
      });
      print('£££££££££££££££££££££££££££££');
      print(_profileImage);
      setState(() {
        _profileImage = _profileImage;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    fetch();
    generateRandom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              text: '', // default text style
              children: <TextSpan>[
                TextSpan(
                    text: 'REE ',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text: 'GIG', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            // currentUserEmail.toString() == widget.userEmail
            //     ? Container()
            //     : IconButton(
            //         onPressed: () {
            //           showMenu(
            //             context: context,
            //             position: const RelativeRect.fromLTRB(100, 0, 0, 100),
            //             items: [
            //               PopupMenuItem<String>(
            //                 child: GestureDetector(
            //                   child: const Text('Start Chat'),
            //                   onTap: () {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) => ChatScreen(
            //                           name: widget.userName,
            //                           receiverEmail: widget.userEmail,
            //                           imagePath: _profileImage,
            //                           isChartHistorySave: true,
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 ),
            //                 value: '',
            //               ),
            //               PopupMenuItem<String>(
            //                 child: const Text('Add to Favorite'),
            //                 value: '',
            //                 onTap: () async {
            //                   await saveFavourite();
            //                 },
            //               ),
            //             ],
            //             elevation: 8.0,
            //           );
            //         },
            //         icon: Icon(Icons.more_vert, color: whiteColor, size: 20),
            //       ),
            // currentUserEmail.toString() == widget.userEmail
            //     ? Container()
            //     : IconButton(
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => ChatScreen(
            //                 name: widget.userName,
            //                 receiverEmail: widget.userEmail,
            //                 imagePath: _profileImage,
            //                 isChartHistorySave: true,
            //               ),
            //             ),
            //           );
            //         },
            //         icon: const Icon(Icons.wechat_outlined)),
            // currentUserEmail.toString() == widget.userEmail
            //     ? Container()
            //     : IconButton(
            //         onPressed: () async {
            //           await saveFavourite();
            //         },
            //         icon: const Icon(Icons.star)),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(180.0, 180.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      right: 50.0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            currentUserEmail.toString() == widget.userEmail
                                ? Container()
                                : IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            name: widget.userName,
                                            receiverEmail: widget.userEmail,
                                            imagePath: _profileImage,
                                            isChartHistorySave: true,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.wechat_outlined,
                                      color: whiteColor,
                                      size: 40,
                                    )),
                            currentUserEmail.toString() == widget.userEmail
                                ? Container()
                                : IconButton(
                                    onPressed: () async {
                                      await saveFavourite();
                                    },
                                    icon: Icon(
                                      Icons.star,
                                      color: whiteColor,
                                      size: 40,
                                    )),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (currentUserEmail.toString() ==
                                widget.userEmail) {
                              print(
                                  '$currentUserEmail is now login you cannot send massage to itself');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    name: widget.userName,
                                    receiverEmail: widget.userEmail,
                                    imagePath: _profileImage,
                                    isChartHistorySave: true,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: _profileImage == ''
                                ? CircleAvatar(
                                    foregroundImage: const AssetImage(
                                      'icons/default_profile.png',
                                    ),
                                    backgroundColor: lightPurple,
                                    radius: 30,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(_profileImage),
                                    backgroundColor:
                                        lightPurple.withOpacity(0.5),
                                    radius: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    color: whiteColor,
                                  ), // default text style
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${widget.userEmail} \n',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis)),
                                    TextSpan(
                                        text: '$stringFollowers Follwers\n',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic)),
                                    TextSpan(
                                        text: '$stringFollowings Following',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              ),
                              currentUserEmail.toString() == widget.userEmail
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Material(
                                        color: _isFollowButtonPressed
                                            ? Colors.black
                                            : lightPurple,
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 2.0,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: MaterialButton(
                                          minWidth: 150.0,
                                          height: 25.0,
                                          elevation: 2.0,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          onPressed: () {
                                            setState(() {
                                              _isFollowButtonPressed =
                                                  !_isFollowButtonPressed;
                                              if (_isFollowButtonPressed ==
                                                  true) {
                                                print(stringFollowers);
                                                int foll =
                                                    int.parse(stringFollowers);

                                                setState(() {
                                                  foll = foll + 1;
                                                  stringFollowers =
                                                      foll.toString();
                                                });
                                                print(stringFollowers);
                                              } else if (_isFollowButtonPressed ==
                                                  false) {
                                                print(stringFollowers);
                                                int foll =
                                                    int.parse(stringFollowers);

                                                setState(() {
                                                  foll = foll - 1;
                                                  stringFollowers =
                                                      foll.toString();
                                                });
                                                print(stringFollowers);
                                              }
                                            });
                                          },
                                          child: Text(
                                            _isFollowButtonPressed
                                                ? 'UnFollow'
                                                : 'Follow',
                                            style: TextStyle(
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TabBar(
                  indicatorColor: whiteColor,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 5.0, color: whiteColor),
                      insets: const EdgeInsets.symmetric(horizontal: 20.0)),
                  tabs: const [
                    Tab(text: 'Request'),
                    Tab(text: 'Aids'),
                    Tab(text: 'Reviews'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
//            //Requests
            OtherFreelancersRequestsAndAids(
                userEmail: widget.userEmail,
                requestCategory: widget.requestCategory),
            //Aids
            OtherFreelancersRequestsAndAids(
                userEmail: widget.userEmail,
                requestCategory: widget.requestCategory),
            //Reviews
            FreelancersReviews(email: widget.userEmail),
          ],
        ),
//        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}

class OtherFreelancersRequestsAndAids extends StatelessWidget {
  final String userEmail;
  final String requestCategory;

  OtherFreelancersRequestsAndAids(
      {Key? key, required this.requestCategory, required this.userEmail})
      : super(key: key);

  final Stream<QuerySnapshot> _dailyUpdated = FirebaseFirestore.instance
      .collection('Requests')
      .orderBy('Created AT', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
                color: darkPurple,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _dailyUpdated,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                final List storeRequests = [];

                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  storeRequests.add(id);
//                  print('==============================================');
//                  print(storeRequests);
//                  print('Document id : ${document.id}');
                  id['id'] = document.id;
                }).toList();
                return Column(
//                            shrinkWrap: true,
                  children: [
                    storeRequests.isEmpty
                        ? const Text('No dItem Find')
                        : Container(),
                    for (int i = 0; i < storeRequests.length; i++) ...[
                      requestCategory == 'Special Category' &&
                              storeRequests[i]['User Email'] == userEmail
                          ? CustomContainer2(
                              userName: storeRequests[i]['User Name'],
                              userEmail: storeRequests[i]['User Email'],
                              userProfileUrl: storeRequests[i]
                                  ['Profile Image URL'],
                              requestCategory: storeRequests[i]
                                  ['Selected Category'],
                              title: storeRequests[i]['Request Title'],
                              description: storeRequests[i]
                                  ['Request Description'],
                              imagePath: storeRequests[i]['Request Image URL'],
                              imageType: 'Network',
                              location: storeRequests[i]['Current Address'],
                              innerBorder: 20.0,
                              smallBoxWidth: 110,
                              smallBoxHeight: 80)
                          : storeRequests[i]['Selected Category'] ==
                                      requestCategory &&
                                  storeRequests[i]['User Email'] == userEmail
                              ? CustomContainer2(
                                  userName: storeRequests[i]['User Name'],
                                  userEmail: storeRequests[i]['User Email'],
                                  userProfileUrl: storeRequests[i]
                                      ['Profile Image URL'],
                                  requestCategory: storeRequests[i]
                                      ['Selected Category'],
                                  title: storeRequests[i]['Request Title'],
                                  description: storeRequests[i]
                                      ['Request Description'],
                                  imagePath: storeRequests[i]
                                      ['Request Image URL'],
                                  imageType: 'Network',
                                  location: storeRequests[i]['Current Address'],
                                  innerBorder: 20.0,
                                  smallBoxWidth: 110,
                                  smallBoxHeight: 80)
                              : Container(),
                    ],
                  ],
                );
              }),
//                    ListView(
//                      shrinkWrap: true,
//                      children: [
//                        CustumContainer(
//                            title: 'Admin',
//                            description:
//                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//                            innerBorder: 10.0,
//                            location: 'London',
//                            imagePath: 'images/samplePerson3.jpg',
//                            imageType: '',
//                            smallBoxWidth: 100,
//                            smallBoxHeight: 70),
//                      ],
//                    ),
        ],
      ),
    );
  }
}
