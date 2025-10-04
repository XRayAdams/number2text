// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

import 'package:number2text/converter/lng/french_converter.dart';
import 'package:number2text/converter/lng/german_converter.dart';
import 'package:number2text/converter/lng/russian_converter.dart';
import 'package:number2text/converter/lng/spanish_converter.dart';

import 'lng/base_converter.dart';
import 'lng/english_converter.dart';
import 'lng/italian_converter.dart';

class NumberConverter {
  final List<BaseConverter> baseConverters = [
    EnglishConverter(),
    SpanishConverter(),
    FrenchConverter(),
    GermanConverter(),
    RussianConverter(),
    ItalianConverter(),
  ];
}
