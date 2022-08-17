import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ree_gig/project_constants.dart';

class RequestSubCategorySelection extends StatefulWidget {
  RequestSubCategorySelection({Key? key, required this.category})
      : super(key: key);
  String category;
  @override
  State<RequestSubCategorySelection> createState() =>
      _RequestSubCategorySelectionState();
}

class _RequestSubCategorySelectionState
    extends State<RequestSubCategorySelection> {
  String value = '';
  final Controller getValue = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(''),
        backgroundColor: whiteColor,
        title: const Text.rich(
          TextSpan(
            text: '',
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: 'Select  ',
                  style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(
                  text: 'SubCategory',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(widget.category)
              .orderBy('priority', descending: false)
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
            if (snapshot.hasData) {
              final List storeSubCategories = [];
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map id = document.data() as Map<String, dynamic>;
                storeSubCategories.add(id);
                id['id'] = document.id;
              }).toList();
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  storeSubCategories.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 100.0),
                          child: Center(child: Text('No Sub Category Find')),
                        )
                      : Container(),
                  for (int i = 0; i < storeSubCategories.length; i++) ...[
                    Card(
                      elevation: 0.5,
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            getValue.subCategory.value =
                                storeSubCategories[i]['SubCategory Name'];
                          });
                          Navigator.pop(context);
                        },
                        title: Text(storeSubCategories[i]['SubCategory Name']),
                      ),
                    ),
                  ],
                ],
              );
            }
            return Center(
                child: CircularProgressIndicator(
              color: lightPurple,
              strokeWidth: 2.0,
            ));
          }),
    );
  }
}

class CustomCard extends StatefulWidget {
  CustomCard({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  IconData _iconData = Icons.check_box_outline_blank;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      child: ListTile(
        title: Text(widget.title),
        trailing: IconButton(
            onPressed: () {
              setState(() {
                if (_iconData == Icons.check_box) {
                  _iconData = Icons.check_box_outline_blank_outlined;
                } else {
                  _iconData = Icons.check_box;
                }
              });
            },
            icon: Icon(_iconData, size: 16)),
      ),
    );
  }
}
