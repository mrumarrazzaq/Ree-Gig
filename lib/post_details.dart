import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/chat_screen.dart';
import 'package:ree_gig/project_constants.dart';

class PostDetail extends StatefulWidget {
  PostDetail({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userProfileUrl,
    required this.requestCategory,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.location,
  }) : super(key: key);
  String userName;
  String userEmail;
  String userProfileUrl;
  String requestCategory;
  String title;
  String description;
  String imagePath;
  String location;
  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  ScrollController _scrollController = ScrollController();
  bool isVisible = true;
  bool _condition = false;
  bool _isJobCompleted = false;
  IconData icon = Icons.access_time;
  Color color = Colors.red;
  String progress = 'Active';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(listen);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(listen);
  }

  void listen() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
  }

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    }
  }

  Future<void> addBuyerData(bool isAccepted, bool isCompleted) {
    return FirebaseFirestore.instance
        .collection('Buyer $currentUserEmail')
        .doc('$currentUserEmail ${widget.title} ${widget.requestCategory}')
        .set({
          'Created AT': DateTime.now(),
          'Seller Name': widget.userName,
          'Request Seller Email': widget.userEmail,
          'Request Buyer Email': currentUserEmail.toString(),
          'Profile Image URL': widget.userProfileUrl,
          'Request Title': widget.title,
          'Request Description': widget.description,
          'Request Category': widget.requestCategory,
          'Request Image URL': widget.imagePath,
          'Current Address': widget.location,
          'Is Request Accepted': isAccepted,
          'Is Job Complete': isCompleted,
        })
        .then((value) => log('Data Added Successfully : $currentUserEmail'))
        .catchError((error) => log('Failed to Add Data $error'));
  }

  Future<void> addSellerData(bool isAccepted, bool isCompleted) {
    return FirebaseFirestore.instance
        .collection('Seller ${widget.userEmail}')
        .doc('${widget.userEmail} ${widget.title} ${widget.requestCategory}')
        .set({
          'Created AT': DateTime.now(),
          'Seller Name': widget.userName,
          'Request Seller Email': widget.userEmail,
          'Request Buyer Email': currentUserEmail.toString(),
          'Profile Image URL': widget.userProfileUrl,
          'Request Title': widget.title,
          'Request Description': widget.description,
          'Request Category': widget.requestCategory,
          'Request Image URL': widget.imagePath,
          'Current Address': widget.location,
          'Is Request Accepted': isAccepted,
          'Is Job Complete': isCompleted,
        })
        .then((value) => log('Data Added Successfully : ${widget.userEmail}'))
        .catchError((error) => log('Failed to Add Data $error'));
  }

  //--------------------------------------------------------------//

  Future<void> deleteBuyerDataFromFirebase(id) {
    return FirebaseFirestore.instance
        .collection('Buyer $currentUserEmail')
        .doc(id)
        .delete()
        .then((value) => log('Event deleted $id'))
        .catchError((error) => log('Failed to delete Chat $error'));
  }

  Future<void> deleteSellerDataFromFirebase(id) {
    return FirebaseFirestore.instance
        .collection('Seller ${widget.userEmail}')
        .doc(id)
        .delete()
        .then((value) => log('Event deleted $id'))
        .catchError((error) => log('Failed to delete Chat $error'));
  }

  // updateSellerDataFromFirebase(id, bool value) {
  //   return FirebaseFirestore.instance
  //       .collection('Seller ${widget.userEmail}')
  //       .doc(id)
  //       .update({
  //         'Is Job Complete': value,
  //       })
  //       .then((value) => log('Data Updated $id'))
  //       .catchError((error) => log('Failed to Update isCompleted $error'));
  // }
  //
  // updateBuyerDataFromFirebase(id, bool value) {
  //   return FirebaseFirestore.instance
  //       .collection('Buyer $currentUserEmail')
  //       .doc(id)
  //       .update({
  //         'Is Job Complete': value,
  //       })
  //       .then((value) => log('Data Updated $id'))
  //       .catchError((error) => log('Failed to Update isCompleted $error'));
  // }

//--------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Post Detail ',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        // controller: _scrollController,
        child: Column(
          children: [
            Stack(
              children: [
                ListTile(
                  tileColor: darkPurple,
                  leading: widget.userProfileUrl.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(widget.userProfileUrl),
                          radius: 25.0,
                        )
                      : CircleAvatar(
                          foregroundImage:
                              const AssetImage('icons/default_profile.png'),
                          radius: 25.0,
                          backgroundColor: lightPurple.withOpacity(0.4),
                        ),
                  title: Text(
                    widget.userName,
                    style: TextStyle(color: whiteColor),
                  ),
                  subtitle: Text(
                    widget.userEmail,
                    style: TextStyle(color: whiteColor),
                  ),
                ),
                // Positioned.fill(
                //   left: 20.0,
                //   top: 2.0,
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: TextButton(
                //       // color: darkPurple,
                //       // minWidth: double.infinity,
                //       onPressed: () {
                //         // showDialog(
                //         //     context: context,
                //         //     builder: (context) {
                //         //
                //         //       return AlertDialog(
                //         //         title: const Center(
                //         //           child: Text('Acknowledge'),
                //         //         ),
                //         //         content: const SizedBox(
                //         //           height: 20,
                //         //           child:
                //         //               Center(child: Text('Choose Job status')),
                //         //         ),
                //         //         actions: [
                //         //           TextButton(
                //         //             onPressed: () async {
                //         //               await updateSellerDataFromFirebase(
                //         //                   '${widget.userEmail} ${widget.title} ${widget.requestCategory}',
                //         //                   false);
                //         //               await updateBuyerDataFromFirebase(
                //         //                   '$currentUserEmail ${widget.title} ${widget.requestCategory}',
                //         //                   false);
                //         //               Navigator.pop(context, true);
                //         //             },
                //         //             child: Row(
                //         //               mainAxisSize: MainAxisSize.min,
                //         //               children: const [
                //         //                 Icon(Icons.access_time,
                //         //                     color: Colors.red),
                //         //                 Text('Active',
                //         //                     style:
                //         //                         TextStyle(color: Colors.red)),
                //         //               ],
                //         //             ),
                //         //           ),
                //         //           TextButton(
                //         //             onPressed: () async {
                //         //               await updateSellerDataFromFirebase(
                //         //                   '${widget.userEmail} ${widget.title} ${widget.requestCategory}',
                //         //                   true);
                //         //               await updateBuyerDataFromFirebase(
                //         //                   '$currentUserEmail ${widget.title} ${widget.requestCategory}',
                //         //                   true);
                //         //               Navigator.pop(context, true);
                //         //             },
                //         //             child: Row(
                //         //               mainAxisSize: MainAxisSize.min,
                //         //               children: const [
                //         //                 Icon(Icons.check, color: Colors.green),
                //         //                 Text('Completed',
                //         //                     style:
                //         //                         TextStyle(color: Colors.green)),
                //         //               ],
                //         //             ),
                //         //           ),
                //         //         ],
                //         //       );
                //         //
                //         //     });
                //         if (!_isJobCompleted) {
                //           openJobCompletionDialog();
                //         } else {
                //           Fluttertoast.showToast(
                //             msg: 'Job Already Completed', // message
                //             toastLength: Toast.LENGTH_SHORT, // length
                //             gravity: ToastGravity.BOTTOM, // location
                //             backgroundColor: Colors.grey,
                //           );
                //         }
                //       },
                //       child: StreamBuilder<QuerySnapshot>(
                //           stream: FirebaseFirestore.instance
                //               .collection('Buyer $currentUserEmail')
                //               .snapshots(),
                //           builder: (BuildContext context,
                //               AsyncSnapshot<QuerySnapshot> snapshot) {
                //             if (snapshot.hasError) {
                //               log('Something went wrong');
                //             }
                //             if (snapshot.connectionState ==
                //                 ConnectionState.waiting) {
                //               return Center(
                //                   child: CircularProgressIndicator(
                //                 color: lightPurple,
                //                 strokeWidth: 2.0,
                //               ));
                //             }
                //
                //             final List storedData = [];
                //
                //             snapshot.data!.docs
                //                 .map((DocumentSnapshot document) {
                //               Map id = document.data() as Map<String, dynamic>;
                //
                //               // print(document.id);
                //               storedData.add(id);
                //               id['id'] = document.id;
                //             }).toList();
                //             for (int i = 0; i < storedData.length; i++) {
                //               if (storedData[i]['Request Title'] ==
                //                       widget.title &&
                //                   storedData[i]['Request Category'] ==
                //                       widget.requestCategory &&
                //                   storedData[i]['Request Seller Email'] ==
                //                       widget.userEmail &&
                //                   storedData[i]['Is Job Complete'] == true) {
                //                 log('yes isJobCompleted true');
                //
                //                 _isJobCompleted = true;
                //               }
                //               if (storedData[i]['Request Title'] ==
                //                       widget.title &&
                //                   storedData[i]['Request Category'] ==
                //                       widget.requestCategory &&
                //                   storedData[i]['Request Seller Email'] ==
                //                       widget.userEmail &&
                //                   storedData[i]['Is Job Complete'] == false) {
                //                 log('yes isJobCompleted true');
                //
                //                 _isJobCompleted = false;
                //               }
                //             }
                //             return Row(
                //               mainAxisSize: MainAxisSize.min,
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Icon(
                //                     _isJobCompleted
                //                         ? Icons.check
                //                         : Icons.access_time,
                //                     color: _isJobCompleted
                //                         ? Colors.green
                //                         : Colors.red),
                //                 Text(_isJobCompleted ? 'Completed' : 'Active',
                //                     style: TextStyle(
                //                       color: _isJobCompleted
                //                           ? Colors.green
                //                           : Colors.red,
                //                     )),
                //               ],
                //             );
                //           }),
                //     ),
                //   ),
                // ),
              ],
            ),
            Container(
              height: 10.0,
              decoration: BoxDecoration(
                color: darkPurple,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: Text(widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Text(widget.description),
            Text(
              widget.requestCategory,
              style: TextStyle(
                color: lightPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red[800],
                  size: 18.0,
                ),
                Text(
                  '  ${widget.location}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Image.network(
                widget.imagePath,
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Buyer $currentUserEmail')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              log('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: lightPurple,
                strokeWidth: 2.0,
              ));
            }

            final List storedMassages = [];

            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map id = document.data() as Map<String, dynamic>;

              // print(document.id);
              storedMassages.add(id);
              id['id'] = document.id;
            }).toList();
            for (int i = 0; i < storedMassages.length; i++) {
              if (storedMassages[i]['Request Title'] == widget.title &&
                  storedMassages[i]['Request Category'] ==
                      widget.requestCategory &&
                  storedMassages[i]['Request Seller Email'] ==
                      widget.userEmail &&
                  storedMassages[i]['Is Request Accepted'] == true) {
                log('yes condition true');

                _condition = true;
              }
            }
            return Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
              child: Material(
                color: _condition ? Colors.purple[100] : lightPurple,
                clipBehavior: Clip.antiAlias,
                elevation: 3.0,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 50.0,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  onPressed: () async {
                    if (_condition) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              title: widget.title,
                              requestCategory: widget.requestCategory,
                              userEmail: widget.userEmail,
                              name: widget.userName,
                              receiverEmail: widget.userEmail,
                              imagePath: widget.userProfileUrl,
                              isSpecial: true),
                        ),
                      );
                    }
                    // if (_condition) {
                    //   deleteSellerDataFromFirebase(
                    //       '${widget.userEmail} ${widget.title} ${widget.requestCategory}');
                    //   deleteBuyerDataFromFirebase(
                    //       '$currentUserEmail ${widget.title} ${widget.requestCategory}');
                    //   setState(() {
                    //     _condition = false;
                    //   });
                    // } else {
                    //   await addBuyerData(true, false);
                    //   await addSellerData(true, false);
                    // }
                    if (!_condition) {
                      openRequestAcceptConfirmationDialog();
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => RequestScreen(),
                    //     ));
                  },
                  child: Text(
                    _condition ? 'Accepted' : 'Accept',
                    style: TextStyle(
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            );

            // Text(storedMassages[0]['User Current Status'],
            //   style:
            //       TextStyle(fontStyle: FontStyle.italic, color: whiteColor));
          }),

      // Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //         child: Material(
      //           color: lightPurple,
      //           clipBehavior: Clip.antiAlias,
      //           elevation: 3.0,
      //           borderRadius: BorderRadius.circular(30.0),
      //           child: MaterialButton(
      //             minWidth: 200.0,
      //             height: 50.0,
      //             padding: const EdgeInsets.symmetric(vertical: 10.0),
      //             onPressed: () async {
      //               await addBuyerData(true, false);
      //               await addOwnerData(true, false);
      //               // Navigator.push(
      //               //     context,
      //               //     MaterialPageRoute(
      //               //       builder: (context) => RequestScreen(),
      //               //     ));
      //             },
      //             child: Text(
      //               'Accept',
      //               style: TextStyle(
      //                 color: whiteColor,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
    );
  }

  openRequestAcceptConfirmationDialog() => showDialog(
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
                  height: 40.0,
                  child: Center(
                      child: Column(
                    children: const [
                      Text('Do you want to Accept Request'),
                      Text('Accepted Request cannot Re-accept',
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
                    await addBuyerData(true, false);
                    await addSellerData(true, false);
                    Fluttertoast.showToast(
                      msg: 'Request Accepted Successfully', // message
                      toastLength: Toast.LENGTH_SHORT, // length
                      gravity: ToastGravity.BOTTOM, // location
                      backgroundColor: Colors.green,
                    );
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            title: widget.title,
                            requestCategory: widget.requestCategory,
                            userEmail: widget.userEmail,
                            name: widget.userName,
                            receiverEmail: widget.userEmail,
                            imagePath: widget.userProfileUrl,
                            isSpecial: true),
                      ),
                    );
                  },
                  child: const Text(
                    'ACCEPT',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            );
          },
        ),
      );
  // openJobCompletionDialog() => showDialog(
  //       context: context,
  //       builder: (context) => StatefulBuilder(
  //         builder: (context, setState) {
  //           var width = MediaQuery.of(context).size.width;
  //           return AlertDialog(
  //             shape: const RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //             contentPadding: const EdgeInsets.only(top: 10.0),
  //             title: const Center(child: Text('Confirmation')),
  //             content: SingleChildScrollView(
  //               child: SizedBox(
  //                 width: width,
  //                 height: 80.0,
  //                 child: Center(
  //                     child: Column(
  //                   children: const [
  //                     Expanded(
  //                       child: Text('JOB STATUS',
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               overflow: TextOverflow.fade)),
  //                     ),
  //                     Text('Is your job has been completed ?'),
  //                     Text('You cannot change job status after completion ',
  //                         style: TextStyle(
  //                             fontStyle: FontStyle.italic,
  //                             fontSize: 11,
  //                             color: Colors.red)),
  //                   ],
  //                 )),
  //               ),
  //             ),
  //             actions: [
  //               //CANCEL Button
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context, rootNavigator: true).pop('dialog');
  //                 },
  //                 child: Text(
  //                   'CANCEL',
  //                   style: TextStyle(color: Colors.grey[600]),
  //                 ),
  //               ),
  //               //CREATE Button
  //               TextButton(
  //                 onPressed: () async {
  //                   await updateSellerDataFromFirebase(
  //                       '${widget.userEmail} ${widget.title} ${widget.requestCategory}',
  //                       true);
  //                   await updateBuyerDataFromFirebase(
  //                       '$currentUserEmail ${widget.title} ${widget.requestCategory}',
  //                       true);
  //                   Navigator.pop(context, true);
  //                   Fluttertoast.showToast(
  //                     msg: 'Job Completed Successfully', // message
  //                     toastLength: Toast.LENGTH_SHORT, // length
  //                     gravity: ToastGravity.BOTTOM, // location
  //                     backgroundColor: Colors.green,
  //                   );
  //                   Navigator.of(context, rootNavigator: true).pop('dialog');
  //                 },
  //                 child: const Text(
  //                   'COMPLETED',
  //                   style: TextStyle(color: Colors.green),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     );
}
