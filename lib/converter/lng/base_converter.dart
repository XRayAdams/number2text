// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

abstract class BaseConverter {
  String get name;
  String get native_number_too_large_error_text;
  String convert(int input);
}
