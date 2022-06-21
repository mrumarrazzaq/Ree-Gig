import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ree_gig/project_constants.dart';

class AdminRequestScreen extends StatefulWidget {
  static const String id = 'RequestScreen';
  @override
  _AdminRequestScreenState createState() => _AdminRequestScreenState();
}

class _AdminRequestScreenState extends State<AdminRequestScreen> {
  final Stream<QuerySnapshot> _registerdRequests =
      FirebaseFirestore.instance.collection('Requests').snapshots();
  @override
  Widget build(BuildContext context) {
    print('Request Screen Bulid Running.....');
    return Scaffold(
      backgroundColor: neuColor,
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Registered ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              TextSpan(
                  text: 'Requests',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
        backgroundColor: neuColor,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _registerdRequests,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                        child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: lightPurple,
                        strokeWidth: 2.0,
                      ),
                    )),
                  );
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
                print('Total Registerd Requests ${storeRequests.length}');
                saveRequests(storeRequests.length.toDouble());
                return Column(
//                            shrinkWrap: true,
                  children: [
                    storeRequests.isEmpty
                        ? const Text('No User find')
                        : Container(),
                    for (int i = 0; i < storeRequests.length; i++) ...[
                      CustomContainer(
                        userName: storeRequests[i]['User Name'],
                        userEmail: storeRequests[i]['User Email'],
                        userProfileUrl: storeRequests[i]['Profile Image URL'],
                        requestCategory: storeRequests[i]['Selected Category'],
                        title: storeRequests[i]['Request Title'],
                        description: storeRequests[i]['Request Description'],
                        imagePath: storeRequests[i]['Request Image URL'],
                        location: storeRequests[i]['Current Address'],
                        imageType: 'Network',
                        innerBorder: 20.0,
                        smallBoxWidth: 110,
                        smallBoxHeight: 80,
                      ),
                    ],
                  ],
                );
              }),
        ],
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  CustomContainer({
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
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool _reverseArrowDirection = false;
  int _length = 0;
  bool _isArrowVisible = true;
  descriptionLength() {
    setState(() {
      _length = widget.description.length;
      if (_length <= 50) {
        _isArrowVisible = false;
      } else {
        _isArrowVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    descriptionLength();
//    print(widget.description.length);
    return GestureDetector(
      onTap: () {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffdcd0d0),
              borderRadius: BorderRadius.circular(20)),
          child: Stack(children: [
            Column(
              children: [
                ListTile(
                    title: Text(widget.userName),
                    subtitle: Text(widget.userEmail)),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 3.0),
                  decoration: BoxDecoration(
//                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(widget.requestCategory,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 8.0, bottom: 5.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
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
                    Container(
                      child: Text(
                        widget.location,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 140.0, left: 15.0, bottom: 20.0),
                  child: Text(
                    widget.description,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.justify,
//                    maxLines: maxLines,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
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
//                            maxLines = 8;
//                            dropColor = Colors.white;
                          } else {
//                            maxLines = 3;
//                            dropColor = const Color(0xff737373);
                          }
                        });
                      },
                      icon: Icon(
                        _reverseArrowDirection
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
//                        color: dropColor,
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
