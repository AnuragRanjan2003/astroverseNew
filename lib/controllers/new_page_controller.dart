import 'dart:developer';

import 'package:get/get.dart';

class NewPageController extends GetxController {
  static const _list = {
    'advanced horoscope': 0,
    'event prediction': 1,
    'astro challenge': 2,
    'self promotion': 3,
    'planetary change': 4,
    'vastu': 5,
    'lal kitab': 6,
    'Tantra/Mantra': 7,
    'remedy': 8,
    'Astro  upaay': 9,
  };
  static const genresList = [
    'advanced horoscope',
    'event prediction',
    'astro challenge',
    'self promotion',
    'planetary change',
    'vastu',
    'lal kitab',
    'Tantra/Mantra',
    'remedy',
    'Astro  upaay',
  ];

  RxList<bool> genres = List.generate(genresList.length, (index) => false).obs;
  RxList<String> selectedGenres = <String>[].obs;

  void addItem(int i) {
    genres[i] = true;
    selectedGenres.clear();
    for (int i = 0; i < genresList.length; i++) {
      if (genres[i] == true) selectedGenres.add(genresList[i]);
    }
    log("$selectedGenres", name: "GENRES");
  }

  void removeItem(int i) {
    genres[i] = false;
    selectedGenres.clear();
    for (int i = 0; i < genresList.length; i++) {
      if (genres[i] == true) selectedGenres.add(genresList[i]);
    }
    log("$selectedGenres", name: "GENRES");
  }

  toGenre(List<String> l) {
    if (l.isEmpty) return genresList;
    return l;
  }
}
