import 'package:flutter/material.dart';

import 'WordCard.dart';
import 'detail_page.dart';


class ListCards extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListCards> {
  PageController _controller;

  _goToDetail(WordCard wordCard) {
    final page = DetailPage(wordCard: wordCard);
    Navigator.of(context).push(
      PageRouteBuilder<Null>(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: page,
                  );
                });
          },
          transitionDuration: Duration(milliseconds: 400)),
    );
  }

  _pageListener() {
    setState(() {});
  }

  @override
  void initState() {
    _controller = PageController(viewportFraction: 0.6);
    _controller.addListener(_pageListener);
    print('init');
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_pageListener);
    _controller.dispose();
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dragon Ball"),
        backgroundColor: Colors.black54,
      ),
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _controller,
          itemCount: wordCards.length,
          itemBuilder: (context, index) {
            double currentPage = 0;
            try {
              currentPage = _controller.page;
            } catch (_) {}

            final resizeFactor =
            (1 - (((currentPage - index).abs() * 0.3).clamp(0.0, 1.0)));
            final currentCharacter = wordCards[index];
            return ListItem(
              wordCard: currentCharacter,
              resizeFactor: resizeFactor,
              onTap: () => _goToDetail(currentCharacter),
            );
          }),
    );
  }
}

class ListItem extends StatelessWidget {
  final WordCard wordCard;
  final double resizeFactor;
  final VoidCallback onTap;

  const ListItem({
    Key key,
    @required this.wordCard,
    @required this.resizeFactor,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;
    double width = MediaQuery.of(context).size.width * 0.85;
    return InkWell(
      onTap: onTap,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
            width: width * resizeFactor,
            height: height * resizeFactor,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: height / 4,
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
                          fontSize: 24 * resizeFactor,
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
                      width: width / 2,
                      height: height,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
