import 'package:flutter/material.dart';
import 'package:hush_talk/word_cards/ListAbsctractPage.dart';
import 'package:hush_talk/word_cards/card_page/ListCards.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';

import '../../main.dart';

class ListCardsPage extends ListAbsctractPage {

  @override
  createState() {
    return _ListCardsPageState();
  }
}

class _ListCardsPageState extends ListAbsctractPageState {

  bool _pageChanged = false;

  @override
  ScrollBackMenuListView initScrollController() {
    return ScrollBackMenuListView(backMenu: _backMenu);
  }

  @override
  Widget createList() {
    return ListCards(scanResults, camera, controller);
  }

  _backMenu() {
    var route = ModalRoute.of(context);
    if (route != null && !_pageChanged) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _pageChanged = true;
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage()));
        });
      });
    }
  }

}

