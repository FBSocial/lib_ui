import 'package:flutter/material.dart';

import 'icon_font.dart';

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    Key? key,
    this.selected,
    this.size = 18.33,
    this.disabled = false,
    this.type = SelectButtonType.checkbox,
  }) : super(key: key);

  final bool? selected;
  final bool disabled;
  final double size;
  final SelectButtonType type;

  @override
  Widget build(BuildContext context) {
    final highlightColor = Theme.of(context).primaryColor;
    const grayColor = Color(0xFF8F959E);
    final bgColor = !selected!
        ? Colors.transparent
        : (disabled ? grayColor : highlightColor);
    final borderColor = !selected!
        ? (disabled ? grayColor.withOpacity(0.5) : grayColor)
        : (disabled ? grayColor : highlightColor);
    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        color: bgColor,
        shape: type == SelectButtonType.checkbox
            ? RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(1.83)),
                side: BorderSide(color: borderColor),
              )
            : CircleBorder(side: BorderSide(color: borderColor)),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        opacity: selected! ? 1 : 0,
        child: const Padding(
          padding: EdgeInsets.all(2),
          child: FittedBox(
            child: Icon(IconFont.audioVisualRight, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// 多选按钮-方形
/// [value]为是否选中
class CheckButton extends StatefulWidget {
  const CheckButton({
    Key? key,
    required this.value,
    this.size = 18.33,
    this.disabled = false,
  }) : super(key: key);

  final bool value;
  final bool disabled;
  final double size;

  @override
  _CheckButtonState createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final selected = widget.value;
    return _SelectBox(
      selected: selected,
      size: widget.size,
      disabled: widget.disabled,
    );
  }
}

/// 单选按钮-圆形
/// [value]与[groupValue]一致时为选中状态
class RadioButton<T> extends StatefulWidget {
  const RadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    this.size = 18.33,
    this.disabled = false,
  }) : super(key: key);

  final T value;
  final T groupValue;
  final bool disabled;
  final double size;

  @override
  _RadioButtonState<T> createState() => _RadioButtonState<T>();
}

class _RadioButtonState<T> extends State<RadioButton<T>> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final selected = widget.value == widget.groupValue;
    return _SelectBox(
      size: widget.size,
      disabled: widget.disabled,
      selected: selected,
      type: SelectButtonType.radio,
    );
  }
}

enum SelectButtonType {
  checkbox,
  radio,
}
