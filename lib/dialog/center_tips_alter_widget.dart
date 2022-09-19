import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 提示弹框
class CenterTipsAlterWidget extends StatefulWidget {
  final Function confirmCallback;
  final String title;
  final String content;

  const CenterTipsAlterWidget(this.title, this.content, this.confirmCallback,
      {Key? key})
      : super(key: key);

  @override
  _CenterTipsAlterWidgetState createState() => _CenterTipsAlterWidgetState();

  static Future<void> show(BuildContext context, String title, String content,
      Function confirmCallback) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return CenterTipsAlterWidget(title, content, confirmCallback);
      },
    );
  }
}

class _CenterTipsAlterWidgetState extends State<CenterTipsAlterWidget> {
  @override
  Widget build(BuildContext context) {
    ///警告对话框
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Align(
            child: Text(widget.content),
          )
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('取消', style: TextStyle(color: Colors.black)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('继续'),
          onPressed: () {
            widget.confirmCallback();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
