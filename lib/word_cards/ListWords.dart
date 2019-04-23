import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/ml_widget/EyeDetector.dart';

import 'WordCard.dart';
import 'WordItem.dart';

class ListWords extends StatelessWidget {
  dynamic _scanResults;
  CameraController _camera;
  final ScrollController _controller;
  double itemSize = 420.0;

  ListWords(this._scanResults, this._camera, this._controller);

  Face getFaceDetected() {
    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return null;
    }

    if (_scanResults is! List<Face>) {
      return null;
    }
    List<Face> faces = _scanResults;
    if (faces.length > 0) {
      return faces[0];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _selectionAction(EyeDector(getFaceDetected()));
    double height = MediaQuery.of(context).size.height;
    return Column(children: <Widget>[
      Container(
        height: 60,
        color: Colors.white,
        child: Center(
          child: Align(
            alignment: FractionalOffset.topCenter,
            child: Text(
              "Pisque os dois olhos para selecionar a imagem.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          controller: _controller,
          itemCount: wordCards.length,
          scrollDirection: Axis.vertical,
          itemExtent: itemSize,
          itemBuilder: (context, index) {
            final wordCard = wordCards[index];
//            return ListTile(title: Text(wordCard.title));
            return WordItem(
              wordCard: wordCard,
              height: height + 60,
            );
          },
        ),
      )
    ]);
  }

  _selectionAction(EyeDector eyeDector) {
    bool rightEyeClosed = eyeDector.getRightEyeClosed();
    bool leftEyeClosed = eyeDector.getLeftEyeClosed();
    if(rightEyeClosed && leftEyeClosed){

    } else if (rightEyeClosed) {
      _moveDown();
    } else if (leftEyeClosed) {
      _moveUp();
    } else {
    }
  }

  _moveUp() {
    _controller.animateTo(_controller.offset - itemSize,
        curve: Curves.linear, duration: Duration(milliseconds: 1000));
  }

  _moveDown() {
    var locale = _controller.offset + itemSize;
    _controller.animateTo(locale,
        curve: Curves.linear, duration: Duration(milliseconds: 1000));
  }
}
