import 'base_converter.dart';

class EnglishConverter implements BaseConverter {
  @override
  String get name => "English";

  static const List<String> _ones = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
    "seventeen",
    "eighteen",
    "nineteen"
  ];

  static const List<String> _tens = [
    "",
    "",
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety"
  ];

  @override
  String convert(int input) {
    if (input < 0) {
      return "minus ${convert(-input)}";
    }
    if (input < 20) {
      return _ones[input];
    }
    if (input < 100) {
      return "${_tens[input ~/ 10]}${input % 10 != 0 ? " ${_ones[input % 10]}" : ""}";
    }
    if (input < 1000) {
      return "${_ones[input ~/ 100]} hundred${input % 100 != 0 ? " and ${convert(input % 100)}" : ""}";
    }
    if (input < 1000000) {
      return "${convert(input ~/ 1000)} thousand${input % 1000 != 0 ? " ${convert(input % 1000)}" : ""}";
    }
    if (input < 1000000000) {
      return "${convert(input ~/ 1000000)} million${input % 1000000 != 0 ? " ${convert(input % 1000000)}" : ""}";
    }
    if (input < 1000000000000) {
      return "${convert(input ~/ 1000000000)} billion${input % 1000000000 != 0 ? " ${convert(input % 1000000000)}" : ""}";
    }
    return "Number too large";
  }
}
