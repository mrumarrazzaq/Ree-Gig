import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/requestion_section/request_screen.dart';

class RequestCategorySelection extends StatefulWidget {
  const RequestCategorySelection({Key? key}) : super(key: key);

  @override
  State<RequestCategorySelection> createState() =>
      _RequestCategorySelectionState();
}

class _RequestCategorySelectionState extends State<RequestCategorySelection> {
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
                  text: 'Category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Categories')
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
                final List storeCategories = [];
                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  storeCategories.add(id);
                  id['id'] = document.id;
                }).toList();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    storeCategories.isEmpty
                        ? const Text('No Category Find')
                        : Container(),
                    for (int i = 0; i < storeCategories.length; i++) ...[
                      Card(
                        elevation: 0.5,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              getValue.category.value =
                                  storeCategories[i]['Category Name'];
                            });

                            Navigator.pop(context);
                          },
                          title: Text(storeCategories[i]['Category Name']),
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
      ),
    );
  }
}
