import 'package:flutter_test/flutter_test.dart';
import 'package:number2text/converter/lng/german_converter.dart';

void main() {
  group('GermanConverter', () {
    final converter = GermanConverter();

    test('should convert single digits', () {
      expect(converter.convert(0), 'null');
      expect(converter.convert(1), 'eins');
      expect(converter.convert(5), 'fünf');
    });

    test('should convert numbers less than 100', () {
      expect(converter.convert(21), 'einundzwanzig');
      expect(converter.convert(99), 'neunundneunzig');
    });

    test('should convert hundreds', () {
      expect(converter.convert(100), 'hundert');
      expect(converter.convert(101), 'hunderteins');
      expect(converter.convert(121), 'hunderteinundzwanzig');
      expect(converter.convert(555), 'fünfhundertfünfundfünfzig');
    });

    test('should convert thousands', () {
      expect(converter.convert(1000), 'eintausend');
      expect(converter.convert(1234), 'eintausendzweihundertvierunddreißig');
      expect(converter.convert(5555), 'fünftausendfünfhundertfünfundfünfzig');
    });

    test('should convert millions', () {
      expect(converter.convert(1000000), 'eine Million');
      expect(converter.convert(1234567), 'eine Million zweihundertvierunddreißigtausendfünfhundertsiebenundsechzig');
    });

    test('should convert billions', () {
      expect(converter.convert(1000000000), 'eine Milliarde');
      expect(converter.convert(1234567890), 'eine Milliarde zweihundertvierunddreißig Millionen fünfhundertsiebenundsechzigtausendachthundertneunzig');
    });

    test('should handle negative numbers', () {
      expect(converter.convert(-42), 'minus zweiundvierzig');
    });
  });
}
