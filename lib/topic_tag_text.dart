import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lib_theme/default_theme.dart';

class TopicTagText extends StatelessWidget {
  final List<String?> tags;
  final Color? bgColor;
  final Color? textColor;

  const TopicTagText(
    this.tags, {
    this.bgColor,
    this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: tags.map((e) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 2),
        padding: const EdgeInsets.only(left: 12, right: 12),
        //设置 child 居中
        // alignment: Alignment.centerLeft,
        height: 24,
        //边框设置
        decoration: BoxDecoration(
          color: bgColor ?? primaryColor.withOpacity(0.06),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Text(
          "#$e",
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: textColor ?? primaryColor,
              fontSize: 12,
              height: 1.25,
              fontWeight: FontWeight.w500),
          strutStyle: const StrutStyle(height: 1.25, fontSize: 12),
        ),
      );
    }).toList());
  }
}
