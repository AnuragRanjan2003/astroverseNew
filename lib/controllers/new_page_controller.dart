import 'package:get/get.dart';

class NewPageController extends GetxController {
  static const genresList = ["a", "b"];
  RxList<bool> genres = List.generate(genresList.length, (index) => false).obs;

  RxList<String> selectedGenres = <String>[].obs;

  void addItem(int i) {
    genres[i] = true;
    for (int i = 0; i < genresList.length; i++) {
      if (genres[i] == true) selectedGenres.add(genresList[i]);
      ;
    }
  }

  void removeItem(int i) {
    genres[i] = false;
    for (int i = 0; i < genresList.length; i++) {
      if (genres[i] == true) selectedGenres.add(genresList[i]);
      ;
    }
  }
}
