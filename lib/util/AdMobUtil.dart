//import 'package:firebase_admob/firebase_admob.dart';
//
//const MobileAdTargetingInfo _targetingInfo = MobileAdTargetingInfo(
//  childDirected: false,
//  testDevices: <String>[
//    "525B81E4E186AEA072D42244B00590F8"
//  ], // Android emulators are considered test devices
//);
//
//BannerAd configureFireBaseBannerAd() {
//  var myAdMobAdUnitId = "ca-app-pub-8991564571112984/1689954331";
//  BannerAd myBanner = BannerAd(
//    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//    // https://developers.google.com/admob/android/test-ads
//    // https://developers.google.com/admob/ios/test-ads
//    adUnitId: myAdMobAdUnitId,
//    size: AdSize.smartBanner,
//    targetingInfo: _targetingInfo,
//    listener: (MobileAdEvent event) {
//      print("BannerAd event is $event");
//    },
//  );
//  _initializeAndShowAdMob(myBanner);
//
//  return myBanner;
//}
//
//void _initializeAndShowAdMob(MobileAd mobileAd) {
//  const myAdMobAdAppId = "ca-app-pub-8991564571112984~1432764030";
//  FirebaseAdMob.instance.initialize(appId: myAdMobAdAppId).then((response) {
//    mobileAd
//      // typically this happens well before the ad is shown
//      ..load()
//      ..show(
//        anchorOffset: 0.0,
//        // Banner Position
//        anchorType: AnchorType.bottom,
//      );
//  });
//}
//
//void configureFireBaseInterstitialAd(Function onAdClosed) {
//  var myAdMobAdUnitId = "ca-app-pub-8991564571112984/8450803809";
//  InterstitialAd myInterstitial = InterstitialAd(
//    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//    // https://developers.google.com/admob/android/test-ads
//    // https://developers.google.com/admob/ios/test-ads
//    adUnitId: myAdMobAdUnitId,
//    targetingInfo: _targetingInfo,
//    listener: (MobileAdEvent event) {
//      print("InterstitialAd event is $event");
//      if (MobileAdEvent.closed == event ||
//          MobileAdEvent.failedToLoad == event) {
//        Function.apply(onAdClosed, [event]);
//      }
//    },
//  );
//
//  _initializeAndShowAdMob(myInterstitial);
//}
