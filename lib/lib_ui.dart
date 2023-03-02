library lib_ui;

import 'package:flutter/cupertino.dart';
import 'package:lib_ui/src/theme.dart';
import 'package:oktoast/oktoast.dart';

export 'src/fb_design/buttons/fb_buttons.dart';
export 'src/fb_design/dialog.dart';
export 'src/fb_design/fb_loading_indicator.dart';
export 'src/theme.dart';

class FbTheme extends StatelessWidget {
  final Widget child;

  const FbTheme({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
        radius: 8,
        backgroundColor: fbTheme.textTheme.bodyText2!.color!.withOpacity(0.95),
        textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: child);
  }
}
