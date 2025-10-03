// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

import 'base_converter.dart';

class GermanConverter implements BaseConverter {
  @override
  String get name => "German";

  @override
  String get native_number_too_large_error_text => "Nummer zu groß";

  static const List<String> _ones = [
    "null",
    "eins",
    "zwei",
    "drei",
    "vier",
    "fünf",
    "sechs",
    "sieben",
    "acht",
    "neun",
    "zehn",
    "elf",
    "zwölf",
    "dreizehn",
    "vierzehn",
    "fünfzehn",
    "sechzehn",
    "siebzehn",
    "achtzehn",
    "neunzehn"
  ];

  static const List<String> _tens = [
    "",
    "",
    "zwanzig",
    "dreißig",
    "vierzig",
    "fünfzig",
    "sechzig",
    "siebzig",
    "achtzig",
    "neunzig"
  ];

  @override
  String convert(int input) {
     if (input > 999999999999) {
      return native_number_too_large_error_text;
    }

    if (input < 0) {
      return "minus ${convert(-input)}";
    }
    if (input == 0) {
      return "null";
    }
    if (input < 20) {
      return _ones[input];
    }
    if (input < 100) {
      final ten = input ~/ 10;
      final unit = input % 10;
      if (unit == 0) {
        return _tens[ten];
      } else if (unit == 1) {
        return "einund${_tens[ten]}";
      }
      return "${_ones[unit]}und${_tens[ten]}";
    }
    if (input < 1000) {
      final hundred = input ~/ 100;
      final remainder = input % 100;
      String hundredsStr = "hundert";
      if (hundred > 1) {
        hundredsStr = "${_ones[hundred]}hundert";
      }
      if (remainder == 0) return hundredsStr;
      return "$hundredsStr${convert(remainder)}";
    }
    if (input < 1000000) {
      final thousands = input ~/ 1000;
      final remainder = input % 1000;
      String thousandsStr;
      if (thousands == 1) {
        thousandsStr = "eintausend";
      } else {
        thousandsStr = "${convert(thousands)}tausend";
      }
      if (remainder == 0) return thousandsStr;
      return "$thousandsStr${convert(remainder)}";
    }
    if (input < 1000000000) {
      final millions = input ~/ 1000000;
      final remainder = input % 1000000;
      String millionsStr;
      if (millions == 1) {
        millionsStr = "eine Million";
      } else {
        millionsStr = "${convert(millions)} Millionen";
      }
      if (remainder == 0) return millionsStr;
      return "$millionsStr ${convert(remainder)}";
    }
    if (input < 1000000000000) {
      final billions = input ~/ 1000000000;
      final remainder = input % 1000000000;
      String billionsStr;
      if (billions == 1) {
        billionsStr = "eine Milliarde";
      } else {
        billionsStr = "${convert(billions)} Milliarden";
      }
      if (remainder == 0) return billionsStr;
      return "$billionsStr ${convert(remainder)}";
    }
    return native_number_too_large_error_text;
  }
}
