import 'package:flutter/material.dart';
import 'package:hush_talk/model/CardModel.dart';
import 'package:hush_talk/word_cards/ListAbsctractPage.dart';
import 'package:hush_talk/word_cards/word_page/ListWords.dart';
import 'package:hush_talk/word_cards/word_page/ScrollBackMenuWordsListView.dart';

import '../../Home.dart';

class ListWordsPage extends ListAbsctractPage {
  final List<CardModel> cardList;
  ListWordsPage(this.cardList);


  @override
  _ListWordsPageState createState() => _ListWordsPageState(cardList);
}

class _ListWordsPageState extends ListAbsctractPageState {
  bool _pageChanged = false;
  final List<CardModel> cardList;

  _ListWordsPageState(this.cardList);

  @override
  createList(){
    return ListWords(scanResults, camera, controller);
  }

  @override
  ScrollBackMenuWordsListView initScrollController() {
    return ScrollBackMenuWordsListView(_backMenu, cardList);
  }

  _backMenu(){
    var route = ModalRoute.of(context);
    if (route != null && !_pageChanged) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _pageChanged = true;
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage(anuncioWasShown: false,)));
        });
      });
    }
  }
}

