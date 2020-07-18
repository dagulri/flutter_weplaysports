import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io' show Platform;


void main() {
  runApp(MyApp());
}

//String appId = "ca-app-pub-5717096263298410~8175531664";
final String appIdForAndroid = "ca-app-pub-5717096263298410~8175531664";
final String appIdForIOS = "ca-app-pub-5717096263298410~7598561563";

final String adUnitForAndroid = "ca-app-pub-5717096263298410/9297041640";
final String adUnitForIOS = "ca-app-pub-5717096263298410/5537829843";

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {


    String adUnit = adUnitForAndroid;

    if (Platform.isAndroid) {
      FirebaseAdMob.instance.initialize(appId: appIdForAndroid);
      adUnit = adUnitForAndroid;
    } else if (Platform.isIOS) {
      FirebaseAdMob.instance.initialize(appId: appIdForIOS);
      adUnit = adUnitForIOS;
    }

    //FirebaseAdMob.instance.initialize(appId: appId);

    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['sports', 'score', 'board', '점수판', '점수'],
      contentUrl: 'https://flutter.io',
      birthday: DateTime.now(),
      childDirected: false,
      designedForFamilies: false,
      gender: MobileAdGender
          .male,
      // or MobileAdGender.female, MobileAdGender.unknown
      testDevices: <String>[], // Android emulators are considered test devices
    );

    BannerAd myBanner = BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      //adUnitId: BannerAd.testAdUnitId,
      adUnitId: adUnit,
      //size: AdSize.smartBanner,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );


    myBanner
    // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 0.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 0.0,
        // Banner Position
        anchorType: AnchorType.bottom,
        //Colors.black,
      );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        fontFamily: 'OdibeeSans',
      ),
      home: Scaffold(
        body: Dashboard(), //MyHomePage(title: 'We play sports'),
      )
    );//,
  }
}


