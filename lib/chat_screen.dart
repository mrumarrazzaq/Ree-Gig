import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    required this.name,
    required this.receiverEmail,
    required this.imagePath,
    this.isChartHistorySave = false,
  }) : super(key: key);
  String name;
  String imagePath;
  String receiverEmail;
  bool isChartHistorySave;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _massageController = TextEditingController();
  var message;
  saveMassages(String time, String massage) async {
    await FirebaseFirestore.instance.collection('Chats').add({
      'message': massage,
      'Sender Email': currentUserEmail.toString(),
      'Receiver Email': widget.receiverEmail,
      'Created At': DateTime.now(),
      'Time': time,
    });

    print('-------------------------');
    print('Massage Send Successfully');
    print('-------------------------');
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
    await for (var snapshot in _firestore.collection('Chats').snapshots()) {
      for (var massages in snapshot.docs) {
        print(massages.data);
      }
    }
  }

  String _senderEmail = '';
  String _receiverEmail = '';

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
              height: 120,
              child: Padding(
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

                          final List storedMassages = [];

                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map id = document.data() as Map<String, dynamic>;
                            if (widget.receiverEmail == document.id) {
                              print(document.id);
                              storedMassages.add(id);
                              id['id'] = document.id;
                            }
                          }).toList();

                          return Text(storedMassages[0]['User Current Status'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 85.0, bottom: 70.0),
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

                          final List storedMassages = [];

                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map id = document.data() as Map<String, dynamic>;
                            storedMassages.add(id);
//                  print('==============================================');
//                  print(storeRequests);
//                  print('Document id : ${document.id}');
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
                hintText: 'Type Massages',
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
