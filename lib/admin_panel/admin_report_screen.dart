import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ree_gig/project_constants.dart';

class AdminReportScreen extends StatefulWidget {
  static const String id = 'HistoryScreen';
  @override
  _AdminReportScreenState createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  final Stream<QuerySnapshot> _reports = FirebaseFirestore.instance
      .collection('Reports')
      .orderBy('Created At', descending: true)
      .snapshots();

  Future<void> deleteData(id) {
    return FirebaseFirestore.instance
        .collection('Reports')
        .doc(id)
        .delete()
        .then((value) => print('Data deleted '))
        .catchError((error) => print('Failed to delete Data $error'));
  }

  @override
  Widget build(BuildContext context) {
    print('Report Screen Build Running.....');
    return Scaffold(
      backgroundColor: neuColor,
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: '', // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Users ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              TextSpan(
                  text: 'Reports',
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
              stream: _reports,
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
                final List storeReports = [];

                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map id = document.data() as Map<String, dynamic>;
                  storeReports.add(id);
                  id['id'] = document.id;
                }).toList();
                print('Total Registered Reports ${storeReports.length}');
                saveReports(storeReports.length.toDouble());
                return Column(
//                            shrinkWrap: true,
                  children: [
                    storeReports.isEmpty
                        ? const Text('No report find')
                        : Container(),
                    for (int i = 0; i < storeReports.length; i++) ...[
                      SwipeActionCell(
                        key: ObjectKey(storeReports[i]['Created At']),
                        child: Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            side: BorderSide(width: 1, color: lightPink),
                          ),
                          child: ListTile(
                            title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${storeReports[i]['User Name']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('${storeReports[i]['User Email']}'),
                                  const Divider(),
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('${storeReports[i]['Report Text']}',
                                  textAlign: TextAlign.justify),
                            ),
                          ),
                        ),
                        trailingActions: [
                          SwipeAction(
                            title: "Delete",
                            style: TextStyle(fontSize: 12, color: whiteColor),
                            color: Colors.red,
                            icon: Icon(Icons.delete, color: whiteColor),
                            onTap: (CompletionHandler handler) async {
                              openDeleteDialog(storeReports[i]['id']);

                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              }),
        ],
      ),
    );
  }

  openDeleteDialog(String id) => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            var width = MediaQuery.of(context).size.width;
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              title: const Center(child: Text('Delete Report')),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: width,
                  height: 40.0,
                  child: Center(
                      child: Column(
                    children: const [
                      Text('Do you want to delete report'),
                      Text('Deleted report cannot be recovered',
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
                    await deleteData(id);
                    await Fluttertoast.showToast(
                      msg: 'Report delete successfully', // message
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
