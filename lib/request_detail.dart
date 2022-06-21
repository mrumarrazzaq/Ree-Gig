import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';

class RequestDetail extends StatefulWidget {
  RequestDetail(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.userProfileUrl,
      required this.requestTitle,
      required this.requestDescription,
      required this.requestCategory,
      required this.requestLocation,
      required this.requestImagePath,
      required this.imageType})
      : super(key: key);
  String userName;
  String userEmail;
  String userProfileUrl;
  String requestTitle;
  String requestDescription;
  String requestCategory;
  String requestLocation;
  String requestImagePath;
  String imageType;

  @override
  _RequestDetailState createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  @override
  Widget build(BuildContext context) {
    print('========================');
    print(widget.userProfileUrl);
    if (widget.userProfileUrl.isEmpty) {
      print('yes');
    }
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Request User Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: lightPurple,
                      fontSize: 25.0)),
            ),
            Card(
              elevation: 1.0,
//                    color: lightPurple.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(width: 5, color: lightPurple),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  minLeadingWidth: 0.0,
                  textColor: blackColor,
                  leading: widget.userProfileUrl.isEmpty
                      ? CircleAvatar(
                          backgroundColor: lightPurple.withOpacity(0.4),
                          radius: 50.0,
                        )
                      : CircleAvatar(
                          foregroundImage: NetworkImage(widget.userProfileUrl),
                          backgroundColor: lightPurple.withOpacity(0.4),
                          radius: 50.0,
                        ),
                  title: Text(widget.userName),
                  subtitle: Text(widget.userEmail),
                  trailing: TextButton(
                    child: Text(
                      'Start Chat',
                      style: TextStyle(color: lightPurple),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Request Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: lightPurple,
                      fontSize: 25.0)),
            ),
            widget.imageType == 'Network'
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Image.network(widget.requestImagePath))
                : Image.asset(widget.requestImagePath),
            const Divider(),
            ListTile(
              leading: const Text('Request Title',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              title: Text(widget.requestTitle),
            ),
            const Divider(),
            ListTile(
              leading: const Text('Description',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              title: Text(widget.requestDescription),
            ),
            const Divider(),
            ListTile(
              leading: const Text('Category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              title: Text(widget.requestCategory),
            ),
            const Divider(),
            ListTile(
              leading: const Text('Address',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              title: Text(widget.requestLocation),
            ),
          ],
        ),
      ),
    );
  }
}
