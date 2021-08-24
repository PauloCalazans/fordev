import 'package:flutter/material.dart';

import '../components/components.dart';

mixin LoadingManager {
  void handleLoading(Stream<bool?> stream, BuildContext context) {
    stream.listen((isLoading) {
      if(isLoading == true) {
        showLoading(context);
      } else {
        hideLoading(context);
      }
    });
  }
}