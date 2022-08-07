import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:image_picker/image_picker.dart';

class AdminSubCategoriesScreen extends StatefulWidget {
  AdminSubCategoriesScreen({Key? key, required this.mainCategoryTitle})
      : super(key: key);
  String mainCategoryTitle;
  @override
  State<AdminSubCategoriesScreen> createState() =>
      _AdminSubCategoriesScreenState();
}

class _AdminSubCategoriesScreenState extends State<AdminSubCategoriesScreen> {
  var deleteId;
  var updateId;

  Future<void> deleteData(id) {
    return FirebaseFirestore.instance
        .collection(widget.mainCategoryTitle)
        .doc(id)
        .delete()
        .then((value) => print('Data deleted '))
        .catchError((error) => print('Failed to delete Data $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: blackColor),
        ),
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'SubCategories ',
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
                  .collection(widget.mainCategoryTitle)
                  .orderBy('priority', descending: false)
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
                final List storeSubCategories = [];

                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  storeSubCategories.add(id);
                  id['id'] = document.id;
                }).toList();
                return Column(
//                            shrinkWrap: true,
                  children: [
                    storeSubCategories.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text('No SubCategory Find'),
                          )
                        : Container(),
                    for (int i = 0; i < storeSubCategories.length; i++) ...[
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: SwipeActionCell(
                            key: ObjectKey(storeSubCategories[i]['Created AT']),
                            leadingActions: [
                              SwipeAction(
                                title: "Edit",
                                style:
                                    TextStyle(fontSize: 12, color: whiteColor),
                                color: Colors.green,
                                icon: Icon(Icons.edit, color: whiteColor),
                                onTap: (CompletionHandler handler) async {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateRequestSubCategory(
                                                  mainCategoryTitle:
                                                      widget.mainCategoryTitle,
                                                  isCallForUpdate: true,
                                                  docId: storeSubCategories[i]
                                                      ['id']),
                                        ));
                                  });
                                },
                              ),
                            ],
                            trailingActions: [
                              SwipeAction(
                                title: "Delete",
                                style:
                                    TextStyle(fontSize: 12, color: whiteColor),
                                color: Colors.red,
                                icon: Icon(Icons.delete, color: whiteColor),
                                onTap: (CompletionHandler handler) async {
                                  deleteId = storeSubCategories[i]['id'];
                                  openDeleteDialog(
                                      deleteId,
                                      storeSubCategories[i]['SubCategory Name'],
                                      storeSubCategories[i]
                                          ['SubCategory Image URL']);

                                  setState(() {});
                                },
                              ),
                            ],
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  storeSubCategories[i]
                                              ['SubCategory Image URL'] ==
                                          ''
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
                                                  '${storeSubCategories[i]['Category Image URL']}'),
                                            ),
                                          ),
                                        );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: storeSubCategories[i]
                                              ['SubCategory Image URL'] !=
                                          ''
                                      ? FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.network(
                                            '${storeSubCategories[i]['SubCategory Image URL']}',
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
                              title: Text(
                                  '${storeSubCategories[i]['SubCategory Name']}',
                                  style: const TextStyle(
                                      overflow: TextOverflow.fade,
                                      fontWeight: FontWeight.bold)),
                            ),
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
                builder: (context) => CreateRequestSubCategory(
                    mainCategoryTitle: widget.mainCategoryTitle,
                    isCallForUpdate: false,
                    docId: 'NULL'),
              ));
        },
        tooltip: 'Add new SubCategory',
        backgroundColor: lightPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  openDeleteDialog(String id, String title, String imageUrl) => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            var width = MediaQuery.of(context).size.width;
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              title: const Center(child: Text('Delete SubCategory')),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: width,
                  height: 80.0,
                  child: Center(
                      child: Column(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.fade)),
                      ),
                      const Text('Do you want to delete sub-category'),
                      const Text('Deleted sub-category cannot be recovered',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 10,
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
                    //Delete a task
                    await FirebaseStorage.instance
                        .refFromURL(imageUrl)
                        .delete();
                    await deleteData(deleteId);
                    await Fluttertoast.showToast(
                      msg: 'SubCategory delete successfully', // message
                      toastLength: Toast.LENGTH_SHORT, // length
                      gravity: ToastGravity.BOTTOM, // location
                      backgroundColor: Colors.green,
                    );
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                  child: const Text(
                    'DELETE',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class CreateRequestSubCategory extends StatefulWidget {
  static const String id = 'CreateRequestCategory';
  CreateRequestSubCategory(
      {Key? key,
      required this.mainCategoryTitle,
      required this.docId,
      required this.isCallForUpdate})
      : super(key: key);
  String mainCategoryTitle;
  bool isCallForUpdate;
  String docId;
  @override
  State<CreateRequestSubCategory> createState() =>
      _CreateRequestSubCategoryState();
}

class _CreateRequestSubCategoryState extends State<CreateRequestSubCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _subCategoryController = TextEditingController();
  final _priorityController = TextEditingController();

  String _imagePath = '';
  File? image;
  var imageUrl;
  bool _isUploading = false;
  String requestSubCategory = '';
  String requestSubCategoryImageURL = '';
  String categoryPriority = '';
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
        requestSubCategoryImageURL = 'NULL';
      });
      print('------------------------------------');
      print('Image path : $_imagePath');
      if (isUpdatedSelected) {
        await FirebaseStorage.instance
            .refFromURL(requestSubCategoryImageURL)
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
    Reference ref = storage.ref().child(
        "SubCategory Images/$currentUserId -- ${_subCategoryController.text}");
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
    Reference ref = storage.ref().child(
        "SubCategory Images/$currentUserId -- ${_subCategoryController.text}");
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

  Future<void> addSubCategory(String subCategory) {
    return FirebaseFirestore.instance
        .collection('${widget.mainCategoryTitle}')
        .add({
          'Created AT': DateTime.now(),
          'User Email': currentUserEmail.toString(),
          'SubCategory Name': subCategory,
          'SubCategory Image URL': imageUrl.toString(),
          'SubCategory Image Id':
              '$currentUserId -- ${_subCategoryController.text}',
          'priority': _priorityController.text,
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
          .collection(widget.mainCategoryTitle)
          .doc(widget.docId)
          .get()
          .then((ds) {
        requestSubCategory = ds['SubCategory Name'];
        requestSubCategoryImageURL = ds['SubCategory Image URL'];
        categoryPriority = ds['priority'];
      });
      setState(() {
        requestSubCategory = requestSubCategory;
        requestSubCategoryImageURL = requestSubCategoryImageURL;
        imageUrl = requestSubCategoryImageURL;
        _subCategoryController.text = requestSubCategory;
        _priorityController.text = categoryPriority;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateData(id, String category, String categoryImageUrl) {
    return FirebaseFirestore.instance
        .collection(widget.mainCategoryTitle)
        .doc(id)
        .update({
          'Created AT': DateTime.now(),
          'User Email': currentUserEmail.toString(),
          'SubCategory Name': category,
          'SubCategory Image URL': categoryImageUrl,
          'SubCategory Image Id':
              '$currentUserId -- ${_subCategoryController.text}',
          'priority': _priorityController.text,
        })
        .then((value) => print('Data Update Successfully '))
        .catchError((error) => print('Failed to Update Data $error'));
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
                        ? 'Update SubCategory'
                        : 'Create new SubCategory',
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
                    requestSubCategoryImageURL.isNotEmpty
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              image == null
                                  ? ClipOval(
                                      child: Image.network(
                                        requestSubCategoryImageURL,
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
                  child: Column(
                    children: [
                      TextFormField(
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
                            borderSide:
                                BorderSide(color: lightPurple, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            // borderSide:
                            // BorderSide(color: lightPurple, width: 1.5),
                          ),

                          hintText: widget.isCallForUpdate
                              ? requestSubCategory
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
                        controller: _subCategoryController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter category';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
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
                              borderSide:
                                  BorderSide(color: lightPurple, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              // borderSide:
                              // BorderSide(color: lightPurple, width: 1.5),
                            ),

                            hintText: widget.isCallForUpdate
                                ? _priorityController.text
                                : 'Enter Category Priority',
                            labelText: 'Category Priority',
//                           hintStyle: TextStyle(color: ),

                            labelStyle: TextStyle(color: blackColor),
                            prefixIcon: Icon(
                              Icons.numbers_sharp,
                              color: blackColor,
                            ),
                            prefixText: '  ',
                          ),
                          controller: _priorityController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter category priority';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                  onPressed: widget.isCallForUpdate
                      ? () async {
                          if (requestSubCategoryImageURL != 'NULL') {
                          } else if (image == null) {
                            await Fluttertoast.showToast(
                              msg: 'Select an image', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              backgroundColor: Colors.grey,
                            );
                          }

                          if (_formKey.currentState!.validate()) {
                            if (requestSubCategoryImageURL != 'NULL') {
                              await updateData(
                                  widget.docId,
                                  _subCategoryController.text,
                                  requestSubCategoryImageURL);
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
                                  _subCategoryController.text,
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
                            _subCategoryController.clear();
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
                            await addSubCategory(_subCategoryController.text);
                            await Fluttertoast.showToast(
                              msg: 'Category created successfully', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              backgroundColor: Colors.green,
                            );
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            _subCategoryController.clear();
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
            color: Colors.black54,
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
