import 'package:flutter/material.dart';

Widget _buildMaterialDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  @Deprecated(
      'Instead of using the "child" argument, return the child from a closure '
          'provided to the "builder" argument. This will ensure that the BuildContext '
          'is appropriate for widgets built in the dialog. '
          'This feature was deprecated after v0.2.3.'
  )
  Widget? child,
  WidgetBuilder? builder,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  assert(child == null || builder == null);
  assert(debugCheckHasMaterialLocalizations(context));

  return showGeneralDialog(
    context: context,
    pageBuilder: (buildContext,  animation,  secondaryAnimation) {
      final Widget pageChild = child ?? Builder(builder: builder!);
      return pageChild;
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}