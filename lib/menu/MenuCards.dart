import 'package:hush_talk/model/MenuCardModel.dart';
import 'package:hush_talk/word_cards/cards/NecessidadesCards.dart';
import 'package:hush_talk/word_cards/cards/WordsCards.dart';

final menuCards = <MenuCardModel>[
  MenuCardModel(
    title: "Alfabeto",
    avatar: "images/menu/alfabeto.jpg",
    cardList: getWordsCards,
  ),
  MenuCardModel(
    title: "Necessidades",
    avatar: "images/menu/necessidades.jpg",
    cardList: necessidadesCards,
  ),
  MenuCardModel(
    title: "Images",
    avatar: "images/menu/stickers.jpg",
    cardList: null,
  )
];
