// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/menu/MenuCards.dart';
import 'package:hush_talk/model/MenuCardModel.dart';
import 'package:hush_talk/util/CameraUtils.dart';
import 'package:hush_talk/util/EmptyAppBar.dart';
import 'package:hush_talk/word_cards/CameraMLController.dart';
import 'package:hush_talk/word_cards/card_page/ListCardsPage.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';
import 'package:hush_talk/word_cards/word_page/ListWordsPage.dart';
import 'package:screen/screen.dart';

import 'menu/CategoriaMenuList.dart';

void main() => runApp(MaterialApp(home: MyHomePage()));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic _scanResults;
  CameraMLController _camera;
  ScrollBackMenuListView _controller;
  CameraLensDirection _direction = CameraLensDirection.front;
  bool _pageChanged = false;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _controller = ScrollBackMenuListView(backMenu: () => {}, cardList: menuCards);
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
    _camera.init();
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CategoriaMenuList(
                    _scanResults, _camera, _controller, _changePage),
//                _buildResults(),
              ],
            ),
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
          if(index == 0){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ListWordsPage(menuCard.cardList)));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ListCardsPage(menuCard.cardList)));
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: EmptyAppBar(),
      body: _buildImage(),
    );
  }
}
