import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/util/CameraUtils.dart';
import 'package:hush_talk/util/EmptyAppBar.dart';
import 'package:hush_talk/word_cards/CameraMLController.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';
import 'package:screen/screen.dart';

abstract class ListAbsctractPage extends StatefulWidget {
  ListAbsctractPage();

  @override
  ListAbsctractPageState createState();
}

abstract class ListAbsctractPageState extends State<ListAbsctractPage> {
  dynamic scanResults;
  CameraMLController camera;
  ScrollBackMenuListView controller;
  CameraLensDirection _direction = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    controller = initScrollController();
    Screen.keepOn(true);
    _initializeCamera();
  }

  @protected
  ScrollBackMenuListView initScrollController();

  updateStateCamera(result) {
    setState(() {
      scanResults = result;
    });
  }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);
    camera = CameraMLController(description, updateStateCamera);
    camera.init();
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: camera == null
          ? const Center(
              child: Text(
                'Inicializando a camera...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                createList(),
              ],
            ),
    );
  }

  @protected
  Widget createList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: EmptyAppBar(),
      body: _buildImage(),
    );
  }
}
