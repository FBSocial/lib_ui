import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_extension/string_extension.dart';
import 'package:lib_theme/app_theme.dart';

class FbTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextInputType?
      keyboardType; // iOS 支持的类型是 .text/.number/.phone/.emailAddress
  final TextStyle? style;
  final VoidCallback? onEditingComplete;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool? autofocus;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final double borderRadius;
  final double? height; // 原生iOS 需要
  final int? maxLines;
  final TextSelectionControls? selectionControls;

  const FbTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.style,
    this.backgroundColor,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.autofocus,
    this.maxLength,
    this.maxLengthEnforcement,
    this.inputFormatters,
    this.readOnly,
    this.borderRadius = 6,
    this.height,
    this.maxLines = 1,
    this.selectionControls,
    this.hintText,
    this.hintStyle,
    this.padding,
  }) : super(key: key);

  @override
  State<FbTextField> createState() => _FbTextFieldState();
}

class _FbTextFieldState extends State<FbTextField> {
  late TextEditingController _controller;
  late TextStyle _style;
  late TextStyle _hintStyle;
  late EdgeInsetsGeometry _padding;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    reset();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant FbTextField oldWidget) {
    reset();
    super.didUpdateWidget(oldWidget);
  }

  bool get isSingleLine => widget.maxLines == 1;

  EdgeInsetsGeometry get defaultPadding => isSingleLine
      ? const EdgeInsets.all(16)
      : const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: 12,
        );

  void reset() {
    _padding = widget.padding ?? defaultPadding;
    _hintStyle = widget.hintStyle ??
        TextStyle(
            color: AppTheme.of(context).fg.b30, fontSize: 16, height: 20 / 16);
    _style = widget.style ??
        TextStyle(
          fontSize: 16,
          color: AppTheme.of(context).fg.b100,
          height: 20 / 16,
        );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isSingleLine) {
      child = _singleLineTextField();
    } else {
      child = _multiLineTextField();
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppTheme.of(context).bg.bg1,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      height: widget.height,
      padding: _padding,
      child: child,
    );
  }

  Widget _singleLineTextField() {
    return Row(
      children: [
        Expanded(child: _input()),
        const SizedBox(width: 8),
        _clearIcon(),
        if (widget.maxLength != null) ...[
          const SizedBox(width: 8),
          _counter(),
        ]
      ],
    );
  }

  Widget _multiLineTextField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _input(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _clearIcon(),
            if (widget.maxLength != null) ...[
              const SizedBox(width: 8),
              _counter(),
            ]
          ],
        )
      ],
    );
  }

  Widget _input() {
    return TextField(
      style: _style,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        counterText: '',
        hintText: widget.hintText,
        hintStyle: _hintStyle,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      maxLines: widget.maxLines,
      // maxLength: widget.maxLength,
      controller: _controller,
      onChanged: (val) {
        setState(() {});
        widget.onChanged?.call(val);
      },
    );
  }

  Widget _clearIcon() {
    if (_controller.text.removeUnprintable().isEmpty) return const SizedBox();
    return GestureDetector(
      onTap: () {
        _controller.clear();
        setState(() {});
        widget.onChanged?.call('');
      },
      child: Icon(
        IconFont.buffInputClearIcon,
        size: 17,
        color: const Color(0xFF8F959E).withOpacity(0.75),
      ),
    );
  }

  Widget _counter() {
    final val = _controller.text.removeUnprintable().characters;
    final isOverflow = val.length > widget.maxLength!;
    return RichText(
      text: TextSpan(
          text: '${val.length}',
          style: TextStyle(
            fontSize: 14,
            color: isOverflow
                ? Theme.of(context).errorColor
                : AppTheme.of(context).fg.b40,
          ),
          children: [
            TextSpan(
              text: '/${widget.maxLength}',
              style:
                  TextStyle(fontSize: 14, color: AppTheme.of(context).fg.b40),
            )
          ]),
    );
  }
}
