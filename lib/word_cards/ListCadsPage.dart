import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/util/CameraUtils.dart';
import 'package:hush_talk/util/EmptyAppBar.dart';
import 'package:hush_talk/word_cards/ListWords.dart';
import 'package:hush_talk/word_cards/ScrollBackMenuListView.dart';
import 'package:screen/screen.dart';

import '../main.dart';
import 'CameraMLController.dart';

class ListCardsPage extends StatefulWidget {
  ListCardsPage();

  @override
  _ListCardsPageState createState() => _ListCardsPageState();
}

class _ListCardsPageState extends State<ListCardsPage> {
  dynamic _scanResults;
  CameraMLController _camera;
  ScrollBackMenuListView _controller;
  CameraLensDirection _direction = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _controller = ScrollBackMenuListView(_backMenu);
    _initializeCamera();
  }

  updateStateCamera(result){
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
          ListWords(_scanResults, _camera, _controller),
//                _buildResults(),
        ],
      ),
    );
  }

  _backMenu(){
    var route = ModalRoute.of(context);
    if (route != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage()));
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

