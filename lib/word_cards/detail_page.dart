import 'package:flutter/material.dart';

import 'WordCard.dart';

class DetailPage extends StatefulWidget {
  final WordCard wordCard;

  const DetailPage({
    Key key,
    @required this.wordCard,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: "background_${widget.wordCard.title}",
          child: Container(
            color: Colors.white,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
//            backgroundColor: Color(widget.wordCard.color),
            elevation: 0,
            title: Text(widget.wordCard.title),
            leading: CloseButton(),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: "image_${widget.wordCard.title}",
                  child: Image.network(
                    widget.wordCard.avatar,
                    height: MediaQuery.of(context).size.height / 2,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, widget) => Transform.translate(
                        transformHitTests: false,
                        offset: Offset.lerp(
                            Offset(0.0, 200.0), Offset.zero, _controller.value),
                        child: widget,
                      ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
