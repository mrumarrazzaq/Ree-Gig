import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';
import 'package:ree_gig/search_screen.dart';

class HomeScreenOptions extends StatefulWidget {
  HomeScreenOptions({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  _HomeScreenOptionsState createState() => _HomeScreenOptionsState();
}

class _HomeScreenOptionsState extends State<HomeScreenOptions> {
  final Stream<QuerySnapshot> _dailyUpdated =
      FirebaseFirestore.instance.collection('Requests').snapshots();
  // String _imagePath = '';
  // File? image;
  // var imageUrl;
  bool _isVisibleBottomNavigation = false;
  readUserMode() async {
    var _value = await readMode();
    print('--------------------------');
    print(_value);
    print('--------------------------');

    setState(() {
      _isVisibleBottomNavigation = _value;
      if (_value == true) {
        print('Freelancer Mode is set');
        print('Enable Bottom Navigation set to $_isVisibleBottomNavigation');
      } else {
        print('User Mode is set');
        print('Disable Bottom Navigation set to $_isVisibleBottomNavigation');
      }
    });
  }

  @override
  void initState() {
    readUserMode();
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
//        actions: const [
//          IconButton(
//            icon: Icon(
//              Icons.settings_outlined,
//              color: Colors.white,
//            ),
//            onPressed: null,
////                () => Scaffold.of(context).openDrawer()
//          ),
//        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: darkPurple,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 15.0, top: 2.0),
                      child: GestureDetector(
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: whiteColor, size: 20),
                                const SizedBox(width: 10.0),
                                Text(widget.title,
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 15)),
                              ],
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: lightPurple,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HomeCircularOptions(title: '1000'),
                            HomeCircularOptions(title: '1001'),
                            HomeCircularOptions(title: '1002'),
                            HomeCircularOptions(title: '1003'),
                            HomeCircularOptions(title: '1004'),
                            HomeCircularOptions(title: '1005'),
                            HomeCircularOptions(title: '1006'),
                            HomeCircularOptions(title: '1007'),
                            HomeCircularOptions(title: '1008'),
                            Container(
                              width: 50,
                              height: 50,
                              margin: const EdgeInsets.only(
                                  right: 10.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  modalBottomSheetMenu();
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                ),
                child: StreamBuilder<QuerySnapshot>(
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
//                        print('==============================================');
//                        print(storeRequests);
//                        print('Document id : ${document.id}');
                        id['id'] = document.id;
                      }).toList();
                      return ListView(
                        children: [
                          storeRequests.isEmpty
                              ? const Text('No daily Update')
                              : Container(),
                          for (int i = 0; i < storeRequests.length; i++) ...[
                            storeRequests[i]['Selected Category'] ==
                                    widget.title
                                ? CustomContainer1(
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
                                    location: storeRequests[i]
                                        ['Current Address'],
                                    innerBorder: 20.0,
                                    smallBoxWidth: 110,
                                    smallBoxHeight: 80)
                                : Container(),
//                      CustomPoster(
//                      name: storeRequests[i]['User Name'],
//                      email: storeRequests[i]['User Email'],
//                      url: storeRequests[i]['Profile Image URL'],
//                      category: storeRequests[i]['Selected Category'],
//                      requestTitle: storeRequests[i]['Request Title'],
//                      description: storeRequests[i]['Request Description'],
//                      imagePath: storeRequests[i]['Request Image URL'],
//                      location: storeRequests[i]['Current Address'],
//                      imageType: 'Network',
//                      ),
                          ],
                        ],
                      );
                    }),
//                ListView(
////                  shrinkWrap: true,
//                  children: [
//                    CustumContainer(
//                        title: 'Mobile Design Team',
//                        description:
//                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
//                        imagePath: '',
//                        caption: 'USA',
//                        innerBorder: 20.0,
//                        smallBoxWidth: 110,
//                        smallBoxHeight: 80),
//                    CustumContainer(
//                        title: 'Mobile Design Team',
//                        description:
//                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
//                        imagePath: '',
//                        innerBorder: 20.0,
//                        caption: 'Jamika',
//                        smallBoxWidth: 110,
//                        smallBoxHeight: 80),
//                    CustumContainer(
//                        title: 'Mobile Design Team',
//                        description:
//                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
//                        imagePath: '',
//                        caption: 'Abudabi',
//                        innerBorder: 20.0,
//                        smallBoxWidth: 110,
//                        smallBoxHeight: 80),
//                  ],
//                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
          visible: _isVisibleBottomNavigation,
          child: const CustomNavigationBar()),
    );
  }

  modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 250.0,
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Add New Item',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0)),
                    ),
                    GestureDetector(
                      onTap: () {
                        // pickImage(ImageSource.gallery);
                      },
                      child: CircleAvatar(
                        // radius: 50.0,
                        minRadius: 50.0,
                        backgroundColor: Colors.grey[400],
                        child: Icon(
                          Icons.add,
                          size: 50.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
    //  pickImage(ImageSource source) async {
    //   try {
    //     final image = await ImagePicker().pickImage(source: source);
    //     if (image == null) return;
    //
    //     final imageTemporary = File(image.path);
    //     setState(() {
    //       this.image = imageTemporary;
    //     });
    //     _imagePath = image.path;
    //
    //     setState(() {
    //
    //     });
    //     print('------------------------------------');
    //     print('Image path : $_imagePath');
    //
    //     // ignore: unused_catch_clause
    //   } catch (e) {
    //     print('Pick image from gallery fail');
    //   }
    // }
    // uploadImage(String path) async {
    //   print('Image is Uploading...');
    //   FirebaseStorage storage = FirebaseStorage.instance;
    //   Reference ref = storage
    //       .ref()
    //       .child("Category Images/$currentUserId -- ${_categoryController.text}");
    //   UploadTask uploadTask = ref.putFile(File(path));
    //   await uploadTask.whenComplete(() async {
    //     String url = await ref.getDownloadURL();
    //     print('----------------------------------');
    //     print('Image URL : $url');
    //     print('----------------------------------');
    //
    //     _isUploading = false;
    //     setState(() {
    //       imageUrl = url;
    //     });
    //   }).catchError((onError) {
    //     print('---------------------------------------');
    //     print('Error while uploading image');
    //     print(onError);
    //     print('---------------------------------------');
    //   });
    // }
  }
}

class HomeCircularOptions extends StatelessWidget {
  HomeCircularOptions({Key? key, required this.title}) : super(key: key);
  String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
          ),
          const SizedBox(height: 5.0),
          Text(title, style: TextStyle(color: whiteColor)),
        ],
      ),
      onTap: () {},
    );
  }
}

//class SearchField extends StatelessWidget {
////  final String title;
//  final String hint;
////  final TextEditingController? controller;
//  final Widget? widget;
//
//  SearchField({required this.hint, this.widget});
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      margin: const EdgeInsets.only(top: 16.0),
//      child: Container(
//        height: 52.0,
//        margin: EdgeInsets.only(top: 8.0),
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.white, width: 1.0),
//          borderRadius: BorderRadius.circular(50.0),
//        ),
//        child: Row(
//          children: [
//            Expanded(
//              child: Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                child: TextFormField(
//                  autofocus: false,
//                  decoration: InputDecoration(
//                      hintText: hint,
//                      hintStyle: TextStyle(color: whiteColor),
//                      fillColor: lightPurple,
//                      prefixIcon: const Icon(Icons.search),
//                      prefixIconColor: whiteColor,
//                      focusedBorder: const UnderlineInputBorder(
//                        borderSide: BorderSide(
//                          color: Colors.white,
//                          width: 0,
//                        ),
//                      ),
//                      enabledBorder: const UnderlineInputBorder(
//                        borderSide: BorderSide(
//                          color: Colors.white,
//                          width: 0,
//                        ),
//                      )),
//                ),
//              ),
//            ),
//            Container(
//              child: widget,
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
