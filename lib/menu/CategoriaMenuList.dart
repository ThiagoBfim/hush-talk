import 'package:flutter/material.dart';
import 'package:hush_talk/ml_widget/EyeDetector.dart';
import 'package:hush_talk/word_cards/CameraMLController.dart';
import 'package:hush_talk/word_cards/ScrollBackMenuListView.dart';
import 'package:hush_talk/word_cards/WordItem.dart';

import 'MenuCards.dart';

class CategoriaMenuList extends StatelessWidget {
  final _scanResults;
  final CameraMLController _camera;
  final ScrollBackMenuListView _controller;
  final double itemSize = 420.0;
  final VoidCallback _changePage;

  CategoriaMenuList(
      this._scanResults, this._camera, this._controller, this._changePage);

  @override
  Widget build(BuildContext context) {
    _selectionAction(EyeDector(_camera.getFaceDetected(_scanResults)), context);
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
          itemCount: menuCards.length,
          scrollDirection: Axis.vertical,
          itemExtent: itemSize,
          itemBuilder: (context, index) {
            final cardModel = menuCards[index];
            return WordItem(
                card: cardModel,
                height: height,
                width: width,
                selected: isSelected(index));
          },
        ),
      )
    ]);
  }

  //TODO mover essa logica para o scroll controller
  bool isSelected(int index) {
    bool select = _controller.getStop() &&
        _controller.positionStoped >
            ScrollBackMenuListView.DEFAULT_INIT_POSITION_STOP &&
        (_controller.positionStoped / itemSize).round() == index;
    if (select) {
      if (_controller.positionStoped != index * itemSize) {
        _controller.forceSelectedJustElement(index * itemSize);
      }
    }
    return select;
  }

  _selectionAction(EyeDector eyeDector, BuildContext context) {
    if (eyeDector.getCompleteEyesClosed()) {
        Function.apply(_changePage, []);
    } else {}
  }
}
