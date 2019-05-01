import 'CardModel.dart';

class MenuCardModel extends CardModel{
  final String avatar;
  final String title;
  final List<CardModel> cardList;

  MenuCardModel({
    this.avatar,
    this.title,
    this.cardList,
  });
}
