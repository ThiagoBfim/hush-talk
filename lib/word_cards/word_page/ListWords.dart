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

  ListWords(this._scanResults, this._camera, this._controller){
    this._controller.configItemSize(itemSize);
  }

  @override
  Widget build(BuildContext context) {
    _selectionAction(EyeDector(_camera.getFaceDetected(_scanResults)));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _controller.moveDown(height);
    return Column(children: <Widget>[
      Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      "Feche os dois olhos para selecionar.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    "Feche o esquerdo para voltar para o menu.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Feche o direito para inverter a ordem de exibição dos elementos.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Flexible(
        child: ListView.builder(
          controller: _controller,
          itemCount: _controller.cardList.length,
          scrollDirection: Axis.horizontal,
          itemExtent: itemSize,
          itemBuilder: (context, index) {
            final cardModel = _controller.cardList[index];
            return WordItem(card: cardModel, height: height / 3, width: width);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(children: <Widget>[
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
      ),
    ]);
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  _selectionAction(EyeDector eyeDector) {
    _controller.updateAction(eyeDector);
  }
}
