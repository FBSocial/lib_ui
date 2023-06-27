import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:lib_base/icon_font/icon_font.dart';
import 'package:lib_theme/lib_theme.dart';
import 'package:lib_ui/fb_ui_kit/form/radio.dart';

abstract class FormItem {
  final String title;
  final FormLeading? leading;
  final FormTailing? tailing;

  FormItem({
    required this.title,
    this.leading,
    this.tailing,
  });

  Widget build(BuildContext context);
}

abstract class FormLeading {
  static const double defaultLeadingSize = 16;

  double get leadingSize => defaultLeadingSize;

  Widget build(BuildContext context);
}

abstract class FormTailing {
  Widget build(BuildContext context);
}

class FormLeadingPlaceholder implements FormLeading {
  const FormLeadingPlaceholder();

  @override
  double get leadingSize => 48;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 28);
  }
}

class FormTailingArrow implements FormTailing {
  final Widget? child;
  const FormTailingArrow({this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (child != null)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: child,
          ),
        Icon(
          IconFont.buffXiayibu,
          size: 16,
          color: AppTheme.of(context).fg.b20,
        ),
      ],
    );
  }
}

class FormTailingChecked implements FormTailing {
  final bool selected;

  const FormTailingChecked(this.selected);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: selected,
      child: Icon(
        IconFont.webRight,
        size: 20,
        color: AppTheme.of(context).fg.blue1,
      ),
    );
  }
}

enum FormSectionStyle {
  none,
  ios,
}

class FormSection extends FormItem {
  final List<FormItem> children;
  final FormSectionStyle style;
  final bool densy;

  FormSection({
    required super.title,
    super.leading,
    super.tailing,
    required this.children,
    this.style = FormSectionStyle.ios,
    this.densy = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final dividerIndent = children.fold<double>(
        0,
        (previousValue, element) => math.max(previousValue,
            element.leading?.leadingSize ?? FormLeading.defaultLeadingSize));
    Widget items = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children.map((e) => e.build(context)).fold<List<Widget>>(
          [],
          (previousValue, element) => [
                ...previousValue,
                if (previousValue.isNotEmpty)
                  Divider(
                    indent: dividerIndent,
                  ),
                element,
              ]).toList(),
    );
    switch (style) {
      case FormSectionStyle.none:
        break;
      case FormSectionStyle.ios:
        items = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.bg.bg3,
            ),
            child: items);
        break;
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 16, vertical: densy ? 4 : 8),
            child: Text(title,
                maxLines: 1,
                style: TextStyle(fontSize: 14, color: theme.fg.b60)),
          ),
          items,
        ]);
  }
}

class WidgetFormItem implements FormItem {
  final Widget widget;

  WidgetFormItem(this.widget);

  @override
  FormLeading? get leading => throw UnimplementedError();

  @override
  FormTailing? get tailing => throw UnimplementedError();

  @override
  String get title => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

class TextFormItem extends FormItem {
  final VoidCallback onTap;

  TextFormItem({
    required super.title,
    super.leading,
    super.tailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 52,
        child: Row(
          children: [
            const SizedBox(width: 16),
            if (leading != null) leading!.build(context),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: theme.fg.b100),
              ),
            ),
            if (tailing != null) tailing!.build(context),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class RadioFormItem extends FormItem {
  final bool selected;
  final VoidCallback onChange;

  RadioFormItem({
    required super.title,
    super.leading,
    super.tailing,
    required this.onChange,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: selected ? null : onChange,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            SizedBox(width: 48, child: FbRadio(selected: selected)),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: theme.fg.b100),
            ),
          ],
        ),
      ),
    );
  }
}

/// 如果 PC 端的样式与移动端不一致，可以把这个类改成抽象类，用桥接实现多端 UI
class FormItemBuilder {
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
  final bool shrinkWrap;

  const FbForm(
    this.data, {
    super.key,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      padding: padding,
      children: data.map((e) => e.build(context)).toList(),
    );
  }
}
