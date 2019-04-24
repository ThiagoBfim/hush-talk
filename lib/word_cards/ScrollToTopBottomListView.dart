import 'package:flutter/material.dart';

class ScrollToTopBottomListView extends ScrollController {
  static const int _SIZE_PISCADAS_TO_CHANGE_ACTION = 7;
  static const int _PIXELS_BACK_WHEN_STOP = 30;
  static const DURATION_SCROLL_MILLISECONDS = 4500;
  bool _stop = false;
  int _piscadas = 0;
  bool downScroll = true;

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
    if (downScroll) {
      //TODO exibir o som do item selecioando de acordo com os pixels -> this.position.pixels;
      this.position.jumpTo(this.offset - _PIXELS_BACK_WHEN_STOP);
    } else {
      this.position.jumpTo(this.offset + _PIXELS_BACK_WHEN_STOP);
    }
  }

  bool getStop() {
    return _stop;
  }

  setStop(bool stop) {
    this._stop = stop;
  }

  incrementPiscadas(bool downScroll) {
    _piscadas++;
    if (_piscadas >= _SIZE_PISCADAS_TO_CHANGE_ACTION) {
      setStop(false);
      this.downScroll = downScroll;
      _piscadas = 0;
    }
  }

  moveUp(double height) {
    if (offset <= position.minScrollExtent) {
      scrollToBottom();
    } else {
      animateTo(offset - height,
          curve: Curves.linear,
          duration: Duration(milliseconds: DURATION_SCROLL_MILLISECONDS));
    }
  }

  moveDown(double height) {
    if (offset >= position.maxScrollExtent) {
      scrollToTop();
    } else {
      animateTo(offset + height,
          curve: Curves.linear,
          duration: Duration(milliseconds: DURATION_SCROLL_MILLISECONDS));
    }
  }

  void move(double height) {
    if (positions.isNotEmpty && !getStop()) {
      if (downScroll) {
        moveDown(height);
      } else {
        moveUp(height);
      }
    }
  }
}
