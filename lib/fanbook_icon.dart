import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_theme/app_theme.dart';

class FanbookIcon extends StatelessWidget {
  final double size;

  const FanbookIcon({Key? key, this.size = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        width: size,
        height: size,
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: appThemeData.dividerColor.withOpacity(0.4),
            width: 0.5,
          ),
        ),
        child: SvgPicture.asset(
          'assets/svg/logo.svg',
          width: size,
          height: size,
          package: "lib_ui",
        ),
      ),
    );
  }
}
