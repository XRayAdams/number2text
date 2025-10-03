import 'package:flutter_test/flutter_test.dart';
import 'package:number2text/converter/lng/russian_converter.dart';

void main() {
  group('RussianConverter', () {
    final converter = RussianConverter();

    test('should convert single digits', () {
      expect(converter.convert(0), 'ноль');
      expect(converter.convert(1), 'один');
      expect(converter.convert(5), 'пять');
    });

    test('should convert numbers less than 100', () {
      expect(converter.convert(21), 'двадцать один');
      expect(converter.convert(99), 'девяносто девять');
    });

    test('should convert hundreds', () {
      expect(converter.convert(100), 'сто');
      expect(converter.convert(101), 'сто один');
      expect(converter.convert(121), 'сто двадцать один');
      expect(converter.convert(555), 'пятьсот пятьдесят пять');
    });

    test('should convert thousands', () {
      expect(converter.convert(1000), 'одна тысяча');
      expect(converter.convert(2000), 'две тысячи');
      expect(converter.convert(5000), 'пять тысяч');
      expect(converter.convert(1234), 'одна тысяча двести тридцать четыре');
      expect(converter.convert(5555), 'пять тысяч пятьсот пятьдесят пять');
    });

    test('should convert millions', () {
      expect(converter.convert(1000000), 'один миллион');
      expect(converter.convert(2000000), 'два миллиона');
      expect(converter.convert(5000000), 'пять миллионов');
      expect(converter.convert(1234567), 'один миллион двести тридцать четыре тысячи пятьсот шестьдесят семь');
    });

    test('should convert billions', () {
      expect(converter.convert(1000000000), 'один миллиард');
      expect(converter.convert(2000000000), 'два миллиарда');
      expect(converter.convert(5000000000), 'пять миллиардов');
      expect(converter.convert(1234567890), 'один миллиард двести тридцать четыре миллиона пятьсот шестьдесят семь тысяч восемьсот девяносто');
    });

    test('should handle negative numbers', () {
      expect(converter.convert(-42), 'минус сорок два');
    });
  });
}
