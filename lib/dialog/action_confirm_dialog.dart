import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/app_theme.dart';

class ActionConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ActionConfirmDialog(
      {this.title = "提示",
      this.content = "",
      this.confirmText = "确定",
      this.cancelText = "取消",
      this.onConfirm,
      this.onCancel,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title.isNotEmpty)
              Container(
                padding: const EdgeInsets.only(
                    left: 36, right: 36, top: 30, bottom: 30),
                child: Text(
                  title.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: AppTheme.of(context).fg.b100),
                ),
              ),
            if (content.isNotEmpty)
              Container(
                padding: const EdgeInsets.only(
                    left: 36, right: 36, top: 10, bottom: 10),
                child: Text(content.tr,
                    style: TextStyle(
                        fontSize: 16, color: AppTheme.of(context).fg.b40)),
              ),
            Divider(
              height: 0.5,
              color: AppTheme.of(context).fg.b10,
            ),
            SizedBox(
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (onCancel != null)
                    TextButton(
                        onPressed: onCancel,
                        child: Text(
                          cancelText.tr,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.of(context).fg.b60),
                        )),
                  if (onCancel != null)
                    VerticalDivider(
                      width: 1,
                      color: AppTheme.of(context).fg.b10,
                    ),
                  TextButton(
                      onPressed: onConfirm,
                      child: Text(
                        confirmText.tr,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.of(context).auxiliary.violet),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
