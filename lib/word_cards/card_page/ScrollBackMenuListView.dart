import 'package:flutter/material.dart';
import 'package:hush_talk/model/CardModel.dart';

class ScrollBackMenuListView extends ScrollController {
  static const int _PIXELS_BACK_WHEN_STOP = 30;
  static const double DEFAULT_INIT_POSITION_STOP =
      _PIXELS_BACK_WHEN_STOP * -1 + -1.0;
  final int durationScrollMilliseconds;
  final int sizePiscadasToChangeAction;
  final VoidCallback backMenu;
  bool _stop = false;
  int _piscadas = 0;
  bool scrollAtive = true;
  bool _scrollingToTop = false;
  double positionStoped = DEFAULT_INIT_POSITION_STOP;

  final List<CardModel> cardList;

  ScrollBackMenuListView(
      {@required this.backMenu,
      @required this.cardList,
      int durationScrollMilliseconds = 4500,
      int sizePiscadasToChangeAction = 6})
      : this.sizePiscadasToChangeAction = sizePiscadasToChangeAction,
        this.durationScrollMilliseconds = durationScrollMilliseconds;

  _scrollToTop() {
    this.animateTo(this.position.minScrollExtent,
        duration: Duration(milliseconds: 1), curve: Curves.easeIn);
    _scrollingToTop = false;
  }

  scrollToBottom() {
    this.animateTo(this.position.maxScrollExtent,
        duration: Duration(milliseconds: 1), curve: Curves.easeOut);
  }

  stopAndScrollBack() {
    setStop(true);
    if (scrollAtive) {
      //TODO exibir o som do item selecioando de acordo com os pixels -> this.position.pixels;
      scrollBack();
      setPiscadas(0);
      forceSelectedJustElement(positionStoped);
    }
  }

  void scrollBack() {
    positionStoped = this.offset - _PIXELS_BACK_WHEN_STOP;
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
    if (_piscadas >= sizePiscadasToChangeAction) {
      if (!scroll) {
        Function.apply(backMenu, []);
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
          scrollingToTop();
        } else {
          scroll(height);
        }
      }
    }
  }

  void scrollingToTop() {
     if(!_scrollingToTop) {
      new Future.delayed(const Duration(seconds: 1)).then((v) {
        _scrollToTop();
      });
      _scrollingToTop = true;
    }
  }

  void scroll(double height) {
    animateTo(offset + height,
        curve: Curves.linear,
        duration: Duration(milliseconds: durationScrollMilliseconds));
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

  int get getPixelsBackWhenStop => _PIXELS_BACK_WHEN_STOP;

  int get getPiscadas => _piscadas;

  setPiscadas(int piscada) {
    this._piscadas = piscada;
  }
}
