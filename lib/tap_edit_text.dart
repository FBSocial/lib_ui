import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';

class TabEditText extends StatefulWidget {
  final String? initialText;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final int? maxLength;

  const TabEditText({
    Key? key,
    this.initialText,
    this.style,
    this.onChanged,
    this.decoration,
    this.maxLength,
  }) : super(key: key);

  @override
  _TabEditTextState createState() => _TabEditTextState();
}

class _TabEditTextState extends State<TabEditText> {
  bool isEditing = false;
  TextEditingController? controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialText ?? '');
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildEditText();
  }

  @override
  void didUpdateWidget(TabEditText oldWidget) {
    controller!.text = widget.initialText!;
    super.didUpdateWidget(oldWidget);
  }

  Widget buildEditText() {
    return TextField(
      controller: controller,
      style: widget.style ??
          TextStyle(
              fontSize: 17, color: AppTheme.of(context).fg.b100, height: 1),
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      decoration: widget.decoration ??
          const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: 12),
            counterText: "",
          ),
    );
  }
}
