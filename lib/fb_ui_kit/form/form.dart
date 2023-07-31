import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib_base/icon_font/icon_font.dart';
import 'package:lib_theme/lib_theme.dart';
import 'package:lib_ui/fb_ui_kit/form/radio.dart';

abstract class FormItem {
  final String? title;
  final FormLeading? leading;
  final FormTailing? tailing;

  FormItem({
    this.title,
    this.leading,
    this.tailing,
  });

  Widget build(BuildContext context);
}

abstract class FormLeading {
  const FormLeading();

  static const double defaultLeadingSize = 16;

  double get leadingSize => 46;

  /// 如果返回 true 会让 item 不可点击
  bool get interruptTap => false;

  Widget build(BuildContext context);
}

abstract class FormTailing {
  Widget build(BuildContext context);
}

class FormLeadingPlaceholder extends FormLeading {
  const FormLeadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: leadingSize);
  }
}

class FormLeadingRadioButton extends FormLeading {
  final bool selected;

  const FormLeadingRadioButton(this.selected);

  @override
  bool get interruptTap => selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 48,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
          child: FbRadio(selected: selected),
        ));
  }
}

class FormTailingArrow implements FormTailing {
  final Widget? prefixWidget;
  final String? prefix;

  const FormTailingArrow({this.prefix, this.prefixWidget});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixWidget != null || prefix != null)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: prefixWidget ??
                  Text(prefix!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: theme.fg.b40)),
            ),
          ),
        Icon(
          IconFont.buffXiayibu,
          size: 16,
          color: theme.fg.b20,
        ),
      ],
    );
  }
}

class FormTailingSwitch implements FormTailing {
  final bool value;
  final void Function(bool)? onChange;

  const FormTailingSwitch(this.value, {this.onChange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 20,
      child: Transform.scale(
        scale: 0.8,
        child: CupertinoSwitch(
          value: value,
          activeColor: AppTheme.of(context).fg.blue1,
          onChanged: onChange,
        ),
      ),
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
  final bool dense;

  FormSection({
    super.title,
    super.leading,
    super.tailing,
    required this.children,
    this.style = FormSectionStyle.ios,
    this.dense = false,
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
          if (title != null)
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: dense ? 4 : 8),
              child: Text(title!,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, color: theme.fg.b60)),
            ),
          items,
        ]);
  }
}

class WidgetFormItem extends FormItem {
  final Widget widget;

  WidgetFormItem(this.widget);

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

class ValueNotifierFormItem<T> extends FormItem {
  final ValueNotifier<T> notifier;
  final FormItem Function(T) builder;

  ValueNotifierFormItem({
    required this.notifier,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (context, value, child) => builder(value).build(context),
    );
  }
}

class ButtonFormItem extends FormItem {
  final VoidCallback onTap;
  final IconData? icon;
  final bool disabled;

  ButtonFormItem({
    required this.onTap,
    required String title,
    this.icon,
    this.disabled = false,
  }) : super(title: title);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.bg.bg3,
        ),
        alignment: Alignment.center,
        child: Opacity(
          opacity: disabled ? 0.3 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(icon, size: 18, color: theme.fg.blue1),
                ),
              Text(title!,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.fg.blue1,
                    fontWeight: FontWeight.w500,
                    fontFamilyFallback: defaultFontFamilyFallback,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFormItem extends FormItem {
  final VoidCallback? onTap;
  final String? subtitle;
  final bool required;

  TextFormItem({
    required String title,
    this.required = false,
    this.subtitle,
    super.leading,
    super.tailing,
    this.onTap,
  }) : super(title: title);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final titleWidget = Text.rich(
      TextSpan(children: [
        TextSpan(text: title!),
        if (required)
          TextSpan(text: " *", style: TextStyle(color: theme.function.red1)),
      ]),
      style: TextStyle(fontSize: 16, color: theme.fg.b100),
    );
    const paddingH = 16.0;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (leading?.interruptTap == true) return;
        onTap?.call();
      },
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          alignment: Alignment.centerLeft,
          height: subtitle == null ? 52 : 76,
          child: Row(
            children: [
              if (leading != null)
                leading!.build(context)
              else
                const SizedBox(width: paddingH),
              Expanded(
                child: subtitle == null
                    ? titleWidget
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            titleWidget,
                            const SizedBox(height: 6),
                            Text(
                              subtitle!,
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 13, color: theme.fg.b40),
                            ),
                          ]),
              ),
              if (tailing != null) ...[
                const SizedBox(width: 16),
                LimitedBox(
                    maxWidth: (constraints.maxWidth - paddingH * 2) / 2,
                    child: tailing!.build(context))
              ],
              const SizedBox(width: paddingH),
            ],
          ),
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
      child: Text(item.title!,
          style: TextStyle(fontSize: 14, color: theme.fg.b60)),
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
      children: data.map((e) {
        final widget = e.build(context);
        if (e is FormSection) {
          return Padding(
            padding:
                data[0] == e ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
            child: widget,
          );
        } else {
          return widget;
        }
      }).toList(),
    );
  }
}
