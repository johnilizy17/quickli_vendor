import 'package:flutter/material.dart';

class ColorConstant {
  // Brand
  static Color brandColor        = fromHex('#5A5ED8');
  static Color purpleAccent      = fromHex('#5A5ED8');
  static Color fadedPurpleAccent = fromHex('#F4F4FF');
  static Color lightPurpleAccent = fromHex('#F1F1FE');
  static Color darkPurpleAccent  = fromHex('#5A5DD4');
  static Color PurpleLught = fromHex("#C4C5F9");
  // Gradient colors (from brand design)
  static Color gradientStart     = fromHex('#7679EC');
  static Color gradientEnd       = fromHex('#5154CB');
  
  // Accent colors
  static Color quickliYellow     = fromHex('#F5B700');
  static Color yellowCard = fromHex("#FFF8E1");

  // Semantic
  static Color white        = fromHex('#FFFFFF');
  static Color whiteCard    = fromHex('#FAFAFC');
  static Color whiteSnow    = fromHex('#E6E6EE');
  static Color softwhite = fromHex("#EDF2FA");
  static Color whiteSlick   = fromHex('#F3F3F7');
  static Color qBlack       = fromHex('#000000');
  static Color samantic     = fromHex('#1A1B2B');
  static Color black        = fromHex('#4B4C5E');
  static Color blackTin        = fromHex('#2E2E2E');
  static Color blackBold = fromHex("#1E2939");
  static Color blackGrey        = fromHex('#101828');
  static Color darkGrey     = fromHex('#808080');
  static Color grey     = fromHex('#6A7282');
  static Color greyLighter = fromHex("E2E8F0");
  static Color greyCard = fromHex("#F9FAFB");
  static Color greyLight = fromHex("#E5E7EB");
  static Color lighengrey     = fromHex('#99A1AF');
  static Color deepGrey     = fromHex('#6B6C7E');
  static Color lightGrey    = fromHex('#D9D9D9');
  static Color lighterGrey  = fromHex('#F8F8F8');
  static Color lightestGrey = fromHex('#F1F1F1');
  static Color greythickness = fromHex("F1F5F9");
  static Color borderColor  = fromHex('#F3F4F6');

  // Status
  static Color red       = fromHex('#FF6900');
  static Color redOrange = fromHex('#F35B00');
  static Color orange    = fromHex('#F18700');
  static Color amber     = fromHex('#9E5600');
  static Color lightAmber= fromHex('#FFE8A3');
  static Color green     = fromHex('#16A34A');
  static Color lightGreen= fromHex('#F0FDF4');
  static Color lighterGreen = fromHex("#DCFCE7");
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
