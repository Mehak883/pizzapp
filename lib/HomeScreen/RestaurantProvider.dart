// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class RestProvider with ChangeNotifier {
  List<List<dynamic>> topRestList = [
    [1, 'Lorem ipsum', 'assets/1.jpg'],
    [2, 'Lorem ipsum', 'assets/2.jpg'],
    [3, 'Lorem ipsum', 'assets/3.jpg'],
    [4, 'Lorem ipsum', 'assets/4.jpg'],
    [5, 'Lorem ipsum', 'assets/5.jpg'],
  ];
  
  List<List<dynamic>> nearRestList = [
    [6, 'Lorem ipsum', 'assets/1.jpg'],
    [7, 'Lorem ipsum', 'assets/2.jpg'],
    [8, 'Lorem ipsum', 'assets/3.jpg'],
    [9, 'Lorem ipsum', 'assets/4.jpg'],
    [10, 'Lorem ipsum', 'assets/5.jpg'],
  ];

  List<int> favourite = [];

  void addFav(int id) {
    if (!favourite.contains(id)) {
      favourite.add(id);
      notifyListeners();
    }
  }

  void remFav(int id) {
    favourite.remove(id);
    notifyListeners();
  }

  List<List<dynamic>> getFavourites() {
    List<List<dynamic>> allRestList = [...topRestList, ...nearRestList];
    return allRestList.where((rest) => favourite.contains(rest[0])).toList();
  }
}
