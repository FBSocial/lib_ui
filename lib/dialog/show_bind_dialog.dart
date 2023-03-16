import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_extension/string_extension.dart';
import 'package:lib_theme/app_theme.dart';

class BindDialog extends StatelessWidget {
  final String? oldName;
  final String? newName;
  final Function? onCancel;
  final Function? onConfirm;

  const BindDialog(
      {this.oldName, this.newName, this.onCancel, this.onConfirm, Key? key})
      : super(key: key);

  static Future<void> show(
    BuildContext context,
    String? oldName,
    String? newName, {
    Function? onCancel,
    Function? onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return BindDialog(
          oldName: oldName ?? '',
          newName: newName ?? '',
          onCancel: onCancel,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.of(context).fg.b100;
    final bgColor = AppTheme.of(context).bg.bg1;
    final btnTextColor = AppTheme.of(context).fg.blue1;

    final bool noValue = oldName!.noValue || newName!.noValue;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 319,
            height: noValue ? 140 : 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: bgColor,
            ),
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.fromLTRB(20, 16, 24, 0),
                    child: noValue ? noName(context) : hasName(context),
                  ),
                ),
                Divider(thickness: 0.5, color: AppTheme.of(context).fg.b10),
                // ignore: sized_box_for_whitespace
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Get.back();
                          onCancel!();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "取消".tr,
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: VerticalDivider(
                          thickness: 0.5, color: AppTheme.of(context).fg.b10),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Get.back();
                          onConfirm!();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "绑定手机号".tr,
                            style: TextStyle(
                                color: btnTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget hasName(BuildContext context) {
    final textColor = AppTheme.of(context).fg.b100;
    final textStyle1 = TextStyle(color: textColor, fontSize: 16);
    final textStyle2 =
        TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "该手机号已绑定".tr, style: textStyle1),
          TextSpan(text: " $oldName", style: textStyle2),
          TextSpan(text: "，是否解绑并换绑为".tr, style: textStyle1),
          TextSpan(text: " $newName", style: textStyle2),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget noName(BuildContext context) {
    final textColor = AppTheme.of(context).fg.b100;
    final textStyle1 = TextStyle(color: textColor, fontSize: 16);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "该手机号已绑定".tr, style: textStyle1),
          TextSpan(text: "，是否解绑并重新绑定".tr, style: textStyle1),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}
