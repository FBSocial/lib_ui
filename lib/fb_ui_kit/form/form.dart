import 'package:flutter/material.dart';
import 'package:lib_base/icon_font/icon_font.dart';
import 'package:lib_theme/lib_theme.dart';
import 'package:lib_ui/fb_ui_kit/form/radio.dart';

abstract class FormItem {}

class FormSection implements FormItem {
  final String title;

  FormSection(this.title);
}

class WidgetFormItem implements FormItem {
  final Widget widget;

  WidgetFormItem(this.widget);
}

class TextFormItem implements FormItem {
  final String title;

  /// 使用前置空白区，这通常用来对齐其他非文本表单项
  final bool leading;
  final bool hideArrow;
  final VoidCallback onTap;

  TextFormItem(
    this.title, {
    this.leading = false,
    this.hideArrow = false,
    required this.onTap,
  });
}

class RadioFormItem implements FormItem {
  final bool selected;
  final String title;
  final VoidCallback onChange;
  final bool disabledOnSelected;

  RadioFormItem(this.title,
      {required this.onChange,
      this.selected = false,
      this.disabledOnSelected = true});
}

/// 如果 PC 端的样式与移动端不一致，可以把这个类改成抽象类，用桥接实现多端 UI
class FormItemBuilder {
  Widget buildText(BuildContext context, TextFormItem item) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: item.onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 52,
        child: Row(
          children: [
            SizedBox(width: item.leading ? 48 : 16),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(fontSize: 16, color: theme.fg.b100),
              ),
            ),
            Icon(
              IconFont.buffXiayibu,
              size: 16,
              color: theme.fg.b20,
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget buildRadio<T>(BuildContext context, RadioFormItem item) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: item.selected && item.disabledOnSelected ? null : item.onChange,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            SizedBox(width: 48, child: FbRadio(selected: item.selected)),
            Text(
              item.title,
              style: TextStyle(fontSize: 16, color: theme.fg.b100),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(BuildContext context, FormSection item) {
    final theme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child:
          Text(item.title, style: TextStyle(fontSize: 14, color: theme.fg.b60)),
    );
  }
}

typedef FormData = List<FormItem>;

class FbForm extends StatelessWidget {
  final FormData data;
  final EdgeInsets padding;

  const FbForm(this.data, {super.key, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    final itemBuilder = FormItemBuilder();
    final theme = AppTheme.of(context);
    final children = <Widget>[];
    List<Widget>? section;
    for (final item in data) {
      if (section?.isNotEmpty == true) {
        section!.add(const Divider(indent: 48));
      }
      if (item is WidgetFormItem) {
        (section ?? children).add(item.widget);
      } else if (item is FormSection) {
        section = [];
        children.add(itemBuilder.buildSection(context, item));
        children.add(Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.bg.bg3,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: section)));
      } else if (item is TextFormItem) {
        (section ?? children).add(itemBuilder.buildText(context, item));
      } else if (item is RadioFormItem) {
        (section ?? children).add(itemBuilder.buildRadio(context, item));
      }
    }
    return ListView(padding: padding, children: children);
  }
}
