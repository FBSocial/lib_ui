import 'package:flutter/material.dart';

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
                    color: selectColor ??
                        const Color(0xff8F959E).withOpacity(0.5)),
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selectColor ?? const Color(0xff8F959E).withOpacity(0.5),
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
                      color: unSelectColor ??
                          const Color(0xff8F959E).withOpacity(0.5))),
            ),
    );
  }
}
