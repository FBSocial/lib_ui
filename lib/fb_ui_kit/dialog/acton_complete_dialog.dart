import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_theme/const.dart';

class ActionCompleteDialog extends StatelessWidget {
  final Widget? icon;
  final String? text;
  final int type;
  final List<TextButton>? buttons;

  const ActionCompleteDialog(
      {this.icon, this.text, this.buttons, this.type = 0, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = type == 0 ? 320 : 280;
    final Widget space1 = type == 0 ? sizeHeight20 : const SizedBox(height: 36);
    final Widget space2 = type == 0 ? sizeHeight10 : const SizedBox(height: 22);
    final Widget space3 = type == 0 ? sizeHeight32 : const SizedBox(height: 36);

    return Dialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      backgroundColor: Colors.white,
      // child: Container(color: Colors.yellow,width: 400,height: 6000,)
      child: SizedBox(
        // decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(8)),
        //     color: Colors.white),
        width: width,
        // height: 200,
        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     _buildIcon(),
        //     _buildText(),
        //     Divider(
        //       height: 0.5,
        //       color: const Color(0xFF8F959E).withOpacity(0.2),
        //     ),
        //     // _buildButtons(),
        //   ],
        // ),
        child: ListView(
          shrinkWrap: true,
          children: [
            space1,
            _buildIcon()!,
            space2,
            _buildText(context),
            space3,
            ..._buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget? _buildIcon() {
    if (icon == null) return const SizedBox();
    return icon;
  }

  Widget _buildText(BuildContext context) {
    if (text!.isEmpty) return const SizedBox();
    return Text(
      text!,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 18,
          height: 22.0 / 18.0,
          color: AppTheme.of(context).fg.b60,
          fontWeight: FontWeight.w600),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    final List<Widget> items = [];
    if (buttons!.isEmpty) return items;
    for (var element in buttons!) {
      items.add(_normalDivider(context));
      items.add(element);
    }
    return items;
  }

  Widget _normalDivider(BuildContext context) {
    return Divider(
      height: 0.5,
      color: AppTheme.of(context).fg.b10,
    );
  }
}
