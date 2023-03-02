import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../newScreenforLogo/newLogoScreen.dart';
import 'components/onboarding_page.dart';
import 'components/onboarding_page_model.dart';

class OnboardingScreen extends StatefulWidget {
  static const route = '/onboarding';
  @override
  State<StatefulWidget> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingScreen> {
  ScrollController scrollControler = ScrollController();

  final int numberOfPages = 4;

  void toNextPage(int page, double widthOfSingleItem) {
    scrollControler.animateTo(
      (page + 1) * widthOfSingleItem,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  void toNextPageScroll(int page, double widthOfSingleItem) {
    scrollControler.animateTo(
      (page + 1) * widthOfSingleItem,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  void toPreviousPageScroll(int page, double widthOfSingleItem) {
    scrollControler.animateTo(
      (page - 1) * widthOfSingleItem,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  void finish(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("FirstOpen-Flag", false);
    // Navigator.of(context).pop();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogoScreen()),
    );

  }

  @override
  Widget build(BuildContext context) {
    List<OnboardingPageModel> models = getModels(context);
    double displayWidth = MediaQuery.of(context).size.width;

    double listviewPadding = (displayWidth * 0.055).round().toDouble();
    double imageWidth = (displayWidth * 0.83).round().toDouble();
    double horizontalColumnPadding = (displayWidth * 0.085) - listviewPadding;

    return Scaffold(
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: listviewPadding,
          ),
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: numberOfPages,
          itemBuilder: (_, e) => OnboardingPage(
            model: models.elementAt(e),
            toNextPage: toNextPage,
            finish: finish,
            currentPage: e,
            numberOfPages: numberOfPages,
            horizontalColumnPadding: horizontalColumnPadding,
            imageWidth: imageWidth,
            toNextPageScroll: toNextPageScroll,
            toPreviousPageScroll: toPreviousPageScroll,
          ),
          controller: scrollControler,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF052145),
              Color(0xFF004D88),
            ],
          ),
        ),
      ),
    );
  }

  List<OnboardingPageModel> getModels(BuildContext context) {
    var appLocaliations = AppLocalizations.of(context);
    final texts = [
      appLocaliations!.onboardingScreen_text1,
      appLocaliations.onboardingScreen_text2,
      appLocaliations.onboardingScreen_text3,
      appLocaliations.onboardingScreen_text4,
    ];
    List<OnboardingPageModel> models = [
      OnboardingPageModel(
          title: appLocaliations.onboardingScreen_wellcome,
          imagePath: "lib/assets/images/Gruppe_1.png",
          text: texts.elementAt(0),
          buttonText: AppLocalizations.of(context)!.commonWords_further),
      OnboardingPageModel(
          title: appLocaliations.onboardingScreen_find,
          imagePath: "lib/assets/images/Gruppe_2.png",
          text: texts.elementAt(1),
          buttonText: appLocaliations.commonWords_further),
      OnboardingPageModel(
          title: appLocaliations.onboardingScreen_book,
          imagePath: "lib/assets/images/Gruppe_3.png",
          text: texts.elementAt(2),
          buttonText: appLocaliations.commonWords_further),
      OnboardingPageModel(
          title: appLocaliations.onboardingScreen_experience,
          imagePath: "lib/assets/images/Gruppe_4.png",
          text: texts.elementAt(3),
          buttonText: appLocaliations.onboardingScreen_startNow),
    ];

    return models;
  }
}
