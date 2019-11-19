import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hush_talk/model/CardModel.dart';
import 'package:hush_talk/word_cards/ListAbsctractPage.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import 'ListDynamicCards.dart';

class ListDynamicCardsPage extends ListAbsctractPage {
  ListDynamicCardsPage();

  @override
  createState() {
    return _ListDynamicCardsPageState();
  }
}

class _ListDynamicCardsPageState extends ListAbsctractPageState {
  bool _pageChanged = false;

  _ListDynamicCardsPageState();

  @override
  ScrollBackMenuListView initScrollController() {
    var scrollBackMenuListView = ScrollBackMenuListView(backMenu: _backMenu, cardList: []);
    updateCardList();
    return scrollBackMenuListView;
  }

  updateCardList() async {
    var root = await getExternalStorageDirectory();
    var files = await FileManager(root: root).walk().toList();
    List<CardModel> cardList = [];
    for (dynamic file in files.skip(1)) {
      cardList.add(CardModel(avatar: file.path));
    }
    this.controller.cardList = cardList;
    return files;
  }

  @override
  Widget createList() {
    return Scaffold(
      body: ListDynamicCards(scanResults, camera, controller),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveImage,
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _saveImage() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      print(appDocPath);
      appDocDir.list();

      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      GallerySaver.saveImage(image.path);
      controller.goBackToMenu();
    } catch (ex) {
      print(ex);
    }
  }

  _backMenu() {
    var route = ModalRoute.of(context);
    if (route != null && !_pageChanged) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _pageChanged = true;
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyHomePage(anuncioWasShown: false)));
        });
      });
    }
  }
}
