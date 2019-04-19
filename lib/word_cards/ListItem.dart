import 'package:flutter/material.dart';

import 'WordCard.dart';
import 'detail_page.dart';

class ListItem extends StatelessWidget {
  final WordCard wordCard;
  final height;

  const ListItem({
    Key key,
    @required this.wordCard,
    @required this.height,
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
                bottom: 0,
                child: Hero(
                  tag: "background_${wordCard.title}",
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      wordCard.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Hero(
                  tag: "image_${wordCard.title}",
                  child: Image.network(
                    wordCard.avatar,
//                      width: width / 2,
                    height: height,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
