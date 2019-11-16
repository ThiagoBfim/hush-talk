import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hush_talk/model/CardModel.dart';

class WordItem extends StatelessWidget {
  final CardModel card;
  final height;
  final width;
  final bool selected;
  final bool imageGallery;
  final bool ableDelete;
  final Function deleteFunction;

  const WordItem({
    Key key,
    @required this.card,
    @required this.height,
    @required this.width,
    this.selected = false,
    this.deleteFunction,
    this.ableDelete = false,
    this.imageGallery = false,
    onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          height: height,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Hero(
                  tag: "background_${card.avatar}",
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          selected ? Colors.green : Color(63),
                          Colors.white,
                        ],
                      )),
                      child: createBottomContainer(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 50.0,
                  left: 5.0,
                  right: 5.0,
                  top: 10.0,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Hero(
                    tag: "image_${card.avatar}",
                    child: createImage(),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget createBottomContainer() {
    if (ableDelete) {
      return Container(
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.only(
            left: 20,
            bottom: 10,
          ),
          child: createDeleteButton()
      );
    }
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(
        left: 20,
        bottom: 10,
      ),
      child: Text(
        card.title ?? '',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Image createImage() {
    return imageGallery
        ? Image.file(File(card.avatar), height: height, width: width)
        : Image.asset(
            card.avatar,
            height: height,
            width: width,
          );
  }

  Widget createDeleteButton() {
    return Container(
      margin: EdgeInsets.only(
        right: 20,
    ),
      child: RaisedButton(
          color: Colors.red,
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              Text("Remover"),
            ],
          ),
          onPressed: () => Function.apply(deleteFunction, [card.avatar])),
    );
  }
}
