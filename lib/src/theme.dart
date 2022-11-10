/*
 * @FilePath       : /social/lib/app/theme/app_theme.dart
 *
 * @Info           :
 *
 * @Author         : Whiskee Chan
 * @Date           : 2022-01-07 16:59:17
 * @Version        : 1.0.0
 *
 * Copyright 2022 iDreamSky FanBook, All Rights Reserved.
 *
 * @LastEditors    : Whiskee Chan
 * @LastEditTime   : 2022-03-11 16:57:28
 *
 */
import 'package:flutter/material.dart';
import 'package:lib_ui/src/painting/fb_rounded_rectangle_border.dart';

/// 设计规范 https://idreamsky.feishu.cn/wiki/wikcnfMNP9YPqralTmDuWl8PSKc
///
const fbPrimaryColor = Color(0xFF198CFE);
final _primarySwatch = MaterialColor(
  fbPrimaryColor.value,
  const <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: fbPrimaryColor,
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFF1452CC),
    900: Color(0xFFB71C1C),
  },
);

// 设计：图标灰
const _iconGray = Color(0xFF5C6273);
// 设计：文字黑
const _fontColor = Color(0xFF1F2126);
// 设计：背景灰
const _backgroundGray = Color(0xFFF5F6FA);
// 设计：浅灰色。用户页面上的浅色区域，文本、图标或者分割线
const _lightGray = Color(0xFF8D93A6);

final ThemeData fbTheme = ThemeData(
  primarySwatch: _primarySwatch,
  splashFactory: NoSplash.splashFactory,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: _backgroundGray,
  iconTheme: const IconThemeData(color: _iconGray, size: 24),
  // 这个颜色值也会用来表示 UI 页面上的浅色部分（图标和文本），从目前的规范定义上看，就使用 dividerColor
  dividerColor: _lightGray.withOpacity(0.1),
  colorScheme: const ColorScheme.light(
      primary: fbPrimaryColor, onSurface: _iconGray, onSecondary: _lightGray),
  dividerTheme: DividerThemeData(
      color: _lightGray.withOpacity(0.1), space: 0, thickness: 0.5),
  disabledColor: _iconGray,
  textTheme: const TextTheme(
    headline1: TextStyle(color: _fontColor, fontSize: 22),
    // headline2 仅定义颜色值，用在页面上较灰色的文字展示
    headline2: TextStyle(color: _lightGray),
    bodyText1: TextStyle(color: _fontColor, fontSize: 17),
    bodyText2: TextStyle(color: _fontColor, fontSize: 16),
    caption: TextStyle(color: _iconGray, fontSize: 14),
  ),
  buttonTheme: const ButtonThemeData(
    shape: FbRoundedRectangleBorder(),
  ),
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(
  //     // primaryColor: _fbPrimaryColor,
  //     // primaryColorDark: _fbPrimaryColor,
  //     // primaryColorLight: _fbPrimaryColor,
  //     splashFactory: NoSplash.splashFactory,
  //     elevation: 0,
  //     shape: const FbRoundedRectangleBorder(),
  //   ),
  // ),
  // outlinedButtonTheme: OutlinedButtonThemeData(
  //   style: OutlinedButton.styleFrom(
  //     splashFactory: NoSplash.splashFactory,
  //     elevation: 0,
  //     shape: const FbRoundedRectangleBorder(),
  //   ),
  // ),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(elevation: 0),
  // ),
);
