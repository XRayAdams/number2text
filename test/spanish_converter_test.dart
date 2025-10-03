import 'package:flutter_test/flutter_test.dart';
import 'package:number2text/converter/lng/spanish_converter.dart';

void main() {
  group('SpanishConverter', () {
    final converter = SpanishConverter();

    test('should convert single digits', () {
      expect(converter.convert(0), 'cero');
      expect(converter.convert(5), 'cinco');
      expect(converter.convert(9), 'nueve');
    });

    test('should convert numbers less than 20', () {
      expect(converter.convert(10), 'diez');
      expect(converter.convert(15), 'quince');
      expect(converter.convert(19), 'diecinueve');
    });

    test('should convert tens', () {
      expect(converter.convert(20), 'veinte');
      expect(converter.convert(50), 'cincuenta');
      expect(converter.convert(90), 'noventa');
    });

    test('should convert numbers less than 100', () {
      expect(converter.convert(25), 'veinte y cinco');
      expect(converter.convert(58), 'cincuenta y ocho');
      expect(converter.convert(99), 'noventa y nueve');
    });

    test('should convert hundreds', () {
      expect(converter.convert(100), 'cien');
      expect(converter.convert(500), 'quinientos');
      expect(converter.convert(900), 'novecientos');
    });

    test('should convert numbers less than 1000', () {
      expect(converter.convert(101), 'ciento uno');
      expect(converter.convert(555), 'quinientos cincuenta y cinco');
      expect(converter.convert(999), 'novecientos noventa y nueve');
    });

    test('should convert thousands', () {
      expect(converter.convert(1000), 'mil');
      expect(converter.convert(5000), 'cinco mil');
      expect(converter.convert(9000), 'nueve mil');
    });

    test('should convert numbers less than 1,000,000', () {
      expect(converter.convert(1001), 'mil uno');
      expect(converter.convert(5555), 'cinco mil quinientos cincuenta y cinco');
      expect(converter.convert(999999), 'novecientos noventa y nueve mil novecientos noventa y nueve');
    });

    test('should convert millions', () {
      expect(converter.convert(1000000), 'un millón');
    });

    test('should convert negative numbers', () {
      expect(converter.convert(-5), 'menos cinco');
    });

    test('should convert billions', () {
      expect(converter.convert(1000000000), 'mil millones');
      expect(converter.convert(2000000000), 'dos mil millones');
      expect(converter.convert(1234567890), 'mil doscientos treinta y cuatro millones quinientos sesenta y siete mil ochocientos noventa');
    });
  });
}
