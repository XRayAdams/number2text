// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

import 'base_converter.dart';

class ItalianConverter implements BaseConverter {
  @override
  String get name => "Italian";

  @override
  String get native_number_too_large_error_text => "Numero troppo grande";

  static const List<String> _ones = [
    "zero",
    "uno",
    "due",
    "tre",
    "quattro",
    "cinque",
    "sei",
    "sette",
    "otto",
    "nove",
    "dieci",
    "undici",
    "dodici",
    "tredici",
    "quattordici",
    "quindici",
    "sedici",
    "diciassette",
    "diciotto",
    "diciannove"
  ];

  static const List<String> _tens = [
    "",
    "",
    "venti",
    "trenta",
    "quaranta",
    "cinquanta",
    "sessanta",
    "settanta",
    "ottanta",
    "novanta"
  ];

  @override
  String convert(int input) {
    if (input > 999999999999) {
      return native_number_too_large_error_text;
    }

    if (input < 0) {
      return "meno ${convert(-input)}";
    }
    if (input < 20) {
      return _ones[input];
    }
    if (input < 100) {
      final ten = input ~/ 10;
      final unit = input % 10;
      if (unit == 0) {
        return _tens[ten];
      }
      if (unit == 1 || unit == 8) {
        return "${_tens[ten].substring(0, _tens[ten].length - 1)}${_ones[unit]}";
      }
      return "${_tens[ten]}${_ones[unit]}";
    }
    if (input < 1000) {
      final hundred = input ~/ 100;
      final remainder = input % 100;
      String hundredsStr;
      if (hundred == 1) {
        hundredsStr = "cento";
      } else {
        hundredsStr = "${_ones[hundred]}cento";
      }
      if (remainder == 0) return hundredsStr;

      if ([1, 8].contains(remainder % 10)) {
        return "${hundredsStr.substring(0, hundredsStr.length - 1)}${convert(remainder)}";
      }

      return "$hundredsStr${convert(remainder)}";
    }
    if (input < 1000000) {
      final thousands = input ~/ 1000;
      final remainder = input % 1000;
      String thousandsStr;
      if (thousands == 1) {
        thousandsStr = "mille";
      } else {
        thousandsStr = "${convert(thousands)}mila";
      }
      if (remainder == 0) return thousandsStr;
      return "$thousandsStr${convert(remainder)}";
    }
    if (input < 1000000000) {
      if (input == 1000000) {
        return "un milione";
      }
      return "${convert(input ~/ 1000000)} milioni${input % 1000000 != 0 ? " ${convert(input % 1000000)}" : ""}";
    }
    if (input < 1000000000000) {
      if (input == 1000000000) {
        return "un miliardo";
      }
      return "${convert(input ~/ 1000000000)} miliardi${input % 1000000000 != 0 ? " ${convert(input % 1000000000)}" : ""}";
    }
    return native_number_too_large_error_text;
  }
}
