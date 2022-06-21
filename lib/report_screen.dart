import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ree_gig/home_screen.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:lottie/lottie.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController reportTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? validateReportText(value) {
    if (value.isEmpty) {
      return 'Please enter something';
    } else {
      return null;
    }
  }

  String personName = '';

  fetch() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user!.email);
    print('-------------------------------------');
    print('Current user data is fetching');
    try {
      await FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.email)
          .get()
          .then((ds) {
        personName = ds['personName'];
      });
      setState(() {
        personName = personName;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  CollectionReference report = FirebaseFirestore.instance.collection('Reports');
  Future<void> addReport() {
    return report
        .add({
          'Created At': currentDateTime,
          'Report Text': reportTextController.text,
          'User Email': currentUserEmail,
          'User Name': personName,
        })
        .then((value) => print('Report Added by email : $currentUserEmail'))
        .catchError((error) => print('Faild to Add Report $error'));
  }

  @override
  void initState() {
    fetch();
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
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: SizedBox(
              child: Lottie.asset('animations/report.json'),
              width: 250,
              height: 250,
            ),
          ),
          const Center(
            child: Text('What is your issue ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, bottom: 10.0, top: 15.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Type Something',
//                labelText: 'Password',
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: darkPurple, width: 2.0),
                  ),
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 18),

                  prefixText: '  ',
                ),
                controller: reportTextController,
                validator: validateReportText,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Material(
              color: lightPurple,
              borderOnForeground: true,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                minWidth: 200.0,
                height: 40.0,
                elevation: 2.0,
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 50.0),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addReport();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        content: SizedBox(
                          height: 280,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 100,
                                  height: 120,
                                  child: Image.asset('images/clock.png')),
                              const Text(
                                "Thank you for your feedback \nWe'll get back to you soon!",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Material(
                                  color: lightPurple,
                                  borderOnForeground: true,
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: MaterialButton(
                                    minWidth: 280.0,
                                    height: 40.0,
                                    elevation: 2.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 50.0),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ),
                                          (route) => false);
                                    },
                                    child: Text(
                                      'Back to the Home Page',
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
                child: Text(
                  'Report',
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
