import 'package:flutter/material.dart';

class SearchQuery with ChangeNotifier {
  String text = '';

  void updadeText(String newText) {
    text = newText;
    notifyListeners();
  }
}