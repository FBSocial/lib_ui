import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';

import 'icon_font.dart';

class FBCheckBox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final EdgeInsetsGeometry padding;

  const FBCheckBox({
    Key? key,
    this.value = false,
    this.onChanged,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  _FBCheckBoxState createState() => _FBCheckBoxState();
}

class _FBCheckBoxState extends State<FBCheckBox> {
  bool? _isCheck = false;

  @override
  void initState() {
    _isCheck = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(FBCheckBox oldWidget) {
    if (oldWidget.value != widget.value) _isCheck = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.onChanged?.call(!_isCheck!);
        setState(() {});
      },
      child: Padding(
        padding: widget.padding,
        child: _isCheck!
            ? Icon(
                IconFont.selectGroup,
                size: 20,
                color: selectedColor,
              )
            : Icon(
                IconFont.unselectGroup,
                size: 20,
                color: AppTheme.of(context).fg.b40,
              ),
      ),
    );
  }
}
