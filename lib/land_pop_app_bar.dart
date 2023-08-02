import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_ui/button/web_icon_button.dart';
// import 'icon_font.dart';

class LandPopAppBar extends StatelessWidget {
  final bool isBackVisible;
  final String? title;
  final double horizontal;

  const LandPopAppBar(
      {Key? key, this.isBackVisible = true, this.title, this.horizontal = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: title?.isNotEmpty ?? false,
            child: Text(title ?? '',
                style: TextStyle(
                  color: AppTheme.of(context).fg.b100,
                  fontSize: 16,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                )),
          ),
          Visibility(
            visible: isBackVisible,
            child: WebIconBgButton(
              Icons.clear_outlined,
              color: Colors.transparent,
              iconColor: AppTheme.of(context).fg.b95,
              iconHoverColor: AppTheme.of(context).fg.b95,
              hoverColor: AppTheme.of(context).bg.bg2,
              highlightColor: AppTheme.of(context).bg.bg2,
              size: 32,
              onPressed: Get.back,
            ),
          ),
        ],
      ),
    );
  }
}
