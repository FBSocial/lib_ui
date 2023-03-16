import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_utils/orientation_util.dart';

class MouseHoverBuilder extends StatelessWidget {
  final Widget Function(BuildContext, bool)? builder;
  final SystemMouseCursor cursor;

  MouseHoverBuilder({
    this.builder,
    this.cursor = SystemMouseCursors.basic,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<bool> _value = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    if (OrientationUtil.portrait) return builder!(context, false);
    return MouseRegion(
      onEnter: (_) => _value.value = true,
      onExit: (_) => _value.value = false,
      cursor: cursor,
      child: ValueListenableBuilder<bool>(
        valueListenable: _value,
        builder: (context, value, child) {
          return builder!(context, value);
        },
      ),
    );
  }
}

class MouseHoverStatefulBuilder extends StatefulWidget {
  final Widget Function(BuildContext, bool)? builder;
  final SystemMouseCursor cursor;

  const MouseHoverStatefulBuilder({
    this.builder,
    this.cursor = SystemMouseCursors.basic,
    Key? key,
  }) : super(key: key);

  @override
  State<MouseHoverStatefulBuilder> createState() =>
      _MouseHoverStatefulBuilderState();
}

class _MouseHoverStatefulBuilderState extends State<MouseHoverStatefulBuilder> {
  final ValueNotifier<bool> _value = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => _value.value = true,
        onExit: (_) => _value.value = false,
        cursor: widget.cursor,
        child: ValueListenableBuilder<bool>(
          valueListenable: _value,
          builder: (context, value, child) => widget.builder!(context, value),
        ),
      );
}