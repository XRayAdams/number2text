import 'package:flutter_test/flutter_test.dart';
import 'package:number2text/converter/lng/english_converter.dart';

void main() {
  group('EnglishConverter', () {
    final converter = EnglishConverter();

    test('should convert single digits', () {
      expect(converter.convert(0), 'zero');
      expect(converter.convert(5), 'five');
      expect(converter.convert(9), 'nine');
    });

    test('should convert numbers less than 20', () {
      expect(converter.convert(10), 'ten');
      expect(converter.convert(15), 'fifteen');
      expect(converter.convert(19), 'nineteen');
    });

    test('should convert tens', () {
      expect(converter.convert(20), 'twenty');
      expect(converter.convert(50), 'fifty');
      expect(converter.convert(90), 'ninety');
    });

    test('should convert numbers less than 100', () {
      expect(converter.convert(25), 'twenty five');
      expect(converter.convert(58), 'fifty eight');
      expect(converter.convert(99), 'ninety nine');
    });

    test('should convert hundreds', () {
      expect(converter.convert(100), 'one hundred');
      expect(converter.convert(500), 'five hundred');
      expect(converter.convert(900), 'nine hundred');
    });

    test('should convert numbers less than 1000', () {
      expect(converter.convert(101), 'one hundred and one');
      expect(converter.convert(555), 'five hundred and fifty five');
      expect(converter.convert(999), 'nine hundred and ninety nine');
    });

    test('should convert thousands', () {
      expect(converter.convert(1000), 'one thousand');
      expect(converter.convert(5000), 'five thousand');
      expect(converter.convert(9000), 'nine thousand');
    });

    test('should convert numbers less than 1,000,000', () {
      expect(converter.convert(1001), 'one thousand one');
      expect(converter.convert(5555), 'five thousand five hundred and fifty five');
      expect(converter.convert(999999), 'nine hundred and ninety nine thousand nine hundred and ninety nine');
    });

    test('should convert millions', () {
      expect(converter.convert(1000000), 'one million');
    });

     test('should convert billions', () {
      expect(converter.convert(1000000000), 'one billion');
    });

    test('should convert negative numbers', () {
      expect(converter.convert(-5), 'minus five');
    });

  });
}
