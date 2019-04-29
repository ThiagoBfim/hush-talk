import 'package:flutter/material.dart';
import 'package:hush_talk/model/CardModel.dart';


class WordItem extends StatelessWidget {
  final CardModel card;
  final height;
  final width;
  final bool selected;

  const WordItem({
    Key key,
    @required this.card,
    @required this.height,
    @required this.width,
    @required this.selected,
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
                  tag: "background_${card.title}",
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
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                        ),
                        child: Text(
                          card.title,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 50.0,
                  left: 5.0,
                  right: 5.0,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Hero(
                    tag: "image_${card.title}",
                    child: Image.asset(
                      card.avatar,
                      height: height,
                      width: width,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

}
