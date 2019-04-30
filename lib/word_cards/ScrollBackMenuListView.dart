import 'package:flutter/material.dart';

class ScrollBackMenuListView extends ScrollController {
  static const int _SIZE_PISCADAS_TO_CHANGE_ACTION = 7;
  static const int _PIXELS_BACK_WHEN_STOP = 30;
  static const DURATION_SCROLL_MILLISECONDS = 4500;
  static const double DEFAULT_INIT_POSITION_STOP =
      _PIXELS_BACK_WHEN_STOP * -1 + -1.0;
  bool _stop = false;
  int _piscadas = 0;
  bool scrollAtive = true;
  double positionStoped = DEFAULT_INIT_POSITION_STOP;
  String _word = ""; //TODO ISSO NÃO DEVE FICAR AQUI.

  final VoidCallback _backMenu;

  ScrollBackMenuListView(this._backMenu);

  scrollToTop() {
    this.animateTo(this.position.minScrollExtent,
        duration: Duration(milliseconds: 1), curve: Curves.easeIn);
  }

  scrollToBottom() {
    this.animateTo(this.position.maxScrollExtent,
        duration: Duration(milliseconds: 1), curve: Curves.easeOut);
  }

  stopAndScrollBack() {
    setStop(true);
    if (scrollAtive) {
      //TODO exibir o som do item selecioando de acordo com os pixels -> this.position.pixels;
      positionStoped = this.offset - _PIXELS_BACK_WHEN_STOP;
      this.position.jumpTo(positionStoped);
    }
  }

  forceSelectedJustElement(position) {
    try {
      this.position.jumpTo(position);
    } catch (e) {
      print("Force to Jump position.");
    }
  }

  bool getStop() {
    return _stop;
  }

  setStop(bool stop) {
    this._stop = stop;
  }

  incrementPiscadas(bool scroll) {
    _piscadas++;
    if (_piscadas >= _SIZE_PISCADAS_TO_CHANGE_ACTION) {
      if (!scroll) {
        Function.apply(_backMenu, []);
        setStop(true);
      } else {
        setStop(false);
        this.scrollAtive = scroll;
      }
      _piscadas = 0;
    }
  }

  moveDown(double height) {
    if (positions.isNotEmpty && !getStop()) {
      if (scrollAtive) {
        if (offset >= position.maxScrollExtent) {
          scrollToTop();
        } else {
          animateTo(offset + height,
              curve: Curves.linear,
              duration: Duration(milliseconds: DURATION_SCROLL_MILLISECONDS));
        }
      }
    }
  }

  bool isSelected(int index, double itemSize) {
    bool select = getStop() &&
        positionStoped > ScrollBackMenuListView.DEFAULT_INIT_POSITION_STOP &&
        getIndexStopped(itemSize) == index;
    if (select) {
      if (positionStoped != index * itemSize) {
        forceSelectedJustElement(index * itemSize);
      }
    }
    return select;
  }

  int getIndexStopped(double itemSize) {
    return (positionStoped / itemSize).round();
  }

  updateWord(String word) {
    this._word += word;
  }

  getWord() {
    return this._word;
  }
}
