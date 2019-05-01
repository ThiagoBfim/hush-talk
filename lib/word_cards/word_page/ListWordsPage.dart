import 'package:flutter/material.dart';
import 'package:hush_talk/word_cards/ListAbsctractPage.dart';
import 'package:hush_talk/word_cards/word_page/ListWords.dart';
import 'package:hush_talk/word_cards/word_page/ScrollBackMenuWordsListView.dart';

import '../../main.dart';

class ListWordsPage extends ListAbsctractPage {

  @override
  _ListWordsPageState createState() => _ListWordsPageState();
}

class _ListWordsPageState extends ListAbsctractPageState {
  bool _pageChanged = false;

  @override
  createList(){
    return ListWords(scanResults, camera, controller);
  }

  @override
  ScrollBackMenuWordsListView initScrollController() {
    return ScrollBackMenuWordsListView(_backMenu);
  }

  _backMenu(){
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

