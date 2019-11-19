// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera/camera.dart';

//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hush_talk/menu/MenuCards.dart';
import 'package:hush_talk/model/MenuCardModel.dart';

//import 'package:hush_talk/util/AdMobUtil.dart';
import 'package:hush_talk/util/CameraUtils.dart';
import 'package:hush_talk/util/EmptyAppBar.dart';
import 'package:hush_talk/word_cards/CameraMLController.dart';
import 'package:hush_talk/word_cards/card_page/ListCardsPage.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';
import 'package:hush_talk/word_cards/dynamic_card_page/ListDynamicCardsPage.dart';
import 'package:hush_talk/word_cards/word_page/ListWordsPage.dart';
import 'package:screen/screen.dart';

import 'menu/CategoriaMenuList.dart';

void main() => runApp(MaterialApp(home: MyHomePage()));

class MyHomePage extends StatefulWidget {
  final bool anuncioWasShown;

  MyHomePage({this.anuncioWasShown = false});

  @override
  _MyHomePageState createState() => _MyHomePageState(this.anuncioWasShown);
}

class _MyHomePageState extends State<MyHomePage>  with WidgetsBindingObserver {
  dynamic _scanResults;
  CameraMLController _camera;
  ScrollBackMenuListView _controller;
  CameraLensDirection _direction = CameraLensDirection.front;
  bool _pageChanged = false;
  bool _anuncioWasShown;
//  BannerAd _bannerAd;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _MyHomePageState(this._anuncioWasShown);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    Screen.keepOn(true);
    _initControllers();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_camera == null || !_camera.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _camera?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_camera != null) {
        onNewCameraSelected(_camera.description);
      }
    }
  }


  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_camera != null) {
      await _camera.dispose();
    }
    _initializeCamera();

    // If the controller is updated then update the UI.
    _camera.addListener(() {
      if (mounted) setState(() {});
      if (_camera.value.hasError) {
        showInSnackBar('Camera error ${_camera.value.errorDescription}');
      }
    });

    try {
      await _camera.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }


  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  _initControllers() {
    _controller =
        ScrollBackMenuListView(backMenu: () => {}, cardList: menuCards);
    _initializeCamera();
  }

  updateStateCamera(result) {
    setState(() {
      _scanResults = result;
    });
  }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);
    _camera = CameraMLController(description, updateStateCamera);
  }

  Widget _buildImage() {
    return Container(
        constraints: const BoxConstraints.expand(),
        child: _camera == null
            ? const Center(
                child: Text(
                  'Inicializando a camera...',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 30.0,
                  ),
                ),
              )
            : createCategoriaMenuList(),
        );
  }

  Stack createCategoriaMenuList() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        CategoriaMenuList(_scanResults, _camera, _controller, _changePage),
      ],
    );
  }

  _changePage(index) {
    var route = ModalRoute.of(context);
    if (route != null && !_pageChanged) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _camera.stop();
          _pageChanged = true;
          MenuCardModel menuCard = _controller.cardList[index];
//          showBannerAd();
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ListWordsPage(menuCard.cardList)));
          } else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ListCardsPage(menuCard.cardList)));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ListDynamicCardsPage()));
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    configureAdds();
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      primary: false,
      appBar: EmptyAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: _buildImage(),
      ),
    );
  }

//  void configureAdds() {
//     if(!_anuncioWasShown) {
//      _bannerAd = configureFireBaseBannerAd();
//      setState(() {
//        _anuncioWasShown = !_anuncioWasShown;
//      });
//    }
//  }
//
//  void showBannerAd() {
//     _bannerAd.isLoaded().then((loaded) {
//      if(loaded){
//        _bannerAd?.dispose();
//      }
//    });
//  }

}
