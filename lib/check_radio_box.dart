import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';

class CheckRadioBox extends StatelessWidget {
  final bool value;
  final VoidCallback? onTap;
  final Color? selectColor;
  final Color? unSelectColor;

  const CheckRadioBox(
      {Key? key,
      this.value = false,
      this.onTap,
      this.selectColor,
      this.unSelectColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: value
          ? Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: selectColor ?? AppTheme.of(context).fg.b10),
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectColor ?? AppTheme.of(context).fg.b10,
                  ),
                ),
              ),
            )
          : Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: unSelectColor ?? AppTheme.of(context).fg.b10)),
            ),
    );
  }
}
