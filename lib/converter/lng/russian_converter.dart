// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

import 'base_converter.dart';

class RussianConverter implements BaseConverter {
  @override
  String get name => "Russian";

  @override
  String get native_number_too_large_error_text => "число слишком большое";

  static const List<String> _ones = [
    "ноль",
    "один",
    "два",
    "три",
    "четыре",
    "пять",
    "шесть",
    "семь",
    "восемь",
    "девять",
    "десять",
    "одиннадцать",
    "двенадцать",
    "тринадцать",
    "четырнадцать",
    "пятнадцать",
    "шестнадцать",
    "семнадцать",
    "восемнадцать",
    "девятнадцать"
  ];

  static const List<String> _tens = [
    "",
    "",
    "двадцать",
    "тридцать",
    "сорок",
    "пятьдесят",
    "шестьдесят",
    "семьдесят",
    "восемьдесят",
    "девяносто"
  ];

  static const List<String> _hundreds = [
    "",
    "сто",
    "двести",
    "триста",
    "четыреста",
    "пятьсот",
    "шестьсот",
    "семьсот",
    "восемьсот",
    "девятьсот"
  ];

  @override
  String convert(int input) {
    if (input > 999999999999) {
      return native_number_too_large_error_text;
    }

    if (input < 0) {
      return "минус ${_convert(input.abs())}";
    }

    if (input == 0) {
      return "ноль";
    }

    return _convert(input);
  }

  String _convert(int input, {bool feminine = false}) {
    if (input == 0) {
      return "";
    }

    if (input < 1000) {
      return _convertLessThanThousand(input, feminine: feminine);
    }

    final denominations = [
      [1000000000, 'миллиард', 'миллиарда', 'миллиардов', false],
      [1000000, 'миллион', 'миллиона', 'миллионов', false],
      [1000, 'тысяча', 'тысячи', 'тысяч', true],
    ];

    for (var denom in denominations) {
      final limit = denom[0] as int;
      if (input >= limit) {
        final head = input ~/ limit;
        final tail = input % limit;
        final headStr = _convert(head, feminine: denom[4] as bool);
        final pluralStr = _pluralize(head, denom[1] as String, denom[2] as String, denom[3] as String);
        final tailStr = tail > 0 ? " ${_convert(tail)}" : "";
        return "$headStr $pluralStr$tailStr".trim();
      }
    }
    
    return "";
  }

  String _convertLessThanThousand(int num, {bool feminine = false}) {
    if (num == 0) return "";

    List<String> parts = [];

    int hundreds = num ~/ 100;
    if (hundreds > 0) {
      parts.add(_hundreds[hundreds]);
      num %= 100;
    }

    if (num >= 20) {
      int tens = num ~/ 10;
      parts.add(_tens[tens]);
      num %= 10;
    }

    if (num > 0) {
      if (feminine && (num == 1 || num == 2)) {
        parts.add(num == 1 ? "одна" : "две");
      } else {
        parts.add(_ones[num]);
      }
    }

    return parts.join(' ');
  }

  String _pluralize(int count, String one, String two, String five) {
    int lastDigit = count % 10;
    int lastTwoDigits = count % 100;

    if (lastTwoDigits >= 11 && lastTwoDigits <= 19) {
      return five;
    }
    if (lastDigit == 1) {
      return one;
    }
    if (lastDigit >= 2 && lastDigit <= 4) {
      return two;
    }
    return five;
  }
}
