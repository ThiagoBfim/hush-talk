import 'package:flutter/material.dart';
import 'package:hush_talk/model/WordCardModel.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';
import 'package:hush_talk/word_cards/cards/WordsCards.dart';

class ScrollBackMenuWordsListView extends ScrollBackMenuListView {
  String _word = "";
  bool downScroll = true;
  bool _forceSameWord = false;
  double _itemSize = 340.0;

  ScrollBackMenuWordsListView(
      VoidCallback backMenu, List<WordCardModel> cardList)
      : super(
            backMenu: backMenu,
            cardList: getWordsCards,
            durationScrollMilliseconds: 4500,
            qtdPiscadasEsquerdasToChangeAction: 7,
            qtdPiscadasDireitasToChangeAction: 3);

  void scrollBack() {
    if (downScroll) {
      positionStoped = this.offset - getPixelsBackWhenStop;
    } else {
      positionStoped = this.offset + getPixelsBackWhenStop;
    }
  }

  void scroll(double height) {
    if (downScroll) {
      animateTo(offset + height,
          curve: Curves.linear,
          duration: Duration(milliseconds: durationScrollMilliseconds));
    } else {
      animateTo(offset - height,
          curve: Curves.linear,
          duration: Duration(milliseconds: durationScrollMilliseconds));
    }
  }

  @override
  void olhoDireitoAction() {
    super.olhoDireitoAction();
    downScroll = !downScroll;
  }

  updateWord(double itemSize) {
    stopAndScrollBack();
    var indexStopped = getIndexStopped(itemSize);
    WordCardModel wordCard = cardList[indexStopped];
    var word = wordCard.title;
    var specialAction = wordCard.specialAction;
    if (specialAction != "") {
      if ("space" == specialAction) {
        this._word += " ";
      } else if ("remove" == specialAction && this._word.length >= 1 ||
          _forceSameWord) {
        this._word = this._word.substring(0, this._word.length - 1);
        if (this._word.endsWith(word)) {
          _forceSameWord = true;
        } else {
          _forceSameWord = false;
        }
      } else if ("ponto" == specialAction) {
        this._word += '.';
      }
    } else {
      if (!this._word.endsWith(word) || _forceSameWord) {
        this._word += word;
        _forceSameWord = false;
      } else {
        _forceSameWord = true;
      }
    }
    setStop(false);
  }

  getWord() {
    return this._word;
  }

  @override
  void closeTwoEyesAction() {
    updateWord(_itemSize);
    resetPiscadas();
  }

  void configItemSize(double itemSize) {
    this._itemSize = itemSize;
  }
}
