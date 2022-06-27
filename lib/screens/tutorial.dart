import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wecount/screens/intro.dart';

import 'package:wecount/utils/asset.dart' as Asset;
import 'package:wecount/utils/colors.dart';

import '../utils/localization.dart';

class Tutorial extends StatefulWidget {
  static const String name = '/tutorial';

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final int pageCnt = 2;
  int _currentPage = 0;
  var _pageController = PageController();

  void onNextPressed() {
    if (_currentPage == pageCnt) {
      Get.to(Intro());
      return;
    }

    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget renderPage({
      Key? key,
      int page = 0,
    }) {
      return Container(
        key: key,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 148),
              child: Image(
                image: page == 0
                    ? Asset.Icons.tutorial1
                    : page == 1
                        ? Asset.Icons.tutorial2
                        : page == 2
                            ? Asset.Icons.tutorial3
                            : Asset.Icons.tutorial1,
                width: 200,
                height: 160,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 56),
              child: Text(
                page == 0
                    ? t('RECORD_IT')
                    : page == 1
                        ? t('SHARE_IT')
                        : page == 2
                            ? t('TAKE_CARE')
                            : t('RECORD_IT'),
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                page == 0
                    ? t('TUTORIAL_1_DETAIL')
                    : page == 1
                        ? t('TUTORIAL_2_DETAIL')
                        : page == 2
                            ? t('TUTORIAL_3_DETAIL')
                            : t('TUTORIAL_1_DETAIL'),
                style: TextStyle(
                  fontSize: 16,
                  height: 1.3,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    Widget renderIndicator({
      Key? key,
      required currentPage,
      int page = 0,
    }) {
      return Container(
        key: key,
        margin: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: page == currentPage ? Colors.white : mainColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: Colors.white,
          ),
        ),
        height: 8,
        width: 8,
      );
    }

    Widget renderIndicatorGroup({
      Key? key,
      required currentPage,
    }) {
      return Container(
        child: Row(
          children: <Widget>[
            renderIndicator(
              currentPage: currentPage,
              page: 0,
            ),
            renderIndicator(
              currentPage: currentPage,
              page: 1,
            ),
            renderIndicator(
              currentPage: currentPage,
              page: 2,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: mainColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: PageView(
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    renderPage(page: 0),
                    renderPage(page: 1),
                    renderPage(page: 2),
                  ],
                ),
              ),
              Container(
                height: 56,
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    renderIndicatorGroup(currentPage: _currentPage),
                    TextButton(
                      onPressed: onNextPressed,
                      child: Text(
                        t('NEXT'),
                        style: TextStyle(
                          fontSize: 20,
                          color: greenColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
