import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/app_theme.dart';

class PermissionTipDialog extends StatefulWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final Function? onConfirm;

  const PermissionTipDialog(
      {this.title = "",
      this.content = "",
      this.cancelText = "取消",
      this.confirmText = "确定",
      this.onConfirm,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => UpdateDialogState();
}

class UpdateDialogState extends State<PermissionTipDialog> {
  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.of(context).fg.b100;
    final bgColor = AppTheme.of(context).bg.bg1;
    final cancelBgColor = AppTheme.of(context).bg.bg3;
    final confirmBgColor = AppTheme.of(context).fg.blue1;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 295,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: bgColor,
            ),
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title.tr,
                  style: TextStyle(color: textColor, fontSize: 17),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(
                    height: 40,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                    color: Color(0xffFFFFFF)),
                Expanded(
                  child: Text(
                    widget.content.tr,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: Get.back,
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              color: cancelBgColor,
                            ),
                            child: Text(
                              widget.cancelText.tr,
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                            widget.onConfirm!();
                          },
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              color: confirmBgColor,
                            ),
                            child: Text(
                              widget.confirmText.tr,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
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
