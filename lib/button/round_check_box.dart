import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:websafe_svg/websafe_svg.dart';

class RoundCheckBox extends StatefulWidget {
  final bool? defaultValue;
  final double size;
  final double left; // 给出左右是为了方便与其它控件对齐，并扩大点击范围
  final double right;
  final double top;
  final double bottom;
  final ValueChanged<bool>? onChanged;

  const RoundCheckBox({
    this.defaultValue = false,
    this.size = 16,
    this.left = 6,
    this.right = 6,
    this.top = 6,
    this.bottom = 6,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  bool? _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _selected = !_selected!;
        });
        widget.onChanged!(_selected!);
      },
      // ignore: avoid_unnecessary_containers
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              widget.left, widget.top, widget.right, widget.bottom),
          child: WebsafeSvg.asset(
            'assets/svg/${_selected! ? "" : "un"}check_image.svg',
            fit: BoxFit.fill,
            width: widget.size,
            height: widget.size,
          ),
        ),
      ),
    );
  }
}
