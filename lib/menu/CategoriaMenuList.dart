import 'package:flutter/material.dart';
import 'package:hush_talk/ml_widget/EyeDetector.dart';
import 'package:hush_talk/word_cards/CameraMLController.dart';
import 'package:hush_talk/word_cards/WordItem.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';

class CategoriaMenuList extends StatelessWidget {
  final _scanResults;
  final CameraMLController _camera;
  final ScrollBackMenuListView _controller;
  final double itemSize = 420.0;
  final Function _changePage;

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
                        "Feche os dois olhos para selecionar.",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
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
          itemCount: _controller.cardList.length,
          scrollDirection: Axis.vertical,
          itemExtent: itemSize,
          itemBuilder: (context, index) {
            final cardModel = _controller.cardList[index];
            return WordItem(
                card: cardModel,
                height: height,
                width: width,
                selected: _controller.isSelected(index, itemSize));
          },
        ),
      )
    ]);
  }

  _selectionAction(EyeDector eyeDector, BuildContext context) {
    if (eyeDector.getCompleteEyesClosed()) {
      _controller.stopAndScrollBack();
      int index = _controller.getIndexStopped(itemSize);
        Function.apply(_changePage, [index]);
    } else {}
  }
}
