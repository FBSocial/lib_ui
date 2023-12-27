import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_utils/orientation_util.dart';

import 'icon_font.dart';

typedef OnChange = void Function(String);

///
/// 自定义输入框
///
class CustomInputBox extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final OnChange? onChange;
  final int? maxLength;
  final bool readOnly;
  final FocusNode? focusNode;
  final double borderRadius;
  final int maxLines;
  final bool autofocus;
  final VoidCallback? onEditingComplete;
  final bool needCounter;
  final EdgeInsets contentPadding;
  final EdgeInsets? nativeContentPadding;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final double? height;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final bool showSuffixIcon;

  /// - 输入框模式
  final TextInputAction? textInputAction;

  /// - 输入框类型和输入数量限制
  final List<TextInputFormatter>? inputFormatters;

  const CustomInputBox(
      {required this.controller,
      this.hintText,
      this.hintStyle,
      this.style,
      this.fillColor,
      this.maxLength,
      this.readOnly = false,
      this.focusNode,
      this.borderRadius = 4,
      this.autofocus = false,
      this.maxLines = 1,
      this.onChange,
      this.onEditingComplete,
      this.needCounter = true,
      this.contentPadding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
      this.nativeContentPadding,
      this.prefixIcon,
      this.prefixIconConstraints,
      this.height,
      this.keyboardType,
      this.textAlign = TextAlign.start,
      this.showSuffixIcon = true,
      this.textInputAction,
      this.inputFormatters,
      Key? key})
      : super(key: key);

  @override
  _CustomInputBoxState createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  bool _isShowClear = false;

  static final RegExp _regexEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  static final RegExp _specialString =
      RegExp(r'([\u0e00-\u0eff]|[\u0300-\u036f])');

  @override
  void initState() {
    super.initState();
    setClearButtonState();
    widget.controller.addListener(checkNeedShowClearButton);
  }

  @override
  void didUpdateWidget(covariant CustomInputBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    setClearButtonState();
  }

  @override
  Widget build(BuildContext context) {
    setClearButtonState();

    final decoration = InputDecoration(
      contentPadding: widget.contentPadding,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gapPadding: 0,
      ),
      fillColor: widget.fillColor,
      filled: true,
      hintText: widget.hintText,
      hintStyle: widget.hintStyle,
      prefixIcon: widget.prefixIcon,
      prefixIconConstraints: widget.prefixIconConstraints,
      suffixIconConstraints: const BoxConstraints(maxWidth: 40),
      suffixIcon: (widget.showSuffixIcon && _isShowClear && !widget.readOnly)
          ? Center(
              child: IconButton(
                hoverColor: Colors.transparent,
                padding: OrientationUtil.portrait
                    ? const EdgeInsets.all(8)
                    : const EdgeInsets.all(2),
                icon: Icon(
                  IconFont.close,
                  size: OrientationUtil.portrait ? 16 : 18,
                  color: AppTheme.of(context).fg.b40,
                ),
                onPressed: () {
                  widget.controller.clear();
                  _onTextChange('');
                },
              ),
            )
          : const SizedBox(),
    );

    return ClipRect(
        child: TextField(
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      focusNode: widget.focusNode,
      onChanged: _onTextChange,
      autofocus: widget.autofocus,
      controller: widget.controller,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      buildCounter: (
        context, {
        required currentLength,
        maxLength,
        required isFocused,
      }) {
        currentLength = getRealUnicodeCount(widget.controller.text);
        if (!widget.needCounter) return null;
        if (maxLength == null) return const SizedBox();
        return Container(
            padding: EdgeInsets.zero,
            child: RichText(
              text: TextSpan(
                  text: '$currentLength',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      height: 1.35,
                      fontFamilyFallback: defaultFontFamilyFallback,
                      fontSize: 12,
                      color: currentLength > maxLength
                          ? AppTheme.of(context).function.red1
                          : AppTheme.of(context).fg.b60),
                  children: [
                    TextSpan(
                      text: '/$maxLength',
                      style: TextStyle(
                          color: AppTheme.of(context).fg.b60,
                          fontWeight: FontWeight.normal,
                          height: 1.35,
                          fontFamilyFallback: defaultFontFamilyFallback,
                          fontSize: 12),
                    )
                  ]),
            ));
      },
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLength != null
          ? MaxLengthEnforcement.none
          : MaxLengthEnforcement.enforced,
      decoration: decoration,
      onEditingComplete: widget.onEditingComplete,
      style: widget.style,
    ));
  }

  void _onTextChange(String val) {
    setState(() {});
    if (widget.onChange != null) widget.onChange!(val);
  }

  void setClearButtonState() {
    _isShowClear = widget.controller.text.trim().isNotEmpty;
  }

  void checkNeedShowClearButton() {
    final isNeedShow = widget.controller.text.trim().isNotEmpty;
    if (_isShowClear != isNeedShow) {
      if (mounted) {
        setState(() {
          _isShowClear = isNeedShow;
        });
      }
    }
  }

  static int getRealUnicodeCount(String text) {
    if (_regexEmoji.hasMatch(text)) {
      if (_specialString.hasMatch(text)) {
        final realString = text.replaceAll(_specialString, '1');
        return realString.characters.length;
      }
    } else if (text.length > text.characters.length) {
      return text.length;
    }
    return text.characters.length;
  }

// bool get _isShowClear => widget.controller.text.trim().isNotEmpty;
}
