import 'package:flutter_test/flutter_test.dart';
import 'package:number2text/converter/lng/italian_converter.dart';

void main() {
  group('ItalianConverter', () {
    final converter = ItalianConverter();

    test('should convert single digits', () {
      expect(converter.convert(0), 'zero');
      expect(converter.convert(5), 'cinque');
      expect(converter.convert(9), 'nove');
    });

    test('should convert numbers less than 20', () {
      expect(converter.convert(10), 'dieci');
      expect(converter.convert(15), 'quindici');
      expect(converter.convert(19), 'diciannove');
    });

    test('should convert tens', () {
      expect(converter.convert(20), 'venti');
      expect(converter.convert(50), 'cinquanta');
      expect(converter.convert(90), 'novanta');
    });

    test('should convert numbers less than 100', () {
      expect(converter.convert(25), 'venticinque');
      expect(converter.convert(58), 'cinquantotto');
      expect(converter.convert(99), 'novantanove');
    });

    test('should convert hundreds', () {
      expect(converter.convert(100), 'cento');
      expect(converter.convert(500), 'cinquecento');
      expect(converter.convert(900), 'novecento');
    });

    test('should convert numbers less than 1000', () {
      expect(converter.convert(101), 'centuno');
      expect(converter.convert(555), 'cinquecentocinquantacinque');
      expect(converter.convert(999), 'novecentonovantanove');
    });

    test('should convert thousands', () {
      expect(converter.convert(1000), 'mille');
      expect(converter.convert(5000), 'cinquemila');
      expect(converter.convert(9000), 'novemila');
    });

    test('should convert numbers less than 1,000,000', () {
      expect(converter.convert(1001), 'milleuno');
      expect(converter.convert(5555), 'cinquemilacinquecentocinquantacinque');
      expect(converter.convert(999999), 'novecentonovantanovemilanovecentonovantanove');
    });

    test('should convert millions', () {
      expect(converter.convert(1000000), 'un milione');
    });

     test('should convert billions', () {
      expect(converter.convert(1000000000), 'un miliardo');
    });

    test('should convert negative numbers', () {
      expect(converter.convert(-5), 'meno cinque');
    });

  });
}
