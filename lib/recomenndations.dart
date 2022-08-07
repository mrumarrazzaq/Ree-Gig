import 'package:flutter/material.dart';
import 'package:ree_gig/home_screen.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/requestion_section/request_screen.dart';

class Recommendations extends StatefulWidget {
  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  String _selectedCategory = 'Select Recommendation';
  List<bool> checkBoxValue = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> categoriesList = [
    'Admin',
    'Finanace & Account',
    'Art & Crafts',
    'Freelance',
    'Education',
    'Cleaning Service',
    'Food & Beverages',
    'Construction',
    'House Related',
    'Business',
    'IT',
    'Events',
    'Recruitment',
    'Logistics',
    'Fashion',
    'Others'
  ];
  readRecommendation() async {
    _selectedCategory = await readUserRecommendations();
    setState(() {
      _selectedCategory = _selectedCategory;
    });
  }

  @override
  void initState() {
    readRecommendation();
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
                  text: 'Recommendations',
                  style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(text: '', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back),
//            onPressed: () {
//              checkAllFalse();
//            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text.rich(
                TextSpan(
                  text: '', // default text style

                  children: <TextSpan>[
                    TextSpan(
                        text: 'Select Your Recommendation\n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    TextSpan(
                        text:
                            'This will help you in recommendations of the requests',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),
            MyInputField(
              icon: Icons.category,
              hint: _selectedCategory,
              widget: DropdownButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: lightPurple,
                ),
                iconSize: 25,
                elevation: 4,
                underline: Container(
                  height: 0.0,
                ),
                items: categoriesList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  },
                ).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                    saveUserRecommendations(_selectedCategory);
                    print(newValue);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                        (route) => false);
                  });
                },
              ),
            ),
          ],
        ),
//        Column(
//          children: [
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[0],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[0] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[0]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[1],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[1] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[1]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[2],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[2] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[2]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[3],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[3] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[3]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[4],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[4] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[4]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[5],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[5] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[5]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[6],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[6] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[6]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[7],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[7] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[7]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[8],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[8] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[8]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[9],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[9] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[9]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[10],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[10] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[10]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[11],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[11] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[11]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[12],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[12] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[12]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[13],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[13] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[13]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[14],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[14] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[14]),
//            ),
//            ListTile(
//              leading: Checkbox(
//                value: checkBoxValue[15],
//                activeColor: lightPurple,
//                onChanged: (value) {
//                  setState(() {
//                    print('--------------------$value');
//                    checkBoxValue[15] = value!;
//                  });
//                },
//              ),
//              title: Text(categoriesList[15]),
//            ),
//          ],
//        ),
      ),
    );
  }
}
