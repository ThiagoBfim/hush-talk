import 'package:flutter/material.dart';
import 'package:hush_talk/ml_widget/EyeDetector.dart';

import 'CameraMLController.dart';
import 'ScrollBackMenuListView.dart';
import 'WordItem.dart';
import 'cards/WordsCards.dart';

class ListWords extends StatelessWidget {
  final _scanResults;
  final CameraMLController _camera;
  final ScrollBackMenuListView _controller;
  final double itemSize = 340.0;

  ListWords(this._scanResults, this._camera, this._controller);

  @override
  Widget build(BuildContext context) {
    _selectionAction(EyeDector(_camera.getFaceDetected(_scanResults)));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _controller.moveDown(height);
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
                        "Pisque o esquerdo durante 2 segundos para voltar para o menu",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Pisque o direito durante 2 segundos para exibir os elementos para baixo",
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
          itemCount: wordsCards.length,
          scrollDirection: Axis.horizontal,
          itemExtent: itemSize,
          itemBuilder: (context, index) {
            final cardModel = wordsCards[index];
            return WordItem(
                card: cardModel,
                height: height/3,
                width: width ,
                selected: _controller.isSelected(index, itemSize));
          },
        ),
      )
    ]);
  }

  _selectionAction(EyeDector eyeDector) {
    if (eyeDector.getCompleteEyesClosed()) {
      if (!_controller.getStop()) {
        _controller.stopAndScrollBack();
      }
    } else if (eyeDector.getRightEyeClosed()) {
      _controller.incrementPiscadas(true);
    } else if (eyeDector.getLeftEyeClosed()) {
      _controller.incrementPiscadas(false);
    } else {}
  }
}
