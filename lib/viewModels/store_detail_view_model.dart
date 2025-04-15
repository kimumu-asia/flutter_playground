import 'package:flutter/material.dart';

class StoreDetailViewModel extends ChangeNotifier {
  Map<String, dynamic>? _store;

  StoreDetailViewModel({Map<String, dynamic>? store}) {
    _store = store ?? {};
  }

  Map<String, dynamic> get store => _store ?? {};

  void setStore(Map<String, dynamic> storeData) {
    _store = storeData;
    notifyListeners();
  }
}
