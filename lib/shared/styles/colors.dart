import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static const Map<int, Color> color = {
    50: Color.fromRGBO(252, 96, 17, .1),
    100: Color.fromRGBO(252, 96, 17, .2),
    200: Color.fromRGBO(252, 96, 17, .3),
    300: Color.fromRGBO(252, 96, 17, .4),
    400: Color.fromRGBO(252, 96, 17, .5),
    500: Color.fromRGBO(252, 96, 17, .6),
    600: Color.fromRGBO(252, 96, 17, .7),
    700: Color.fromRGBO(252, 96, 17, .8),
    800: Color.fromRGBO(252, 96, 17, .9),
    900: Color.fromRGBO(252, 96, 17, 1),
  };

  static const MaterialColor mainSwatchColor = MaterialColor(0xFC6011, color);

  static final Color mainColor = HexColor('#FC6011');
  static final Color textColor = HexColor('#7C7D7E');
  static final Color fieldColor = HexColor('#F2F2F2');
  static final Color titleColor = HexColor('#4A4B4D');
  static final Color disabledColor = HexColor('#F2F2F2');
  static final Color greyColor = HexColor('#B6B7B7');
}
