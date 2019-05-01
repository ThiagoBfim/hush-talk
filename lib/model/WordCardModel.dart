import 'CardModel.dart';

class WordCardModel extends CardModel{
  final String avatar;
  final String title;
  final String specialAction;

  WordCardModel({
    this.avatar,
    this.title,
    this.specialAction = ""
  });
}
