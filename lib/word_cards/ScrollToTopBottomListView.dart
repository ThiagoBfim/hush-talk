import 'package:flutter/material.dart';

class ScrollToTopBottomListView  extends ScrollController{

   bool _stop = false;
   int _piscadas = 0;

    scrollToTop() {
      this.animateTo(this.position.minScrollExtent,
                duration: Duration(milliseconds: 1), curve: Curves.easeIn);
    }

    stopAndScrollBack(){
      setStop(true);
      this.position.jumpTo(this.offset-1);
    }

    scrollToBottom() {
      this.animateTo(this.position.maxScrollExtent,
                duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
    }

    bool getStop(){
      return _stop;
    }
    setStop(bool stop){
      this._stop = stop;
    }

    incrementPiscadas(){
      _piscadas ++;
      if(_piscadas >= 3) {
        setStop(false);
        _piscadas = 0;
      }
    }

   moveDown(double height) {
     if (positions.isNotEmpty && !getStop()) {
       var locale = offset + height;
       if (offset >= position.maxScrollExtent) {
         scrollToTop();
       } else {
         animateTo(locale,
             curve: Curves.linear, duration: Duration(milliseconds: 3500));
       }
     }
   }

}