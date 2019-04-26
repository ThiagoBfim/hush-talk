import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/ml_widget/EyeDetector.dart';

import 'ScrollToTopBottomListView.dart';
import 'WordCard.dart';
import 'WordItem.dart';

class ListWords extends StatelessWidget {
  final _scanResults;
  final CameraController _camera;
  final ScrollToTopBottomListView _controller;
  final double itemSize = 420.0;

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
    _controller.move(height);
    return Column(children: <Widget>[
      Container(
        height: 105,
        color: Colors.white,
        child: Center(
          child: Align(
            alignment: FractionalOffset.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Pisque os dois olhos por 1 segundo para selecionar.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Pisque o direito durante 2 segundos para exibir os elementos para cima",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Pisque o esquerdo durante 2 segundos para exibir os elementos para baixo",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
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
            return WordItem(
                wordCard: wordCard, height: height, selected: isSelected(index));
          },
        ),
      )
    ]);
  }

  bool isSelected(int index) {
    return _controller.positionStoped > ScrollToTopBottomListView.DEFAULT_INIT_POSITION_STOP
        && (_controller.positionStoped/itemSize).round() == index;
  }

  _selectionAction(EyeDector eyeDector) {
    if (eyeDector.getCompleteEyesClosed()) {
      if (!_controller.getStop()) {
        _controller.stopAndScrollBack();
      }
    } else if (eyeDector.getRightEyeClosed()) {
      _controller.incrementPiscadas(false);
    } else if (eyeDector.getLeftEyeClosed()) {
      _controller.incrementPiscadas(true);
    } else {}
  }
}
