import 'package:flutter_test/flutter_test.dart';
import 'package:number2text/converter/lng/french_converter.dart';

void main() {
  group('FrenchConverter', () {
    final converter = FrenchConverter();

    test('should convert single digits', () {
      expect(converter.convert(0), 'zéro');
      expect(converter.convert(5), 'cinq');
      expect(converter.convert(9), 'neuf');
    });

    test('should convert numbers less than 20', () {
      expect(converter.convert(10), 'dix');
      expect(converter.convert(15), 'quinze');
      expect(converter.convert(19), 'dix-neuf');
    });

    test('should convert tens', () {
      expect(converter.convert(20), 'vingt');
      expect(converter.convert(50), 'cinquante');
      expect(converter.convert(80), 'quatre-vingts');
      expect(converter.convert(90), 'quatre-vingt-dix');
    });

    test('should convert numbers less than 100', () {
      expect(converter.convert(21), 'vingt-et-un');
      expect(converter.convert(58), 'cinquante-huit');
      expect(converter.convert(71), 'soixante-et-onze');
      expect(converter.convert(99), 'quatre-vingt-dix-neuf');
    });

    test('should convert hundreds', () {
      expect(converter.convert(100), 'cent');
      expect(converter.convert(200), 'deux cents');
      expect(converter.convert(500), 'cinq cents');
    });

    test('should convert numbers less than 1000', () {
      expect(converter.convert(101), 'cent un');
      expect(converter.convert(201), 'deux cent un');
      expect(converter.convert(555), 'cinq cent cinquante-cinq');
    });

    test('should convert thousands', () {
      expect(converter.convert(1000), 'mille');
      expect(converter.convert(5000), 'cinq mille');
    });

    test('should convert numbers less than 1,000,000', () {
      expect(converter.convert(1001), 'mille un');
      expect(converter.convert(999999), 'neuf cent quatre-vingt-dix-neuf mille neuf cent quatre-vingt-dix-neuf');
    });

    test('should convert millions', () {
      expect(converter.convert(1000000), 'un million');
      expect(converter.convert(2000000), 'deux millions');
    });

    test('should convert billions', () {
      expect(converter.convert(1000000000), 'un milliard');
      expect(converter.convert(2000000000), 'deux milliards');
    });

    test('should convert negative numbers', () {
      expect(converter.convert(-5), 'moins cinq');
    });
  });
}
