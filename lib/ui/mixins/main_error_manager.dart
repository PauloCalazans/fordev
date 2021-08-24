import 'package:flutter/material.dart';
import '../helpers/errors/errors.dart';

import '../components/components.dart';

mixin MainErrorManager {
  void handleError(Stream<UIError?> stream, BuildContext context) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(context, error.description);
      }
    });
  }
}