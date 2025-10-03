// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

import 'base_converter.dart';

class FrenchConverter implements BaseConverter {
  @override
  String get name => "French";
  
  @override
  String get native_number_too_large_error_text => "Nombre trop grand";


  static const List<String> _ones = [
    "zéro",
    "un",
    "deux",
    "trois",
    "quatre",
    "cinq",
    "six",
    "sept",
    "huit",
    "neuf",
    "dix",
    "onze",
    "douze",
    "treize",
    "quatorze",
    "quinze",
    "seize",
    "dix-sept",
    "dix-huit",
    "dix-neuf"
  ];

  static const List<String> _tens = [
    "",
    "dix",
    "vingt",
    "trente",
    "quarante",
    "cinquante",
    "soixante",
    "soixante-dix",
    "quatre-vingts",
    "quatre-vingt-dix"
  ];

  @override
  String convert(int input) {
     if (input > 999999999999) {
      return native_number_too_large_error_text;
    }

    if (input < 0) {
      return "moins ${convert(-input)}";
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
      if (ten == 7 || ten == 9) {
        return "${_tens[ten - 1]}-${_ones[10 + unit]}";
      }
      if (ten == 8) {
        return "${_tens[ten]}-${_ones[unit]}";
      }
      if (unit == 1) {
        return "${_tens[ten]} et un";
      }
      return "${_tens[ten]}-${_ones[unit]}";
    }
    if (input < 1000) {
      final hundred = input ~/ 100;
      final remainder = input % 100;
      String hundredsStr;
      if (hundred == 1) {
        hundredsStr = "cent";
      } else {
        hundredsStr = "${_ones[hundred]} cents";
      }
      if (remainder == 0) return hundredsStr;
      return "$hundredsStr ${convert(remainder)}";
    }
    if (input < 1000000) {
      final thousands = input ~/ 1000;
      final remainder = input % 1000;
      String thousandsStr;
      if (thousands == 1) {
        thousandsStr = "mille";
      } else {
        thousandsStr = "${convert(thousands)} mille";
      }
      if (remainder == 0) return thousandsStr;
      return "$thousandsStr ${convert(remainder)}";
    }
    if (input < 1000000000) {
      final millions = input ~/ 1000000;
      final remainder = input % 1000000;
      String millionsStr;
      if (millions == 1) {
        millionsStr = "un million";
      } else {
        millionsStr = "${convert(millions)} millions";
      }
      if (remainder == 0) return millionsStr;
      return "$millionsStr ${convert(remainder)}";
    }
    if (input < 1000000000000) {
      final billions = input ~/ 1000000000;
      final remainder = input % 1000000000;
      String billionsStr;
      if (billions == 1) {
        billionsStr = "un milliard";
      } else {
        billionsStr = "${convert(billions)} milliards";
      }
      if (remainder == 0) return billionsStr;
      return "$billionsStr ${convert(remainder)}";
    }
    return native_number_too_large_error_text;
  }
}
