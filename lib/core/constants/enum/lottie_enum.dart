// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum LottieEnum { sunny, moon }

extension LottieEnumExtension on LottieEnum {
  Widget get toWidget => Lottie.asset(rawValue);
  String _path(String path) => 'assets/lottie/$path.json';

  String get rawValue {
    switch (this) {
      case LottieEnum.moon:
        return _path('moon');
      case LottieEnum.sunny:
        return _path('sunny');
    }
  }
}
