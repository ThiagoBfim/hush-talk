import 'package:flutter/material.dart';
import 'package:hush_talk/ml_widget/EyeDetector.dart';
import 'package:hush_talk/model/CardModel.dart';

class ScrollBackMenuListView extends ScrollController {
  static const int _PIXELS_BACK_WHEN_STOP = 30;
  static const double DEFAULT_INIT_POSITION_STOP =
      _PIXELS_BACK_WHEN_STOP * -1 + -1.0;
  final int durationScrollMilliseconds;
  final int qtdPiscadasEsquerdasToChangeAction;
  final int qtdPiscadasDireitasToChangeAction;
  final int qtdPiscadasDoisOlhosToChangeAction = 2;
  final VoidCallback backMenu;
  bool _stop = false;
  int _piscadasEsquerdas = 0;
  int _piscadasDireitas = 0;
  int _piscadasDoisOlhos = 0;
  bool scrollAtive = true;
  bool _scrollingToTop = false;
  double positionStoped = DEFAULT_INIT_POSITION_STOP;

  List<CardModel> cardList;

  ScrollBackMenuListView(
      {@required this.backMenu,
      @required this.cardList,
      int durationScrollMilliseconds = 4500,
      int qtdPiscadasDireitasToChangeAction = 4,
      int qtdPiscadasEsquerdasToChangeAction = 5})
      : this.qtdPiscadasEsquerdasToChangeAction =
            qtdPiscadasEsquerdasToChangeAction,
        this.qtdPiscadasDireitasToChangeAction =
            qtdPiscadasDireitasToChangeAction,
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
      resetPiscadas();
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

  doAction() {
    if (_piscadasDireitas >= qtdPiscadasDireitasToChangeAction) {
      olhoDireitoAction();
      print("Olho direito action");
    }
    if (_piscadasEsquerdas >= qtdPiscadasEsquerdasToChangeAction) {
      olhoEsquerdoAction();
      print("Olho esquerdo action");
    }
    if (_piscadasDoisOlhos >= qtdPiscadasDoisOlhosToChangeAction) {
      closeTwoEyesAction();
      print("Dois olhos action");
    }
  }

  void olhoDireitoAction() {
    setStop(false);
    this.scrollAtive = true;
    resetPiscadas();
  }

  void olhoEsquerdoAction() {
    goBackToMenu();
    setStop(true);
    resetPiscadas();
  }

  void goBackToMenu() {
    Function.apply(backMenu, []);
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
    if (!_scrollingToTop) {
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

  void updateAction(EyeDector eyeDector) {
    if (!getStop() && eyeDector.getCompleteEyesClosed()) {
      _piscadasDoisOlhos += 1;
      doAction();
    } else if (eyeDector.getRightEyeClosed()) {
      _piscadasDireitas += 1;
      doAction();
    } else if (eyeDector.getLeftEyeClosed()) {
      _piscadasEsquerdas += 1;
      doAction();
    } else {}
  }

  void closeTwoEyesAction() {
    stopAndScrollBack();
    resetPiscadas();
  }

  void resetPiscadas() {
    _piscadasEsquerdas = 0;
    _piscadasDireitas = 0;
    _piscadasDoisOlhos = 0;
  }
}
