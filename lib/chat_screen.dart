import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/post_details.dart';
import 'package:ree_gig/project_constants.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    required this.title,
    required this.requestCategory,
    required this.userEmail,
    required this.name,
    required this.receiverEmail,
    required this.imagePath,
    this.isSpecial = false,
  }) : super(key: key);
  String title;
  String requestCategory;
  String userEmail;
  String name;
  String imagePath;
  String receiverEmail;
  bool isSpecial;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final TextEditingController _massageController = TextEditingController();
  var message;
  bool _isJobCompleted = false;
  IconData icon = Icons.access_time;
  Color color = Colors.red;
  String progress = 'Active';
  saveMassages(String time, String massage) async {
    await FirebaseFirestore.instance
        .collection('Chats')
        .add({
          'message': massage,
          'Sender Email': currentUserEmail.toString(),
          'Receiver Email': widget.receiverEmail,
          'Created At': DateTime.now(),
          'Time': time,
        })
        .then((value) => log('Massage Send Successfully'))
        .onError((error, stackTrace) => log('Massage Not Send Successfully'));

    await FirebaseFirestore.instance
        .collection('User Data')
        .doc('${widget.receiverEmail}')
        .update({
          'Created At': DateTime.now(),
        })
        .then((value) => log('Update Successfully'))
        .onError((error, stackTrace) => log('Update Failed'));
  }

  saveChatHistory(String time) async {
    await FirebaseFirestore.instance
        .collection('Recent Chats ${currentUserEmail.toString()}')
        .add({
      'Receiver Name': widget.name,
      'Receiver Email': widget.receiverEmail,
      'Receiver profileImageUrl': widget.imagePath,
      'Created At': currentDateTime,
      'Time': time,
    });
    _massageController.clear();
    print('-------------------------');
    print('Massage Send Successfully');
    print('-------------------------');
  }

  void massagesStream() async {
    await for (var snapshot in _fireStore.collection('Chats').snapshots()) {
      for (var massages in snapshot.docs) {
        print(massages.data);
      }
    }
  }

  updateSellerDataFromFirebase(id, bool value) {
    return FirebaseFirestore.instance
        .collection('Seller ${widget.userEmail}')
        .doc(id)
        .update({
          'Is Job Complete': value,
        })
        .then((value) => log('Data Updated $id'))
        .catchError((error) => log('Failed to Update isCompleted $error'));
  }

  updateBuyerDataFromFirebase(id, bool value) {
    return FirebaseFirestore.instance
        .collection('Buyer $currentUserEmail')
        .doc(id)
        .update({
          'Is Job Complete': value,
        })
        .then((value) => log('Data Updated $id'))
        .catchError((error) => log('Failed to Update isCompleted $error'));
  }

//--------------------------------------------------------------//
  @override
  void initState() {
//    if (widget.isChartHistorySave) {
//      saveChatHistory();
//    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Container(
            color: darkPurple,
            width: double.infinity,
            height: 200,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    child: ListTile(
                      leading: widget.imagePath != ''
                          ? CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(widget.imagePath),
                              backgroundColor: lightPurple.withOpacity(0.4),
                            )
                          : CircleAvatar(
                              radius: 30.0,
                              foregroundImage:
                                  const AssetImage('icons/default_profile.png'),
                              backgroundColor: lightPurple.withOpacity(0.4),
                            ),
                      title: Text(widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: whiteColor)),
                      dense: true,
                      subtitle: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('User Data')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              log('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: lightPurple,
                                strokeWidth: 2.0,
                              ));
                            }

                            final List storedMassages = [];

                            snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map id = document.data() as Map<String, dynamic>;
                              if (widget.receiverEmail == document.id) {
                                log(document.id);
                                storedMassages.add(id);
                                id['id'] = document.id;
                              }
                            }).toList();

                            return Text(
                                storedMassages[0]['User Current Status'],
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: whiteColor));
                          }),
                      // Text('online', style: TextStyle(color: whiteColor)),
                      trailing: IconButton(
                          icon: Icon(Icons.call, color: whiteColor),
                          onPressed: () {}),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FreelancerProfileScreen(
                              userName: widget.name,
                              userEmail: widget.receiverEmail,
                              userProfileUrl: widget.imagePath,
                              requestCategory: 'Special Category',
                            ),
                          ));
                    },
                  ),
                ),
                Visibility(
                  visible: widget.isSpecial,
                  child: ListTile(
                    dense: true,
                    title: TextButton(
                      onPressed: () {
                        if (!_isJobCompleted) {
                          openJobCompletionDialog();
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Job Already Completed', // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM, // location
                            backgroundColor: Colors.grey,
                          );
                        }
                      },
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Buyer $currentUserEmail')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              log('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: lightPurple,
                                strokeWidth: 2.0,
                              ));
                            }

                            final List storedData = [];

                            snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map id = document.data() as Map<String, dynamic>;

                              storedData.add(id);
                              id['id'] = document.id;
                            }).toList();
                            for (int i = 0; i < storedData.length; i++) {
                              if (storedData[i]['Request Title'] ==
                                      widget.title &&
                                  storedData[i]['Request Category'] ==
                                      widget.requestCategory &&
                                  storedData[i]['Request Seller Email'] ==
                                      widget.userEmail &&
                                  storedData[i]['Is Job Complete'] == true) {
                                log('yes isJobCompleted true');

                                _isJobCompleted = true;
                              }
                              if (storedData[i]['Request Title'] ==
                                      widget.title &&
                                  storedData[i]['Request Category'] ==
                                      widget.requestCategory &&
                                  storedData[i]['Request Seller Email'] ==
                                      widget.receiverEmail &&
                                  storedData[i]['Is Job Complete'] == false) {
                                log('yes isJobCompleted true');

                                _isJobCompleted = false;
                              }
                            }
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Job Status is   ',
                                  style: TextStyle(
                                      color: whiteColor, fontSize: 15),
                                ),
                                Icon(
                                    _isJobCompleted
                                        ? Icons.check
                                        : Icons.access_time,
                                    color: _isJobCompleted
                                        ? Colors.green
                                        : Colors.red),
                                Text(_isJobCompleted ? 'Completed' : 'Active',
                                    style: TextStyle(
                                      color: _isJobCompleted
                                          ? Colors.green
                                          : Colors.red,
                                    )),
                              ],
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  top: widget.isSpecial ? 130 : 85.0, bottom: 70.0),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Chats')
                            .orderBy('Created At', descending: false)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            log('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: lightPurple,
                              strokeWidth: 2.0,
                            ));
                          }

                          final List storedMassages = [];

                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map id = document.data() as Map<String, dynamic>;
                            storedMassages.add(id);
                            id['id'] = document.id;
                          }).toList();

                          return Column(
//                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              storedMassages.isEmpty
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50.0),
                                      child: Center(
                                        child: Text(
                                          'Say Hi to ${widget.name}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              for (int i = 0;
                                  i < storedMassages.length;
                                  i++) ...[
                                storedMassages[i]['Sender Email'] ==
                                            currentUserEmail &&
                                        storedMassages[i]['Receiver Email'] ==
                                            widget.receiverEmail
                                    ? ChatBubble(
                                        clipper: ChatBubbleClipper5(
                                            type: BubbleType.sendBubble),
                                        shadowColor: Colors.transparent,
                                        alignment: Alignment.topRight,
                                        margin: const EdgeInsets.only(
                                            top: 15, right: 10),
                                        backGroundColor: Colors.green[300],
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          child: Text(
                                            storedMassages[i]['message'],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
//                                 RightBubble(
// //                                            MediaQuery.of(context).size.width -
// //                                                80.0,
//                                         message: storedMassages[i]['message'],
//                                       )
                                    : storedMassages[i]['Sender Email'] ==
                                                widget.receiverEmail &&
                                            storedMassages[i]
                                                    ['Receiver Email'] ==
                                                currentUserEmail
                                        ? ChatBubble(
                                            clipper: ChatBubbleClipper5(
                                                type:
                                                    BubbleType.receiverBubble),
                                            shadowColor: Colors.transparent,
                                            backGroundColor:
                                                lightPurple.withOpacity(0.5),
                                            margin: const EdgeInsets.only(
                                                top: 15, left: 10),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                              ),
                                              child: Text(
                                                storedMassages[i]['message'],
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )
//                                 LeftBubble(
//                                             imagePath: widget.imagePath,
//
// //                          MediaQuery.of(context)
// //                                                    .size
// //                                                    .width -
// //                                                100.0,
//                                             message: storedMassages[i]
//                                                 ['message'],
//                                           )
                                        : Container(),
                              ],
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextFormField(
              maxLines: null,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
//              autofocus: true,
              decoration: InputDecoration(
                fillColor: lightPurple,
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: whiteColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: lightPurple, width: 1.5),
                ),
                hintText: 'Type Messages',
                hintStyle: const TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: whiteColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: whiteColor,
                  ),
                  tooltip: 'Send Massage',
                  splashColor: lightPurple.withOpacity(0.3),
                  splashRadius: 10,
                  onPressed: () async {
                    if (_massageController.text.isNotEmpty) {
                      String time;
                      if (currentDateTime.hour > 12) {
                        int hr = DateTime.now().hour - 12;
                        int min = DateTime.now().minute;
                        time = hr.toString() + ' : ' + min.toString() + ' PM';
                      } else {
                        int hr = DateTime.now().hour;
                        int min = DateTime.now().minute;
                        time = hr.toString() + ' : ' + min.toString() + ' AM';
                      }
                      message = _massageController.text;
                      _massageController.clear();
                      await saveMassages(time, message);
                    }
                  },
                ),
                prefixText: '  ',
              ),
              controller: _massageController,
            ),
          ),
        ],
      ),
    );
  }

  openJobCompletionDialog() => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            var width = MediaQuery.of(context).size.width;
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              title: const Center(child: Text('Confirmation')),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: width,
                  height: 80.0,
                  child: Center(
                      child: Column(
                    children: const [
                      Expanded(
                        child: Text('JOB STATUS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.fade)),
                      ),
                      Text('Is your job has been completed ?'),
                      Text('You cannot change job status after completion ',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 11,
                              color: Colors.red)),
                    ],
                  )),
                ),
              ),
              actions: [
                //CANCEL Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                //CREATE Button
                TextButton(
                  onPressed: () async {
                    await updateSellerDataFromFirebase(
                        '${widget.userEmail} ${widget.title} ${widget.requestCategory}',
                        true);
                    await updateBuyerDataFromFirebase(
                        '$currentUserEmail ${widget.title} ${widget.requestCategory}',
                        true);
                    Navigator.pop(context, true);
                    Fluttertoast.showToast(
                      msg: 'Job Completed Successfully', // message
                      toastLength: Toast.LENGTH_SHORT, // length
                      gravity: ToastGravity.BOTTOM, // location
                      backgroundColor: Colors.green,
                    );
                  },
                  child: const Text(
                    'COMPLETED',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class RightBubble extends StatelessWidget {
  RightBubble({
    Key? key,
//    required this.leftAlign,
//    required this.width,
//    required this.height,
    required this.message,
  }) : super(key: key);
//  double leftAlign;
//  double width;
//  double height;
  String message;

  @override
  Widget build(BuildContext context) {
    print('right');
    var half = MediaQuery.of(context).size.width / 1.8;

    return Padding(
      padding: EdgeInsets.only(left: half, top: 5.0, bottom: 5.0, right: 10.0),
      child: Container(
//        width: MediaQuery.of(context).size.width,
//        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text(message),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class LeftBubble extends StatelessWidget {
  LeftBubble({
    Key? key,
    required this.imagePath,
//    required this.rightAlign,
    required this.message,
//    required this.width,
//    required this.height,
  }) : super(key: key);
  String message;
  String imagePath;
//  double rightAlign;
//  double width;
//  double height;
  @override
  Widget build(BuildContext context) {
    print('Left');
    var half = MediaQuery.of(context).size.width / 1.8;
    var length = message.length.toDouble();
    return Padding(
      padding: EdgeInsets.only(right: half, top: 5.0, bottom: 5.0, left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
//              width: width,
//              height: height,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text(message),
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
