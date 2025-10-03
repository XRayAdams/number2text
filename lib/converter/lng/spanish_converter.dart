import 'base_converter.dart';

class SpanishConverter implements BaseConverter {
  @override
  String get name => "Spanish";

  @override
  String get native_number_too_large_error_text => "Número demasiado grande";

  static const List<String> _ones = [
    "cero",
    "uno",
    "dos",
    "tres",
    "cuatro",
    "cinco",
    "seis",
    "siete",
    "ocho",
    "nueve",
    "diez",
    "once",
    "doce",
    "trece",
    "catorce",
    "quince",
    "dieciséis",
    "diecisiete",
    "dieciocho",
    "diecinueve"
  ];

  static const List<String> _tens = [
    "",
    "",
    "veinte",
    "treinta",
    "cuarenta",
    "cincuenta",
    "sesenta",
    "setenta",
    "ochenta",
    "noventa"
  ];

  @override
  String convert(int input) {
     if (input > 999999999999) {
      return native_number_too_large_error_text;
    }

    if (input < 0) {
      return "menos ${convert(-input)}";
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
      return "${_tens[ten]} y ${_ones[unit]}";
    }
    if (input < 1000) {
      final hundred = input ~/ 100;
      final remainder = input % 100;
      if (input == 100) return "cien";

      String hundredsStr;
      if (hundred == 1) {
        hundredsStr = "ciento";
      } else if (hundred == 5) {
        hundredsStr = "quinientos";
      } else if (hundred == 7) {
        hundredsStr = "setecientos";
      } else if (hundred == 9) {
        hundredsStr = "novecientos";
      } else {
        hundredsStr = "${_ones[hundred]}cientos";
      }

      if (remainder == 0) return hundredsStr;

      return "$hundredsStr ${convert(remainder)}";
    }
    if (input < 1000000) {
      final thousands = input ~/ 1000;
      final remainder = input % 1000;

      String thousandsStr;
      if (thousands == 1) {
        thousandsStr = "mil";
      } else {
        thousandsStr = "${convert(thousands)} mil";
      }

      if (remainder == 0) return thousandsStr;

      return "$thousandsStr ${convert(remainder)}";
    }
    if (input < 1000000000) {
      final millions = input ~/ 1000000;
      final remainder = input % 1000000;

      String millionsStr;
      if (millions == 1) {
        millionsStr = "un millón";
      } else {
        millionsStr = "${convert(millions)} millones";
      }

      if (remainder == 0) return millionsStr;

      return "$millionsStr ${convert(remainder)}";
    }
    if (input < 1000000000000) {
      final billions = input ~/ 1000000000;
      final remainder = input % 1000000000;

      String billionsStr;
      if (billions == 1) {
        billionsStr = "mil millones";
      } else {
        billionsStr = "${convert(billions)} mil millones";
      }

      if (remainder == 0) return billionsStr;

      return "$billionsStr ${convert(remainder)}";
    }

    return native_number_too_large_error_text;
  }
}
