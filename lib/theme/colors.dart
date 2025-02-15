import 'package:flutter/material.dart';

abstract class AppColors {
  // private constructor를 선언함으로서 개발자가 실수로 인스턴스화하는 코드를 작성하는 실수 방지
  AppColors._();

  static const transparent = Color.fromRGBO(0, 0, 0, 0);

  static const primaryGreen = Color.fromRGBO(28, 174, 129, 1.0);

  static const neutralBlack = Color.fromRGBO(28, 174, 129, 1.0);
  static const neutralGray = Color.fromRGBO(28, 174, 129, 1.0);
  static const neutralBackgroundBlue = Color.fromRGBO(251, 253, 255, 1.0);

  static const accentPrimaryMainYellow = Color.fromRGBO(255, 188, 0, 1.0);
  static const accentPrimaryMainDandelion = Color.fromRGBO(255, 193, 7, 1.0);
  static const accentPrimaryMainRed = Color.fromRGBO(239, 48, 36, 1.0);
  static const accentPrimaryMainOrange = Color.fromRGBO(255, 162, 107, 1.0);
  static const accentPrimaryMainBlue = Color.fromRGBO(0, 136, 255, 1.0);

  static const secondaryPrimaryMainOrange = Color(0xFFFFD5BE);

  static const borderGray = Color.fromRGBO(221, 221, 221, 1.0);

  static const textBodyGray = Color.fromRGBO(138, 141, 159, 1.0);
  static const textBodyBlack = Color.fromRGBO(51, 51, 51, 1.0);

  static const backgroundOrange = Color.fromRGBO(255, 250, 242, 1.0);
}

// NOTE: 팔레트가 많아지는 경우 테마별로 컬러 클래스를 나누는 것을 고려중

// abstract class PrimaryColors {
// }

// abstract class NeutralColors {
// }
