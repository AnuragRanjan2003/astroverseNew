import 'dart:developer';

import 'package:get/get.dart';

class NewPageController extends GetxController {

  static const genresList = [
    'astro challenge',
    'advanced horoscope',
    'event prediction',
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
