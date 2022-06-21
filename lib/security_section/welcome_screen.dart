import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ree_gig/home_screen.dart';
import 'package:ree_gig/project_constants.dart';
import 'package:ree_gig/security_section/signin_screen.dart';
import 'package:ree_gig/security_section/signin_screen2.dart';
import 'package:ree_gig/security_section/signin_screen3.dart';
import 'register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';

  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController _pageController = PageController();
  final introKey = GlobalKey<IntroductionScreenState>();
  int curentIndex = 0;

  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => SignInScreen(),
        ),
        (route) => false);
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String imageName, [double imageRadius = 100]) {
    return CircleAvatar(
      foregroundImage: AssetImage(
        imageName,
      ),
      radius: imageRadius,
    );
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("WelcomeScreen Bulid Run");
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Color(0xff540E79),
      imagePadding: EdgeInsets.zero,
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 20.0),
            child: TextButton(
              child: Text(
                'Skip',
                style: TextStyle(color: whiteColor, fontSize: 16),
              ),
              onPressed: () => _onIntroEnd(context),
            ),
          )
        ],
      ),
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: darkPurple,
        globalFooter: const SizedBox(
//          width: double.infinity,
          height: 20,
        ),
        pages: [
          PageViewModel(
//            title: 'Request',
            titleWidget: Text('Request',
                style: TextStyle(
                    color: whiteColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            body: '',
            image: _buildImage('images/request.jpg'),
            decoration: pageDecoration,
            useScrollView: true,
          ),
          PageViewModel(
//            title: 'Negotiate',
            titleWidget: Text('Negotiate',
                style: TextStyle(
                    color: whiteColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            body: '',
            image: _buildImage('images/negotiate.jpg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
//            title: 'Deal',
            titleWidget: Text('Deal',
                style: TextStyle(
                    color: whiteColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            body: '',
            image: _buildImage('images/deal.jpg'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: false,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: true,
        animationDuration: 1,
        //rtl: true, // Display as right-to-left
        back: Text('Back', style: TextStyle(color: whiteColor)),
//        const Icon(Icons.arrow_back),
        skip: Text('Skip',
            style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor)),
        next: Text('Next', style: TextStyle(color: whiteColor)),
//        Icon(Icons.arrow_forward),
        done: Text('Done',
            style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          activeColor: lightPurple,
          color: const Color(0xFFBDBDBD),
          activeSize: const Size(22.0, 10.0),
          activeShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),

//      Stack(
//        children: [
//          PageView(
//            controller: _pageController,
//            onPageChanged: (int page) {
//              setState(() {
//                curentIndex = page;
//              });
//            },
//            children: [
//              makePage(
//                image: '1',
//                title: 'Request',
//              ),
//              makePage(
//                image: '2',
//                title: 'Negotiate',
//              ),
//              makePage(
//                image: '3',
//                title: 'Deal',
//              ),
//            ],
//          )
//        ],
//      ),
    );
  }

//  Widget makePage({image, title, context, reverse = false}) {
//    return Container(
//      child: Padding(
//        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: [
//            Column(children: [
//              CircleAvatar(backgroundColor: Colors.white, radius: 100),
//              SizedBox(height: 30),
//              Text(
//                title,
//                style: TextStyle(color: Colors.white, fontSize: 25),
//              ),
//            ]),
//            Padding(
//              padding: const EdgeInsets.only(bottom: 15.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: List.generate(
//                  3,
//                  (index) => Padding(
//                    padding: EdgeInsets.symmetric(horizontal: 5.0),
//                    child: AnimatedContainer(
//                      duration: Duration(milliseconds: 500),
//                      curve: Curves.easeIn,
//                      width: 14,
//                      height: 14,
//                      decoration: BoxDecoration(
//                          color: Colors.white,
//                          borderRadius: BorderRadius.circular(20)),
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

//  List<Widget> _buildIndicator() {
//    List<Widget> indicators = [];
//    for (int i = 0; i < 3; i++) {
//      if (curentIndex == i) {
//        indicators.add(_indicator[true]);
//      } else {
//        indicators.add(_indicator[false]);
//      }
//    }
//    return indicators;
//  }
}

//Column(
//mainAxisAlignment: MainAxisAlignment.center,
//crossAxisAlignment: CrossAxisAlignment.center,
//children: [
//CircleAvatar(
//radius: 100,
//),
//
//Text('Request', style: TextStyle(color: whiteColor)),
//Row(
//mainAxisAlignment: MainAxisAlignment.center,
//children: List.generate(
//3,
//(index) => Padding(
//padding: EdgeInsets.symmetric(horizontal: 5.0),
//child: AnimatedContainer(
//duration: Duration(milliseconds: 500),
//curve: Curves.easeIn,
//width: 14,
//height: 14,
//decoration: BoxDecoration(
//color: Colors.white,
//borderRadius: BorderRadius.circular(20)),
//),
//),
//),
//),
//],
//),
