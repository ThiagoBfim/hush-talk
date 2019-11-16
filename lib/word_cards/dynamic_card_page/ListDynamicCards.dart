import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hush_talk/ml_widget/EyeDetector.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';

import '../CameraMLController.dart';
import '../WordItem.dart';

class ListDynamicCards extends StatelessWidget {
  final _scanResults;
  final CameraMLController _camera;
  final ScrollBackMenuListView _controller;
  final double itemSize = 420.0;

  ListDynamicCards(this._scanResults, this._camera, this._controller);

  @override
  Widget build(BuildContext context) {
    _selectionAction(EyeDector(_camera.getFaceDetected(_scanResults)));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _controller.moveDown(height);
    return Column(children: <Widget>[
      Container(
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          "Feche os dois olhos por 1 segundo para selecionar.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        "Feche o esquerdo durante 2 segundos para voltar para o menu.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Feche o direito durante 2 segundos para exibir os elementos para baixo.",
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
        ),
      ),
      Flexible(
        child: ListView.builder(
          controller: _controller,
          itemCount: _controller.cardList.length,
          scrollDirection: Axis.vertical,
          itemExtent: itemSize,
          itemBuilder: (context, index) {
            final cardModel = _controller.cardList[index];
            return WordItem(
                card: cardModel,
                height: height,
                width: width,
                imageGallery: true,
                ableDelete: true,
                deleteFunction: (imagePath) => deleteImage(imagePath),
                selected: _controller.isSelected(index, itemSize));
          },
        ),
      )
    ]);
  }

  _selectionAction(EyeDector eyeDector) {
    _controller.updateAction(eyeDector);
  }

  deleteImage(imagePath) {
    File(imagePath).delete();
    _controller.goBackToMenu();
  }
}
