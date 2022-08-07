import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/chat_screen.dart';
import 'package:ree_gig/follow_profile_screen.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/post_details.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/recent_chats.dart';
import 'package:ree_gig/requestion_section/request_screen.dart';

Color dropColor = const Color(0xff737373);

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 63.0,
      padding: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
              clipBehavior: Clip.antiAlias,
              shape: CircleBorder(),
              minWidth: 10,
              child: Image.asset('icons/profile.png', width: 30, height: 30),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowProfileScreen(),
                    ));
              }),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 10.0, right: 10, left: 10),
            child: Material(
              color: lightPurple,
              clipBehavior: Clip.antiAlias,
              elevation: 3.0,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                minWidth: 200.0,
                height: 40.0,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestScreen(),
                      ));
                },
                child: Text(
                  'REQUEST',
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ),
          MaterialButton(
            clipBehavior: Clip.antiAlias,
            minWidth: 10,
            shape: CircleBorder(),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecentChats(),
                  ));
            },
            child: Image.asset('icons/chat.png', width: 30, height: 30),
          ),
        ],
      ),
    );
  }
}

class CustomContainer1 extends StatefulWidget {
  CustomContainer1({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userProfileUrl,
    required this.requestCategory,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.innerBorder,
    required this.smallBoxWidth,
    required this.smallBoxHeight,
    required this.location,
    required this.imageType,
  }) : super(key: key);
  String userName;
  String userEmail;
  String userProfileUrl;
  String requestCategory;
  String title;
  String description;
  String imagePath;
  double innerBorder;
  double smallBoxWidth;
  double smallBoxHeight;
  String location;
  String imageType;
  @override
  _CustomContainer1State createState() => _CustomContainer1State();
}

class _CustomContainer1State extends State<CustomContainer1> {
  bool _reverseArrowDirection = false;
  int _length = 0;
  bool _isArrowVisible = true;
  descriptionLength() {
    setState(() {
      _length = widget.description.length;
      if (_length <= 70) {
        _isArrowVisible = false;
      } else {
        _isArrowVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    descriptionLength();
    print(widget.description.length);
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(widget.imagePath),
            ),
          ),
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FreelancerProfileScreen(
              userName: widget.userName,
              userEmail: widget.userEmail,
              userProfileUrl: widget.userProfileUrl,
              requestCategory: widget.requestCategory,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffdcd0d0),
              borderRadius: BorderRadius.circular(20)),
          child: Stack(children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 8.0, bottom: 5.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 220,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                  child: Row(children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red[800],
                      size: 18.0,
                    ),
                    SizedBox(
                      width: 220,
                      child: Text(
                        widget.location,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 140.0, left: 15.0, bottom: 20.0),
                  child: SizedBox(
                    width: 220,
                    child: Text(
                      widget.description,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.left,
                      maxLines: maxLines,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: widget.smallBoxHeight,
                  width: widget.smallBoxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(widget.innerBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff737373),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: widget.imagePath == ''
                      ? null
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: widget.imageType == 'Network'
                              ? FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(widget.imagePath,
//                                width: double.infinity,
                                      height: widget.smallBoxHeight),
                                )
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset(widget.imagePath,
                                      width: double.infinity,
                                      height: widget.smallBoxHeight),
                                ),
                        ),
                ),
              ),
            ),
            Positioned.fill(
              top: 104,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: _isArrowVisible,
                  child: IconButton(
                      splashRadius: 30.0,
                      splashColor: lightPurple.withOpacity(0.3),
                      onPressed: () {
                        setState(() {
                          _reverseArrowDirection = !_reverseArrowDirection;
                          if (_reverseArrowDirection == true) {
                            maxLines = 8;
                            dropColor = Colors.white;
                          } else {
                            maxLines = 3;
                            dropColor = const Color(0xff737373);
                          }
                        });
                      },
                      icon: Icon(
                        _reverseArrowDirection
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: dropColor,
                        size: 30,
                      )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CustomContainer2 extends StatefulWidget {
  CustomContainer2({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userProfileUrl,
    required this.requestCategory,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.innerBorder,
    required this.smallBoxWidth,
    required this.smallBoxHeight,
    required this.location,
    required this.imageType,
  }) : super(key: key);
  String userName;
  String userEmail;
  String userProfileUrl;
  String requestCategory;
  String title;
  String description;
  String imagePath;
  double innerBorder;
  double smallBoxWidth;
  double smallBoxHeight;
  String location;
  String imageType;
  @override
  _CustomContainer2State createState() => _CustomContainer2State();
}

class _CustomContainer2State extends State<CustomContainer2> {
  bool _reverseArrowDirection = false;
  int _length = 0;
  bool _isArrowVisible = true;
  var isUserMode;
  bool _isTure = true;
  descriptionLength() {
    setState(() {
      _length = widget.description.length;
      if (_length <= 70) {
        _isArrowVisible = false;
      } else {
        _isArrowVisible = true;
      }
    });
  }

  readFutureValue() async {
    print('Reading Future Values');
    var _mode = await readMode();
    print('_mode : $_mode');
    setState(() {
      isUserMode = _mode;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_isTure) {
      readFutureValue();
      setState(() {
        _isTure = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    descriptionLength();
    // print(widget.description.length);
    return GestureDetector(
      onTap: () {
        if (isUserMode == false && currentUserEmail != widget.userEmail) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetail(
                userName: widget.userName,
                userEmail: widget.userEmail,
                userProfileUrl: widget.userProfileUrl,
                title: widget.title,
                description: widget.description,
                requestCategory: widget.requestCategory,
                imagePath: widget.imagePath,
                location: widget.location,
              ),
            ),
          );
        }
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: FittedBox(
              fit: BoxFit.fill,
              clipBehavior: Clip.antiAlias,
              child: Image.network(widget.imagePath),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffdcd0d0),
              borderRadius: BorderRadius.circular(20)),
          child: Stack(children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 8.0, bottom: 5.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                  child: Row(children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red[800],
                      size: 18.0,
                    ),
                    SizedBox(
                      width: 220,
                      child: Text(
                        widget.location,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 140.0, left: 15.0, bottom: 20.0),
                  child: SizedBox(
                    width: 220,
                    child: Text(
                      widget.description,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.left,
                      maxLines: maxLines,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: widget.smallBoxHeight,
                  width: widget.smallBoxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(widget.innerBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff737373),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: widget.imagePath == ''
                      ? null
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: widget.imageType == 'Network'
                              ? FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(widget.imagePath,
//                                width: double.infinity,
                                      height: widget.smallBoxHeight),
                                )
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset(widget.imagePath,
                                      width: double.infinity,
                                      height: widget.smallBoxHeight),
                                ),
                        ),
                ),
              ),
            ),
            Positioned.fill(
              top: 104,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: _isArrowVisible,
                  child: IconButton(
                      splashRadius: 30.0,
                      splashColor: lightPurple.withOpacity(0.3),
                      onPressed: () {
                        setState(() {
                          _reverseArrowDirection = !_reverseArrowDirection;
                          if (_reverseArrowDirection == true) {
                            maxLines = 8;
                            dropColor = Colors.white;
                          } else {
                            maxLines = 3;
                            dropColor = const Color(0xff737373);
                          }
                        });
                      },
                      icon: Icon(
                        _reverseArrowDirection
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: dropColor,
                        size: 30,
                      )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CustomContainer3 extends StatefulWidget {
  CustomContainer3({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userProfileUrl,
    required this.requestCategory,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.innerBorder,
    required this.smallBoxWidth,
    required this.smallBoxHeight,
    required this.location,
    required this.imageType,
  }) : super(key: key);
  String userName;
  String userEmail;
  String userProfileUrl;
  String requestCategory;
  String title;
  String description;
  String imagePath;
  double innerBorder;
  double smallBoxWidth;
  double smallBoxHeight;
  String location;
  String imageType;
  @override
  _CustomContainer3State createState() => _CustomContainer3State();
}

class _CustomContainer3State extends State<CustomContainer3> {
  bool _reverseArrowDirection = false;
  int _length = 0;
  bool _isArrowVisible = true;
  descriptionLength() {
    setState(() {
      _length = widget.description.length;
      if (_length <= 70) {
        _isArrowVisible = false;
      } else {
        _isArrowVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    descriptionLength();
    print(widget.description.length);
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(widget.imagePath),
            ),
          ),
        );
      },
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffdcd0d0),
              borderRadius: BorderRadius.circular(20)),
          child: Stack(children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 8.0, bottom: 5.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 220,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                  child: Row(children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red[800],
                      size: 18.0,
                    ),
                    SizedBox(
                      width: 220,
                      child: Text(
                        widget.location,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 140.0, left: 15.0, bottom: 20.0),
                  child: SizedBox(
                    width: 220,
                    child: Text(
                      widget.description,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.left,
                      maxLines: maxLines,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: widget.smallBoxHeight,
                  width: widget.smallBoxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(widget.innerBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff737373),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: widget.imagePath == ''
                      ? null
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: widget.imageType == 'Network'
                              ? FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(widget.imagePath,
//                                width: double.infinity,
                                      height: widget.smallBoxHeight),
                                )
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset(widget.imagePath,
                                      width: double.infinity,
                                      height: widget.smallBoxHeight),
                                ),
                        ),
                ),
              ),
            ),
            Positioned.fill(
              top: 104,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: _isArrowVisible,
                  child: IconButton(
                      splashRadius: 30.0,
                      splashColor: lightPurple.withOpacity(0.3),
                      onPressed: () {
                        setState(() {
                          _reverseArrowDirection = !_reverseArrowDirection;
                          if (_reverseArrowDirection == true) {
                            maxLines = 8;
                            dropColor = Colors.white;
                          } else {
                            maxLines = 3;
                            dropColor = const Color(0xff737373);
                          }
                        });
                      },
                      icon: Icon(
                        _reverseArrowDirection
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: dropColor,
                        size: 30,
                      )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CustomReviews extends StatefulWidget {
  CustomReviews(
      {Key? key,
      required this.title,
      required this.description,
      required this.imagePath,
      required this.starValue,
      required this.starSize})
      : super(key: key);

  String title;
  String description;
  String imagePath;
  int starValue;
  double starSize;

  @override
  State<CustomReviews> createState() => _CustomReviewsState();
}

class _CustomReviewsState extends State<CustomReviews> {
  List<Color> stars = [
    Colors.yellow,
    Colors.yellow,
    Colors.yellow,
    Colors.yellow,
    Colors.yellow,
  ];

  processStars(int starValue) {
    if (starValue == 0) {
      stars[0] = Colors.grey;
      stars[1] = Colors.grey;
      stars[2] = Colors.grey;
      stars[3] = Colors.grey;
      stars[4] = Colors.grey;
    } else if (starValue == 1) {
      stars[0] = Colors.yellow;
      stars[1] = Colors.grey;
      stars[2] = Colors.grey;
      stars[3] = Colors.grey;
      stars[4] = Colors.grey;
    } else if (starValue == 2) {
      stars[0] = Colors.yellow;
      stars[1] = Colors.yellow;
      stars[2] = Colors.grey;
      stars[3] = Colors.grey;
      stars[4] = Colors.grey;
    } else if (starValue == 3) {
      stars[0] = Colors.yellow;
      stars[1] = Colors.yellow;
      stars[2] = Colors.yellow;
      stars[3] = Colors.grey;
      stars[4] = Colors.grey;
    } else if (starValue == 4) {
      stars[0] = Colors.yellow;
      stars[1] = Colors.yellow;
      stars[2] = Colors.yellow;
      stars[3] = Colors.yellow;
      stars[4] = Colors.grey;
    } else if (starValue == 5) {
      stars[0] = Colors.yellow;
      stars[1] = Colors.yellow;
      stars[2] = Colors.yellow;
      stars[3] = Colors.yellow;
      stars[4] = Colors.yellow;
    }
  }

  @override
  void initState() {
    processStars(widget.starValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: widget.imagePath == ''
            ? CircleAvatar(
                radius: 30.0,
                backgroundImage: const AssetImage('icons/default_profile.png'),
                backgroundColor: lightPurple.withOpacity(0.4),
              )
            : CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(widget.imagePath),
                backgroundColor: lightPurple.withOpacity(0.4),
              ),
        title: Text(widget.title,
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(
                Icons.star,
                color: stars[0],
                size: widget.starSize,
              ),
              Icon(
                Icons.star,
                color: stars[1],
                size: widget.starSize,
              ),
              Icon(
                Icons.star,
                color: stars[2],
                size: widget.starSize,
              ),
              Icon(
                Icons.star,
                color: stars[3],
                size: widget.starSize,
              ),
              Icon(
                Icons.star,
                color: stars[4],
                size: widget.starSize,
              ),
            ]),
            Text(
              widget.description,
              textAlign: TextAlign.left,
            ),
            const Divider(),
          ],
        ));
  }
}

class CustomRecentChatsTile extends StatelessWidget {
  CustomRecentChatsTile({
    Key? key,
    required this.name,
    required this.email,
    required this.massage,
    required this.imagePath,
    required this.noOfMassages,
    required this.currentStatus,
    required this.time,
  }) : super(key: key);

  String name;
  String email;
  String massage;
  String imagePath;
  int noOfMassages;
  String currentStatus;
  String time;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                title: '',
                requestCategory: '',
                userEmail: '',
                name: name,
                imagePath: imagePath,
                receiverEmail: email,
                isSpecial: false,
              ),
            ));
      },
      child: Column(
        children: [
          ListTile(
            leading: imagePath != ''
                ? Stack(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(imagePath),
                      ),
                      Positioned(
                        top: 40,
                        left: 40,
                        child: CircleAvatar(
                          backgroundColor: currentStatus == 'Online'
                              ? Colors.green
                              : Colors.grey[600],
                          radius: 6.5,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                            const AssetImage('icons/default_profile.png'),
                        backgroundColor: lightPurple.withOpacity(0.4),
                      ),
                      Positioned(
                        top: 40,
                        left: 40,
                        child: CircleAvatar(
                          backgroundColor: currentStatus == 'Online'
                              ? Colors.green
                              : Colors.grey[600],
                          radius: 6.5,
                        ),
                      ),
                    ],
                  ),
            title:
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  massage,
                  overflow: TextOverflow.fade,
//                  style: const TextStyle(fontSize: 11),
                ),
//                Text(time),
              ],
            ),
            trailing: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: noOfMassages == 0
                    ? Colors.white
                    : Colors.purpleAccent.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                  child: Text(noOfMassages.toString(),
                      style: TextStyle(color: whiteColor))),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
