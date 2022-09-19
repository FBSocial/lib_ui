import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAlertDialog extends StatelessWidget {
  final String? content;
  final Function? onCancel;
  final Function? onConfirm;

  const CommonAlertDialog(
      {this.content, this.onCancel, this.onConfirm, Key? key})
      : super(key: key);

  static Future<void> show(
    BuildContext context,
    String content, {
    Function? onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return CommonAlertDialog(
          content: content,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText2!.color;
    final btnTextColor = theme.primaryColor;

    final textStyle = TextStyle(
        color: textColor,
        fontSize: 17,
        fontWeight: FontWeight.bold,
        height: 1.35);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 280,
            height: 162,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(36, 15, 36, 0),
                  child: Text(
                    content!,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(thickness: 0.5, color: Color(0x338F959E)),
                // ignore: sized_box_for_whitespace
                Container(
                  height: 55,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.back();
                            if (onConfirm != null) {
                              onConfirm!();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "确定".tr,
                              style: TextStyle(
                                  color: btnTextColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommonTitleAlertDialog extends StatelessWidget {
  final String? content;
  final String? title;
  final Function? onConfirm;

  const CommonTitleAlertDialog(
      {this.title, this.content, this.onConfirm, Key? key})
      : super(key: key);

  static Future<void> show(
    BuildContext context,
    String content, {
    Function? onConfirm,
    String? title,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return CommonTitleAlertDialog(
          content: content,
          onConfirm: onConfirm,
          title: title,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyText2!.color!;
    final btnTextColor = theme.primaryColor;

    final textStyle1 = TextStyle(
        color: textColor,
        fontSize: 17,
        height: 1.35,
        fontWeight: FontWeight.bold);
    final textStyle2 =
        TextStyle(color: textColor.withAlpha(0xcc), fontSize: 16, height: 1.35);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 280,
            height: 162,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: textStyle1,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    content!,
                    textAlign: TextAlign.center,
                    style: textStyle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 25),
                const Divider(thickness: 0.5, color: Color(0x338F959E)),
                // ignore: sized_box_for_whitespace
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.back();
                      if (onConfirm != null) {
                        onConfirm!();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "确定".tr,
                        style: TextStyle(
                            color: btnTextColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
