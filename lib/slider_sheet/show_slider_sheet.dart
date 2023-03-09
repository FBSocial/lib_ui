// ignore_for_file: unnecessary_null_comparison

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';

const Duration _bottomSheetEnterDuration = Duration(milliseconds: 250);
const Duration _bottomSheetExitDuration = Duration(milliseconds: 200);
const Curve _modalBottomSheetCurve = decelerateEasing;

/// 侧边弹窗，从右边弹出
Future<T?> showSliderModal<T>(
  BuildContext context, {
  required Widget body,
  double width = 480,
  bool showTopCache = true,
  SliderDirection direction = SliderDirection.right,
  bool resizeToAvoidBottomInset = true,
}) async {
  return showSliderSheet<T>(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.transparent,
    direction: direction,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    builder: (_) {
      return Container(
          width: width,
          decoration: BoxDecoration(
              color: AppTheme.of(context).bg.bg3,
              borderRadius: direction == SliderDirection.rightDown
                  ? const BorderRadius.vertical(top: Radius.circular(8))
                  : BorderRadius.zero,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 26,
                    spreadRadius: 7,
                    offset: Offset(0, 7),
                    color: Color(0x4C717D8D))
              ]),
          child: body);
    },
  );
}

/// flutter 官方代码， 只是修改layout _ModalBottomSheetLayout => _ModalRightSheetLayout

enum SliderDirection { right, rightDown }

Future<T?> showSliderSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  SliderDirection direction = SliderDirection.right,
  RouteSettings? routeSettings,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_ModalBottomSheetRoute<T>(
      builder: builder,
      isScrollControlled: isScrollControlled,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      enableDrag: enableDrag,
      settings: routeSettings,
      direction: direction));
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.barrierLabel,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.direction,
    required this.isScrollControlled,
    RouteSettings? settings,
  })  : assert(isDismissible != null),
        super(settings: settings);

  final WidgetBuilder? builder;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Color? modalBarrierColor;
  final bool isDismissible;
  final bool enableDrag;
  final SliderDirection? direction;

  @override
  Duration get transitionDuration => _bottomSheetEnterDuration;

  @override
  Duration get reverseTransitionDuration => _bottomSheetExitDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    // ignore: join_return_with_assignment
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Builder(
        builder: (context) {
          final BottomSheetThemeData sheetTheme =
              Theme.of(context).bottomSheetTheme;
          return _ModalBottomSheet<T>(
            route: this,
            backgroundColor: backgroundColor ??
                sheetTheme.modalBackgroundColor ??
                sheetTheme.backgroundColor,
            elevation:
                elevation ?? sheetTheme.modalElevation ?? sheetTheme.elevation,
            shape: shape,
            clipBehavior: clipBehavior,
            isScrollControlled: isScrollControlled,
            enableDrag: enableDrag,
            direction: direction,
          );
        },
      ),
    );
    if (isScrollControlled) {
      bottomSheet = Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({
    Key? key,
    this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.direction,
    this.isScrollControlled = false,
    this.enableDrag = true,
  })  : assert(isScrollControlled != null),
        super(key: key);

  final _ModalBottomSheetRoute<T>? route;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableDrag;
  final SliderDirection? direction;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  ParametricCurve<double?> animationCurve = _modalBottomSheetCurve;

  // ignore: missing_return
  String _getRouteLabel(MaterialLocalizations localizations) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return localizations.dialogLabel;
    }
  }

  void handleDragStart(DragStartDetails details) {
    // Allow the bottom sheet to track the user's finger accurately.
    animationCurve = Curves.linear;
  }

  void handleDragEnd(DragEndDetails details, {bool? isClosing}) {
    // Allow the bottom sheet to animate smoothly from its current position.
    animationCurve = _BottomSheetSuspendedCurve(
      widget.route!.animation!.value,
      curve: _modalBottomSheetCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route!.animation!,
      builder: (context, child) {
        // Disable the initial animation when accessible navigation is on so
        // that the semantics are added to the tree at the correct time.
        final double? animationValue = animationCurve.transform(
            mediaQuery.accessibleNavigation
                ? 1.0
                : widget.route!.animation!.value);
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: CustomSingleChildLayout(
              delegate: widget.direction == SliderDirection.right
                  ? _ModalRightSheetLayout(
                      animationValue, widget.isScrollControlled)
                  : _ModalRightDownSheetLayout(
                      animationValue, widget.isScrollControlled),
              child: child,
            ),
          ),
        );
      },
      child: BottomSheet(
        animationController: widget.route!._animationController,
        onClosing: () {
          if (widget.route!.isCurrent) {
            Navigator.pop(context);
          }
        },
        builder: widget.route!.builder!,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        shape: widget.shape,
        clipBehavior: widget.clipBehavior,
        enableDrag: widget.enableDrag,
        onDragStart: handleDragStart,
        onDragEnd: handleDragEnd,
      ),
    );
  }
}

class _ModalRightSheetLayout extends SingleChildLayoutDelegate {
  _ModalRightSheetLayout(this.progress, this.isScrollControlled);

  final double? progress;
  final bool isScrollControlled;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      maxWidth: constraints.maxWidth,
      minHeight: isScrollControlled
          ? constraints.maxHeight
          : constraints.maxHeight * 9.0 / 16.0,
      maxHeight: isScrollControlled
          ? constraints.maxHeight
          : constraints.maxHeight * 9.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width - childSize.width * progress!, 0);
  }

  @override
  bool shouldRelayout(_ModalRightSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _ModalRightDownSheetLayout extends SingleChildLayoutDelegate {
  _ModalRightDownSheetLayout(this.progress, this.isScrollControlled);

  final double? progress;
  final bool isScrollControlled;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      maxWidth: constraints.maxWidth,
      maxHeight: isScrollControlled
          ? constraints.maxHeight
          : constraints.maxHeight * 9.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width - childSize.width,
        size.height - childSize.height * progress!);
  }

  @override
  bool shouldRelayout(_ModalRightDownSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

// TODO(guidezpl): Look into making this public. A copy of this class is in
//  scaffold.dart, for now, https://github.com/flutter/flutter/issues/51627
/// A curve that progresses linearly until a specified [startingPoint], at which
/// point [curve] will begin. Unlike [Interval], [curve] will not start at zero,
/// but will use [startingPoint] as the Y position.
///
/// For example, if [startingPoint] is set to `0.5`, and [curve] is set to
/// [Curves.easeOut], then the bottom-left quarter of the curve will be a
/// straight line, and the top-right quarter will contain the entire contents of
/// [Curves.easeOut].
///
/// This is useful in situations where a widget must track the user's finger
/// (which requires a linear animation), and afterwards can be flung using a
/// curve specified with the [curve] argument, after the finger is released. In
/// such a case, the value of [startingPoint] would be the progress of the
/// animation at the time when the finger was released.
///
/// The [startingPoint] and [curve] arguments must not be null.
class _BottomSheetSuspendedCurve extends ParametricCurve<double?> {
  /// Creates a suspended curve.
  const _BottomSheetSuspendedCurve(
    this.startingPoint, {
    this.curve = Curves.easeOutCubic,
  }) : assert(curve != null);

  /// The progress value at which [curve] should begin.
  ///
  /// This defaults to [Curves.easeOutCubic].
  final double startingPoint;

  /// The curve to use when [startingPoint] is reached.
  final Curve curve;

  @override
  double? transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    assert(startingPoint >= 0.0 && startingPoint <= 1.0);

    if (t < startingPoint) {
      return t;
    }

    if (t == 1.0) {
      return t;
    }

    final double curveProgress = (t - startingPoint) / (1 - startingPoint);
    final double transformed = curve.transform(curveProgress);
    return lerpDouble(startingPoint, 1, transformed);
  }

  @override
  String toString() {
    return '${describeIdentity(this)}($startingPoint, $curve)';
  }
}
