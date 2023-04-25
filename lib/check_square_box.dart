import 'package:flutter/material.dart';
import 'package:lib_ui/radio_button.dart';

class CheckSquareBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CheckSquareBox({Key? key, this.value = false, this.onChanged})
      : super(key: key);

  @override
  _CheckSquareBoxState createState() => _CheckSquareBoxState();
}

class _CheckSquareBoxState extends State<CheckSquareBox> {
  bool _isCheck = false;

  @override
  void initState() {
    _isCheck = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(CheckSquareBox oldWidget) {
    if (oldWidget.value != widget.value) _isCheck = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: GestureDetector(
        onTap: () {
          _isCheck = !_isCheck;
          widget.onChanged?.call(_isCheck);
          setState(() {});
        },
        child: checkBoxButton(20, _isCheck, context),
      ),
    );
  }
}
