import 'package:flutter/material.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';
import 'package:hush_talk/word_cards/cards/WordsCards.dart';

class ScrollBackMenuWordsListView extends ScrollBackMenuListView {
  String _word = "";
  final wordList = getWordsCards;
  bool downScroll = true;

  ScrollBackMenuWordsListView(VoidCallback _backMenu)
      : super(
            backMenu: _backMenu,
            durationScrollMilliseconds: 3500,
            sizePiscadasToChangeAction: 5);

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

  incrementPiscadas(bool scroll) {
    setPiscadas(getPiscadas + 1);
    if (!scroll && getPiscadas >= sizePiscadasToChangeAction * 3) {
      Function.apply(backMenu, []);
      setStop(true);
      setPiscadas(0);
    } else if (scroll && getPiscadas >= sizePiscadasToChangeAction) {
      downScroll = !downScroll;
      setStop(false);
      this.scrollAtive = scroll;
      setPiscadas(0);
    }
  }

  updateWord(double itemSize) {
    stopAndScrollBack();
    var indexStopped = getIndexStopped(itemSize);
    var wordCard = wordList[indexStopped];
    var word = wordCard.title;
    var specialAction = wordCard.specialAction;
    scrollToTop();
    if ("space" == specialAction) {
      this._word += " ";
    } else if ("remove" == specialAction) {
      this._word = this._word.substring(0, this._word.length - 1);
    } else {
      if (!this._word.endsWith(word)) {
        this._word += word;
      }
    }
    setStop(false);
  }

  getWord() {
    return this._word;
  }
}
