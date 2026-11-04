import 'package:flutter/material.dart';

class ColorConstant {
  // Brand
  static Color brandColor        = fromHex('#5A5ED8');
  static Color purpleAccent      = fromHex('#5A5ED8');
  static Color fadedPurpleAccent = fromHex('#F4F4FF');
  static Color darkPurpleAccent  = fromHex('#5A5DD4');
  static Color PurpleLught = fromHex("#C4C5F9");
  // Gradient colors (from brand design)
  static Color gradientStart     = fromHex('#7679EC');
  static Color gradientEnd       = fromHex('#5154CB');
  
  // Accent colors
  static Color quickliYellow     = fromHex('#F5B700');
  static Color quickliOrange     = fromHex('#FF9500');

  // Semantic
  static Color white        = fromHex('#FFFFFF');
  static Color whiteCard    = fromHex('#FAFAFC');
  static Color whiteSnow    = fromHex('#E6E6EE');
  static Color softwhite = fromHex("#EDF2FA");
  static Color whiteSlick   = fromHex('#F3F3F7');
  static Color qBlack       = fromHex('#000000');
  static Color samantic     = fromHex('#1A1B2B');
  static Color black        = fromHex('#4B4C5E');
  static Color darkGrey     = fromHex('#808080');
  static Color deepGrey     = fromHex('#6B6C7E');
  static Color lightGrey    = fromHex('#D9D9D9');
  static Color lighterGrey  = fromHex('#F8F8F8');
  static Color lightestGrey = fromHex('#F1F1F1');
  static Color borderColor  = fromHex('#F3F4F6');

  // Status
  static Color red       = fromHex('#D8143A');
  static Color redOrange = fromHex('#F35B00');
  static Color orange    = fromHex('#F18700');
  static Color amber     = fromHex('#9E5600');
  static Color lightAmber= fromHex('#FFE8A3');
  static Color green     = fromHex('#16A34A');
  static Color lightGreen= fromHex('#F0FDF4');

  // Utility
  static Color darkColor     = fromHex('#364153');
  static Color ashColor      = fromHex('#FAFAFA');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
