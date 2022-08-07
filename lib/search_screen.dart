import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ree_gig/home_screen_options.dart';
import 'package:ree_gig/others_freelancer_profile.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/projects_customs.dart';
import 'package:ree_gig/requestion_section/request_screen.dart';
import 'package:ree_gig/saved_searches.dart';
import 'package:ree_gig/search_by_name.dart';

List<String> searchItems = [
  'Admin',
  'Finance & Account',
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
];

List<String> matchQuery = [];
List<Widget> widgetList = [];

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  String personName = '';
  String imageURL = '';
  String search = '';

  @override
  void initState() {
    readUserMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Search Screen buils is running');
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
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              // searchItems.clear();
              _searchController.clear();
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      darkPurple,
                      const Color(0xffcd87d6),
                    ],
                    begin: Alignment.topCenter,
//                    FractionalOffset(1.0, 1.5),
                    end: Alignment.bottomCenter,
//                    FractionalOffset(0.0, 0.5),
                    stops: [0.1, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Column(
                  children: [
                    //Search Field
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0, top: 2.0),
                      child: SizedBox(
                        height: 50.0,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.white,
                          style: TextStyle(color: whiteColor),
                          decoration: InputDecoration(
                            fillColor: lightPurple,
                            filled: true,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide(color: whiteColor, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide:
                                  BorderSide(color: lightPurple, width: 1.5),
                            ),
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: whiteColor),
                            prefixIcon: Icon(
                              Icons.search,
                              color: whiteColor,
                            ),
                            prefixText: '  ',
                          ),
                          controller: _searchController,
                          onChanged: searchQuery,
                        ),
                      ),
                    ),
                    //Two Options
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 130,
                              height: 80,
                              child: Center(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Other Users',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: const [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.red,
                                                  backgroundImage: NetworkImage(
                                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo8WDeyK9BF_o03I-tKU8M7-IkAULDWLS7WQ&usqp=CAU'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20.0),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      Colors.yellow,
                                                  backgroundImage: NetworkImage(
                                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtIAXuXcmjH9G6zzy2gTXwSN1Z0aFOiQWlhg&usqp=CAU'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 40.0),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzcbI2lRhCnQKHhYEOcin-UyT34WT8VtdBQA&usqp=CAU'),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 85.0, top: 10.0),
                                                child: Text(
                                                  'More',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                              decoration: BoxDecoration(
                                  color: const Color(0xffcd87d6),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchByName(),
                                ),
                              );
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              width: 130,
                              height: 80,
                              child: Center(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Icon(Icons.star),
                                      Text(
                                        'Saved Searches',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                              decoration: BoxDecoration(
                                  color: const Color(0xffcd87d6),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SavedSearches(),
                                ),
                              );
                            },
                          ),
                        ],
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
                child: matchQuery.length == 0
                    ? ListView.builder(
                        itemCount: searchItems.length,
                        itemBuilder: (context, index) {
//                      print(onTextSearch);
                          var item = searchItems[index];

                          return CustomCard(title: item);
                        },
                      )
                    : ListView.builder(
                        itemCount: matchQuery.length,
                        itemBuilder: (context, index) {
//                      print(onTextSearch);
                          var item = matchQuery[index];

                          return CustomCard(title: item);
                        },
                      ),
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

  void searchQuery(String query) {
    final suggessions = searchItems.where(
      (element) {
        final title = element.toLowerCase();
        final input = query.toLowerCase();

        return title.contains(input);
      },
    ).toList();

    setState(() {
      matchQuery = suggessions;
    });
  }

  void searchQueryByName(String query) {
    final suggessions = searchItems.where(
      (element) {
        final title = element.toLowerCase();
        final input = query.toLowerCase();

        return title.contains(input);
      },
    ).toList();

    setState(() {
      matchQuery = suggessions;
    });
  }
}

class CustomCard extends StatefulWidget {
  CustomCard({Key? key, required this.title}) : super(key: key);

  String title;
  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreenOptions(title: widget.title),
            ));
      },
      child: Card(
        elevation: 2.0,
        child: ListTile(
          title: Text(widget.title),
//            trailing: IconButton(
//              icon: const Icon(Icons.cancel_outlined),
//              onPressed: () {
//                setState(() {});
//              },
//            )),
        ),
      ),
    );
  }
}

//class CustomSearchDelegate extends SearchDelegate {
//  List<String> searchItems = [
//    'Admin',
//    'Finanace & Account',
//    'Art & Crafts',
//    'Freelance',
//    'Education',
//    'Cleaning Service',
//    'Food & Beverages',
//    'Construction',
//    'House Related',
//    'Business',
//    'IT',
//    'Events',
//    'Recruitment',
//    'Logistics',
//    'Fashion',
//  ];
//
//  @override
//  List<Widget>? buidActions(BuildContext context) {
//    return [
//      IconButton(
//        icon: const Icon(Icons.clear),
//        onPressed: () {
//          query = '';
//        },
//      ),
//    ];
//  }
//
//  @override
//  List<Widget>? buidLeading(BuildContext context) {
//    return [
//      IconButton(
//        icon: const Icon(Icons.arrow_back),
//        onPressed: () {
//          close(context, null);
//        },
//      ),
//    ];
//  }
//
//  @override
//  Widget buidResults(BuildContext context) {
//    List<String> matchQuery = [];
//    for (var item in searchItems) {
//      if (item.toLowerCase().contains(query.toLowerCase())) {
//        matchQuery.add(item);
//      }
//    }
//    return ListView.builder(
//      itemCount: matchQuery.length,
//      itemBuilder: (context, index) {
//        var results = matchQuery[index];
//        return ListTile(
//          title: Text(results),
//        );
//      },
//    );
//  }
//
//  @override
//  Widget buidSuggestion(BuildContext context) {
//    List<String> matchQuery = [];
//    for (var item in searchItems) {
//      if (item.toLowerCase().contains(query.toLowerCase())) {
//        matchQuery.add(item);
//      }
//    }
//    return ListView.builder(
//      itemCount: matchQuery.length,
//      itemBuilder: (context, index) {
//        var results = matchQuery[index];
//        return ListTile(
//          title: Text(results),
//        );
//      },
//    );
//  }
//}
