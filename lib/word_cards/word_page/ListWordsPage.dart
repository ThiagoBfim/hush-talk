import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/util/CameraUtils.dart';
import 'package:hush_talk/util/EmptyAppBar.dart';
import 'package:hush_talk/word_cards/word_page/ListWords.dart';
import 'package:hush_talk/word_cards/word_page/ScrollBackMenuWordsListView.dart';
import 'package:screen/screen.dart';

import '../../main.dart';
import '../CameraMLController.dart';

class ListWordsPage extends StatefulWidget {

  @override
  _ListWordsPageState createState() => _ListWordsPageState();
}

class _ListWordsPageState extends State<ListWordsPage> {
  dynamic _scanResults;
  CameraMLController _camera;
  ScrollBackMenuWordsListView _controller;
  CameraLensDirection _direction = CameraLensDirection.front;
  bool _pageChanged = false;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _controller = ScrollBackMenuWordsListView(_backMenu);
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
        ],
      ),
    );
  }

  _backMenu(){
    var route = ModalRoute.of(context);
    if (route != null && !_pageChanged) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _pageChanged = true;
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

