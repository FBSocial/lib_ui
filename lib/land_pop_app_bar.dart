import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'icon_font.dart';

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
                style: Get.textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w500,
                )),
          ),
          Visibility(
            visible: isBackVisible,
            child: InkWell(
              onTap: Get.back,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  IconFont.navBarCloseItem,
                  size: 17,
                  color: Get.theme.disabledColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
