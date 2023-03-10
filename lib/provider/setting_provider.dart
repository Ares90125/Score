import 'package:flutter/material.dart';
import 'package:test/common/helper.dart';
class SettingProvider extends ChangeNotifier {
  String title='basketball';
  int maxPlayerCount=3;
  bool winnerByTwo=true;
  bool winnerServe=true;
  int playerNumber=2;
  int bestOfNumber=1;
  int points=11;
   get gettitlet => title;
  void setTitle(String value) {
    title = value;
    notifyListeners();
  }
  get getmaxPlayerCount => maxPlayerCount;
  void setMaxPlayerCount(int count) {
    maxPlayerCount = count;
    notifyListeners();
  }
  get getwinnerByTwo => winnerByTwo;
  void setWinnerByTwo(bool value) {
    winnerByTwo = value;
    notifyListeners();
  }
  get getwinnerServe => winnerServe;
  void setWinnerServe(bool value) {
    winnerServe = value;
    notifyListeners();
  }
  get getPlayerNumber => playerNumber;
  void setPlayerNumber(int value) {
    playerNumber = value;
    notifyListeners();
  }
  get getBestOfNumber => bestOfNumber;
  void setBestOfNumber(int value) {
    bestOfNumber = value;
    notifyListeners();
  }
  get getPoints => points;
  void setPonts(int value) {
    points = value;
    notifyListeners();
  }
  
}
