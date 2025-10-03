import 'package:flutter/foundation.dart';
import 'lng/base_converter.dart';
import 'lng/english_converter.dart';
import 'lng/spanish_converter.dart';

class Converter with ChangeNotifier {
  List<BaseConverter> get baseConverters => [EnglishConverter(), SpanishConverter()];
}
