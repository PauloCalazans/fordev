import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations strings = PtBr();

  static void load(Locale locale) {
    final local = {
      'en_US': EnUs()
    };
    strings = local[locale.toString()] ?? PtBr();
  }
}