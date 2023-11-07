import 'dart:core';

class NumberParser {

  String toSocialMediaString(int? num) {
    if (num == null ) return "0";
    if (num < 1000) {
      return num.toString();
    } else if (num < 1000000) {
      return "${(num/ 1000).toStringAsFixed(2)} K";
    } else {
      return "${(num/ 1000000).toStringAsFixed(2)} M";
    }
  }
}
