import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:image_picker/image_picker.dart';

class AdminCategoriesScreen extends StatefulWidget {
  static const String id = 'AdminCategoriesScreen';
  const AdminCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  var deleteId;
  var updateId;

  Future<void> deleteData(id) {
    return FirebaseFirestore.instance
        .collection('Categories')
        .doc(id)
        .delete()
        .then((value) => print('Data deleted '))
        .catchError((error) => print('Failed to delete Data $error'));
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
                  text: 'Categories ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              TextSpan(
                  text: 'Section',
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
              stream: FirebaseFirestore.instance
                  .collection('Categories')
                  .orderBy('Created AT', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('Something went wrong');
                  return Center(
                      child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: lightPurple,
                      strokeWidth: 2.0,
                    ),
                  ));
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
                final List storeCategories = [];

                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  storeCategories.add(id);
//                  print('==============================================');
//                  print(storeRequests);
//                  print('Document id : ${document.id}');
                  id['id'] = document.id;
                }).toList();
                return Column(
//                            shrinkWrap: true,
                  children: [
                    storeCategories.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text('No Category Find'),
                          )
                        : Container(),
                    for (int i = 0; i < storeCategories.length; i++) ...[
                      GestureDetector(
                        onTap: () {
                          storeCategories[i]['imageUrl'] == ''
                              ? null
                              : showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    content: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.network(
                                          '${storeCategories[i]['Category Image URL']}'),
                                    ),
                                  ),
                                );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 20.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: storeCategories[i]
                                                  ['Category Image URL'] !=
                                              ''
                                          ? FittedBox(
                                              fit: BoxFit.fill,
                                              child: Image.network(
                                                '${storeCategories[i]['Category Image URL']}',
                                                width: 50,
                                                height: 50,
                                              ),
                                            )
                                          : FittedBox(
                                              fit: BoxFit.fill,

                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                color: Colors.grey,
                                              ),
//                                width: double.infinity,
                                            ),
                                    ),
                                  ),
                                  Text('${storeCategories[i]['Category Name']}',
                                      style: const TextStyle(
                                          overflow: TextOverflow.fade,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      updateId = storeCategories[i]['id'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateRequestCategory(
                                                    isCallForUpdate: true,
                                                    docId: updateId),
                                          ));
                                    },
                                    splashColor: lightPurple.withOpacity(0.2),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      deleteId = storeCategories[i]['id'];
                                      await FirebaseStorage.instance
                                          .refFromURL(storeCategories[i]
                                              ['Category Image URL'])
                                          .delete();
                                      await deleteData(deleteId);
                                      await Fluttertoast.showToast(
                                        msg:
                                            'Category delete successfully', // message
                                        toastLength:
                                            Toast.LENGTH_SHORT, // length
                                        gravity:
                                            ToastGravity.BOTTOM, // location
                                        backgroundColor: Colors.green,
                                      );
                                    },
                                    splashColor: lightPurple.withOpacity(0.2),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateRequestCategory(
                    isCallForUpdate: false, docId: 'NULL'),
              ));
//           showDialog(
//               context: context,
//               builder: (context) {
// //                 return AlertDialog(
// //                   title: const Center(child: Text('Create a new category')),
// //                   content: AnimatedContainer(
// //                       duration: const Duration(milliseconds: 300),
// //                       height: 200,
// //                       child: SingleChildScrollView(
// //                         child: Column(
// //                           children: [
// //                             image != null
// //                                 ? ClipOval(
// //                                     child: Image.file(
// //                                       image!,
// //                                       fit: BoxFit.fill,
// //                                       width: 100,
// //                                       height: 100,
// //                                     ),
// //                                   )
// //                                 : GestureDetector(
// //                                     onTap: () {
// //                                       pickImage(ImageSource.camera);
// //                                     },
// //                                     child: CircleAvatar(
// //                                       // radius: 50.0,
// //                                       minRadius: 50.0,
// //                                       backgroundColor: Colors.grey[400],
// //                                       child: Icon(
// //                                         Icons.add,
// //                                         color: Colors.grey[700],
// //                                       ),
// //                                     ),
// //                                   ),
// //                             Padding(
// //                               padding: const EdgeInsets.only(top: 10.0),
// //                               child: Form(
// //                                 key: _formKey,
// //                                 child: TextFormField(
// //                                   keyboardType: TextInputType.text,
// //                                   cursorColor: blackColor,
// //                                   style: TextStyle(color: blackColor),
// //                                   decoration: InputDecoration(
// //                                     isDense: true,
// //                                     // fillColor: lightPurple,
// //                                     // filled: true,
// //                                     border: OutlineInputBorder(
// //                                       borderRadius: BorderRadius.circular(5.0),
// //                                     ),
// //                                     focusedBorder: OutlineInputBorder(
// //                                       borderRadius: BorderRadius.circular(5.0),
// //                                       borderSide: BorderSide(
// //                                           color: lightPurple, width: 1.5),
// //                                     ),
// //                                     enabledBorder: OutlineInputBorder(
// //                                       borderRadius: BorderRadius.circular(5.0),
// //                                       // borderSide:
// //                                       // BorderSide(color: lightPurple, width: 1.5),
// //                                     ),
// //
// //                                     hintText: 'Enter Request Category',
// //                                     labelText: 'Request Category',
// // //                           hintStyle: TextStyle(color: ),
// //
// //                                     labelStyle: TextStyle(color: blackColor),
// //                                     prefixIcon: Icon(
// //                                       Icons.category,
// //                                       color: blackColor,
// //                                     ),
// //                                     prefixText: '  ',
// //                                   ),
// //                                   controller: _categoryController,
// //                                   validator: (value) {
// //                                     if (value!.isEmpty) {
// //                                       return 'Please Enter category';
// //                                     }
// //                                   },
// //                                 ),
// //                               ),
// //                             ),
// //                             Visibility(
// //                               visible: _isVisible,
// //                               child: Row(
// //                                 children: [
// //                                   IconButton(
// //                                     icon: Icon(Icons.camera_alt),
// //                                     onPressed: () {},
// //                                   ),
// //                                   IconButton(
// //                                     icon: Icon(Icons.camera),
// //                                     onPressed: () {},
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       )),
// //                   scrollable: true,
// //                   actions: [
// //                     TextButton(
// //                         onPressed: () {
// //                           Navigator.pop(context);
// //                         },
// //                         child: const Text(
// //                           'Cancel',
// //                           style: TextStyle(color: Colors.red),
// //                         )),
// //                     TextButton(
// //                         onPressed: () {
// //                           if (_formKey.currentState!.validate()) {
// //                             Navigator.pop(context);
// //                           }
// //                         },
// //                         child: const Text(
// //                           'Create',
// //                           style: TextStyle(color: Colors.green),
// //                         )),
// //                   ],
// //                 );
//               });
        },
        tooltip: 'Add new Category',
        backgroundColor: lightPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateRequestCategory extends StatefulWidget {
  static const String id = 'CreateRequestCategory';
  CreateRequestCategory(
      {Key? key, required this.docId, required this.isCallForUpdate})
      : super(key: key);
  bool isCallForUpdate;
  String docId;
  @override
  State<CreateRequestCategory> createState() => _CreateRequestCategoryState();
}

class _CreateRequestCategoryState extends State<CreateRequestCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();

  String _imagePath = '';
  File? image;
  var imageUrl;
  bool _isUploading = false;
  String requestCategory = '';
  String requestCategoryImageURL = '';
  Future pickImage(ImageSource source, bool isUpdatedSelected) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
      _imagePath = image.path;

      setState(() {
        requestCategoryImageURL = 'NULL';
      });
      print('------------------------------------');
      print('Image path : $_imagePath');
      if (isUpdatedSelected) {
        await FirebaseStorage.instance
            .refFromURL(requestCategoryImageURL)
            .delete();
        print('==================================');
        print('previous image delete successfully');
        print('==================================');
      }
      // ignore: unused_catch_clause
    } catch (e) {
      print('Pick image from gallery fail');
    }
  }

  uploadImage(String path) async {
    print('Image is Uploading...');
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("Category Images/$currentUserId -- ${_categoryController.text}");
    UploadTask uploadTask = ref.putFile(File(path));
    await uploadTask.whenComplete(() async {
      String url = await ref.getDownloadURL();
      print('----------------------------------');
      print('Image URL : $url');
      print('----------------------------------');

      _isUploading = false;
      setState(() {
        imageUrl = url;
      });
    }).catchError((onError) {
      print('---------------------------------------');
      print('Error while uploading image');
      print(onError);
      print('---------------------------------------');
    });
  }

  uploadNewImage(String path) async {
    print('Image is Uploading...');

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("Category Images/$currentUserId -- ${_categoryController.text}");
    UploadTask uploadTask = ref.putFile(File(path));
    await uploadTask.whenComplete(() async {
      String url = await ref.getDownloadURL();
      print('----------------------------------');
      print('Image URL : $url');
      print('----------------------------------');

      _isUploading = false;
      setState(() {
        imageUrl = url;
      });
    }).catchError((onError) {
      print('---------------------------------------');
      print('Error while uploading image');
      print(onError);
      print('---------------------------------------');
    });
  }

  Future<void> addCategory(String category) {
    return FirebaseFirestore.instance
        .collection('Categories')
        .add({
          'Created AT': DateTime.now(),
          'User Email': currentUserEmail.toString(),
          'Category Name': category,
          'Category Image URL': imageUrl.toString(),
          'Category Image Id': '$currentUserId -- ${_categoryController.text}',
        })
        .then(
            (value) => print('Category Added Successfully : $currentUserEmail'))
        .catchError((error) => print('Failed to Add Category $error'));
  }

  fetchData() async {
    print('-------------------------------------');
    print('Category data is fetching');
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.docId)
          .get()
          .then((ds) {
        requestCategory = ds['Category Name'];
        requestCategoryImageURL = ds['Category Image URL'];
      });
      setState(() {
        requestCategory = requestCategory;
        requestCategoryImageURL = requestCategoryImageURL;
        imageUrl = requestCategoryImageURL;
        _categoryController.text = requestCategory;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateData(id, String category, String categoryImageUrl) {
    return FirebaseFirestore.instance
        .collection('Categories')
        .doc(id)
        .update({
          'Created AT': DateTime.now(),
          'User Email': currentUserEmail.toString(),
          'Category Name': category,
          'Category Image URL': categoryImageUrl,
          'Category Image Id': '$currentUserId -- ${_categoryController.text}',
        })
        .then((value) => print('Data deleted '))
        .catchError((error) => print('Failed to delete Data $error'));
  }

  @override
  void initState() {
    if (widget.docId != 'NULL') {
      fetchData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text.rich(
            TextSpan(
              text: '', // default text style
              children: <TextSpan>[
                TextSpan(
                    text: widget.isCallForUpdate
                        ? 'Update new category'
                        : 'Create new category',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
          backgroundColor: neuColor,
          leading: IconButton(
              onPressed: () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 20.0,
                color: blackColor,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: !widget.isCallForUpdate,
                child: Column(
                  children: [
                    image != null
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipOval(
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.fill,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              Positioned.fill(
                                top: 50.0,
                                left: 70.0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: lightPurple,
                                    radius: 45,
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            modalBottomSheet();
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            size: 20.0,
                                            color: whiteColor,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isUploading,
                                child: CircularProgressIndicator(
                                  backgroundColor: whiteColor,
                                  color: lightPurple,
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              modalBottomSheet();
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
              Visibility(
                visible: widget.isCallForUpdate,
                child: Column(
                  children: [
                    requestCategoryImageURL.isNotEmpty
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              image == null
                                  ? ClipOval(
                                      child: Image.network(
                                        requestCategoryImageURL,
                                        fit: BoxFit.fill,
                                        width: 100,
                                        height: 100,
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.file(
                                        image!,
                                        fit: BoxFit.fill,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                              Positioned.fill(
                                top: 50.0,
                                left: 70.0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: lightPurple,
                                    radius: 45,
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            modalBottomSheet();
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            size: 20.0,
                                            color: whiteColor,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isUploading,
                                child: CircularProgressIndicator(
                                  backgroundColor: whiteColor,
                                  color: lightPurple,
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              modalBottomSheet();
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
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    cursorColor: blackColor,
                    style: TextStyle(color: blackColor),
                    decoration: InputDecoration(
                      isDense: true,
                      // fillColor: lightPurple,
                      // filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: lightPurple, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        // borderSide:
                        // BorderSide(color: lightPurple, width: 1.5),
                      ),

                      hintText: widget.isCallForUpdate
                          ? requestCategory
                          : 'Enter Request Category',
                      labelText: 'Request Category',
//                           hintStyle: TextStyle(color: ),

                      labelStyle: TextStyle(color: blackColor),
                      prefixIcon: Icon(
                        Icons.category,
                        color: blackColor,
                      ),
                      prefixText: '  ',
                    ),
                    controller: _categoryController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter category';
                      }
                    },
                  ),
                ),
              ),
              MaterialButton(
                  onPressed: widget.isCallForUpdate
                      ? () async {
                          if (requestCategoryImageURL != 'NULL') {
                          } else if (image == null) {
                            await Fluttertoast.showToast(
                              msg: 'Select an image', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              backgroundColor: Colors.grey,
                            );
                          }

                          if (_formKey.currentState!.validate()) {
                            if (requestCategoryImageURL != 'NULL') {
                              await updateData(
                                  widget.docId,
                                  _categoryController.text,
                                  requestCategoryImageURL);
                              setState(() {
                                _isUploading = false;
                              });
                            } else {
                              setState(() {
                                _isUploading = true;
                              });
                              await uploadNewImage(_imagePath);
                              await updateData(
                                  widget.docId,
                                  _categoryController.text,
                                  imageUrl.toString());
                              setState(() {
                                _isUploading = false;
                              });
                            }

                            await Fluttertoast.showToast(
                              msg: 'Category updated successfully', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              backgroundColor: Colors.green,
                            );
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            _categoryController.clear();
                            Navigator.pop(context);
                          }
                        }
                      : () async {
                          if (image == null) {
                            await Fluttertoast.showToast(
                              msg: 'Select an image', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              backgroundColor: Colors.grey,
                            );
                          }
                          if (_formKey.currentState!.validate() &&
                              image != null) {
                            setState(() {
                              _isUploading = true;
                            });

                            await uploadImage(_imagePath);
                            await addCategory(_categoryController.text);
                            await Fluttertoast.showToast(
                              msg: 'Category created successfully', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              backgroundColor: Colors.green,
                            );
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            _categoryController.clear();
                            Navigator.pop(context);
                          }
                        },
                  color: lightPurple,
                  child: Text(
                    widget.isCallForUpdate ? 'Update' : 'Create',
                    style: TextStyle(
                      color: whiteColor,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  modalBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 160.0,
            color: Colors.transparent,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Select Image',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.camera_alt, color: blackColor),
                      title: const Text('From Camera'),
                      onTap: () {
                        widget.isCallForUpdate
                            ? pickImage(ImageSource.camera, true)
                            : pickImage(ImageSource.camera, false);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.camera, color: blackColor),
                      title: const Text('From Gallery'),
                      onTap: () {
                        widget.isCallForUpdate
                            ? pickImage(ImageSource.gallery, true)
                            : pickImage(ImageSource.gallery, false);

                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
          );
        });
  }
}
