import 'package:flutter/material.dart';
import 'package:hush_talk/ml_widget/EyeDetector.dart';
import 'package:hush_talk/word_cards/word_page/ScrollBackMenuWordsListView.dart';

import '../CameraMLController.dart';
import '../WordItem.dart';

class ListWords extends StatelessWidget {
  final _scanResults;
  final CameraMLController _camera;
  final ScrollBackMenuWordsListView _controller;
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
                        "Pisque o direito durante 2 segundos para inverter a ordem de exibição dos elementos",
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
          itemCount: _controller.wordList.length,
          scrollDirection: Axis.horizontal,
          itemExtent: itemSize,
          itemBuilder: (context, index) {
            final cardModel = _controller.wordList[index];
            return WordItem(card: cardModel, height: height / 3, width: width);
          },
        ),
      ),
      Column(children: <Widget>[
        Align(
          alignment: FractionalOffset.topLeft,
          child: Text(
            "Resultado:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          width: width,
          margin: const EdgeInsets.all(30.0),
          padding: EdgeInsets.all(10),
          decoration: myBoxDecoration(),
          child: Text(
            "${_controller.getWord().toLowerCase()}",
            style: TextStyle(
              color: Colors.red,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ]),
    ]);
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  _selectionAction(EyeDector eyeDector) {
    if (eyeDector.getCompleteEyesClosed()) {
      if (!_controller.getStop()) {
        _controller.updateWord(itemSize);
      }
    } else if (eyeDector.getRightEyeClosed()) {
      _controller.incrementPiscadas(true);
    } else if (eyeDector.getLeftEyeClosed()) {
      _controller.incrementPiscadas(false);
    } else {}
  }
}
