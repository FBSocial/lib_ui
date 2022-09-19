import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_theme/default_theme.dart';

import 'icon_font.dart';

class CheckCircleBox extends StatefulWidget {
  final bool value;
  final double size;
  final ValueChanged<bool>? onChanged;

  const CheckCircleBox(
      {Key? key, this.value = false, this.onChanged, this.size = 24})
      : super(key: key);

  @override
  _CheckCircleBoxState createState() => _CheckCircleBoxState();
}

class _CheckCircleBoxState extends State<CheckCircleBox> {
  bool _isCheck = false;

  @override
  void initState() {
    _isCheck = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(CheckCircleBox oldWidget) {
    _isCheck = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isCheck = !_isCheck;
        widget.onChanged?.call(_isCheck);
        setState(() {});
      },
      child: _isCheck
          ? Icon(
              IconFont.selectSingle,
              size: widget.size,
              color: primaryColor,
            )
          : Container(
              width: widget.size,
              height: widget.size,
              padding: const EdgeInsets.all(2),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Get.iconColor!.withOpacity(.35))),
              ),
            ),
    );
  }
}
