import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/get_theme.dart';

import '../icon_font.dart';

class MoreIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const MoreIcon({this.size = 16, this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      IconFont.xiayibu,
      size: size,
      color: color ?? Get.themeToken.fg.b40,
    );
  }
}
