import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        .add({
          'Created AT': DateTime.now(),
          'Request Owner Email': widget.userEmail,
          'Request Buyer Email': currentUserEmail.toString(),
          'Request Title': widget.title,
          'Request Category': widget.requestCategory,
          'Is Request Accepted': isAccepted,
          'Is Job Complete': isCompleted,
        })
        .then((value) => print('Data Added Successfully : $currentUserEmail'))
        .catchError((error) => print('Failed to Add Data $error'));
  }

  Future<void> addOwnerData(bool isAccepted, bool isCompleted) {
    return FirebaseFirestore.instance
        .collection('Owner ${widget.userEmail}')
        .add({
          'Created AT': DateTime.now(),
          'Request Owner Email': widget.userEmail,
          'Request Buyer Email': currentUserEmail.toString(),
          'Request Title': widget.title,
          'Request Category': widget.requestCategory,
          'Is Request Accepted': isAccepted,
          'Is Job Complete': isCompleted,
        })
        .then((value) => print('Data Added Successfully : $currentUserEmail'))
        .catchError((error) => print('Failed to Add Data $error'));
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
                  text: 'Post Detail ',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ListTile(
              tileColor: darkPurple,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.userProfileUrl),
                radius: 25.0,
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
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: isVisible ? 50 : 0,
        child: isVisible
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Material(
                  color: lightPurple,
                  clipBehavior: Clip.antiAlias,
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 50.0,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    onPressed: () async {
                      await addBuyerData(true, false);
                      await addOwnerData(true, false);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => RequestScreen(),
                      //     ));
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
