import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lib_theme/app_theme.dart';
import 'package:lib_ui/gesture/fb_ignore_pointer.dart';

import 'animation_fade_wrap.dart';
import 'animation_offet_wrap.dart';
import 'popup_ballon_layout_delegate.dart';

enum TooltipDirection { up, down, center }

enum ShowCloseButton { inside, outside, none }

enum ClipAreaShape { oval, rectangle }

typedef OutSideTapHandler = void Function();
typedef PopupBuilder = Widget Function(BuildContext, TooltipDirection);

////////////////////////////////////////////////////////////////////////////////////////////////////
/// Super flexible Tooltip class that allows you to show any content
/// inside a Tooltip in the overlay of the screen.
///
class MessageTooltip {
  /// Allows to accedd the closebutton for UI Testing
  static Key closeButtonKey = const Key("CloseButtonKey");

  /// Signals if the Tooltip is visible at the moment
  bool isOpen = false;

  ///
  /// The content of the Tooltip
  final PopupBuilder builder;

  ///
  /// The direcion in which the tooltip should open
  TooltipDirection? popupDirection;

  ///
  /// optional handler that gets called when the Tooltip is closed
  final OutSideTapHandler? onClose;

  ///
  /// [minWidth], [minHeight], [maxWidth], [maxHeight] optional size constraints.
  /// If a constraint is not set the size will ajust to the content
  double? minWidth, minHeight, maxWidth, maxHeight;

  ///
  /// The minium padding from the Tooltip to the screen limits
  final double minimumOutSidePadding;

  ///
  /// If [snapsFarAwayVertically== true] the bigger free space above or below the target will be
  /// covered completely by the ToolTip. All other dimension or position constraints get overwritten
  final bool snapsFarAwayVertically;

  ///
  /// If [snapsFarAwayHorizontally== true] the bigger free space left or right of the target will be
  /// covered completely by the ToolTip. All other dimension or position constraints get overwritten
  final bool snapsFarAwayHorizontally;

  /// [top], [right], [bottom], [left] position the Tooltip absolute relative to the whole screen
  double? top, right, bottom, left;

  ///
  /// A Tooltip can have none, an inside or an outside close icon
  final ShowCloseButton showCloseButton;

  ///
  /// [hasShadow] defines if the tooltip should have a shadow
  final bool hasShadow;

  ///
  /// The shadow color.
  final Color shadowColor;

  ///
  /// The shadow blur radius.
  final double shadowBlurRadius;

  ///
  /// The shadow spread radius.
  final double shadowSpreadRadius;

  ///
  /// the stroke width of the border
  final double borderWidth;

  ///
  /// The corder radii of the border
  final double borderRadius;

  ///
  /// The color of the border
  final Color borderColor;

  ///
  /// The color of the close icon
  final Color closeButtonColor;

  ///
  /// The size of the close button
  final double closeButtonSize;

  ///
  /// The length of the Arrow
  final double arrowLength;

  ///
  /// The width of the arrow at its base
  final double arrowBaseWidth;

  ///
  /// The distance of the tip of the arrow's tip to the center of the target
  final double arrowTipDistance;

  ///
  /// The backgroundcolor of the Tooltip
  final Color backgroundColor;

  /// The color of the rest of the overlay surrounding the Tooltip.
  /// typically a translucent color.
  final Color outsideBackgroundColor;

  ///
  /// By default touching the surrounding of the Tooltip closes the tooltip.
  /// you can define a rectangle area where the background is completely transparent
  /// and the widgets below react to touch
  final Rect? touchThrougArea;

  ///
  /// The shape of the [touchThrougArea].
  final ClipAreaShape touchThroughAreaShape;

  ///
  /// If [touchThroughAreaShape] is [ClipAreaShape.rectangle] you can define a border radius
  final double touchThroughAreaCornerRadius;

  // final bool preferblow;

  ///
  /// Let's you pass a key to the Tooltips cotainer for UI Testing
  final Key? tooltipContainerKey;

  Offset? _targetCenter;
  OverlayEntry? _backGroundOverlay;
  OverlayEntry? _ballonOverlay;

  MessageTooltip({
    this.tooltipContainerKey,
    required this.builder, // The contents of the tooltip.
    // this.popupDirection,
    this.onClose,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.minimumOutSidePadding = 20.0,
    this.showCloseButton = ShowCloseButton.none,
    this.snapsFarAwayVertically = false,
    this.snapsFarAwayHorizontally = false,
    this.hasShadow = true,
    this.shadowColor = Colors.black54,
    this.shadowBlurRadius = 10.0,
    this.shadowSpreadRadius = 5.0,
    this.borderWidth = 2.0,
    this.borderRadius = 10.0,
    this.borderColor = Colors.black,
    this.closeButtonColor = Colors.black,
    this.closeButtonSize = 30.0,
    this.arrowLength = 20.0,
    this.arrowBaseWidth = 20.0,
    this.arrowTipDistance = 2.0,
    this.backgroundColor = Colors.white,
    this.outsideBackgroundColor = const Color.fromARGB(50, 255, 255, 255),
    this.touchThroughAreaShape = ClipAreaShape.oval,
    this.touchThroughAreaCornerRadius = 5.0,
    this.touchThrougArea,
    // this.preferblow = false,
  })  : assert((maxWidth ?? double.infinity) >= (minWidth ?? 0.0)),
        assert((maxHeight ?? double.infinity) >= (minHeight ?? 0.0));

  ///
  /// Removes the Tooltip from the overlay
  void close() {
    if (!isOpen) {
      return;
    }
    if (onClose != null) {
      onClose!();
    }

    _ballonOverlay!.remove();
    _backGroundOverlay!.remove();
    isOpen = false;
  }

  ///
  /// Displays the tooltip
  /// The center of [targetContext] is used as target of the arrow
  void show(BuildContext targetContext) {
    final RenderBox renderBox = targetContext.findRenderObject() as RenderBox;
    final RenderBox? overlay =
        Overlay.of(targetContext)!.context.findRenderObject() as RenderBox?;

    _targetCenter = renderBox.localToGlobal(
        renderBox.size.topCenter(Offset.zero),
        ancestor: overlay);
    // if (_targetCenter.dy < 0) {
    //   _targetCenter = renderBox.localToGlobal(
    //       renderBox.size.bottomCenter(Offset(0, 10)),
    //       ancestor: overlay);
    // }
    // Create the background below the popup including the clipArea.
    // popupDirection = preferblow ? TooltipDirection.up : TooltipDirection.down;
    _backGroundOverlay = OverlayEntry(
        builder: (context) => AnimationFadeWrapper(
            builder: (context, opacity) => FBIgnorePointer(
                  onDown: close,
                  child: Container(
                      decoration: ShapeDecoration(
                          shape: _ShapeOverlay(
                              touchThrougArea,
                              touchThroughAreaShape,
                              touchThroughAreaCornerRadius,
                              outsideBackgroundColor))),
                )));

    /// Handling snap far away feature.
    // if (snapsFarAwayVertically) {
    //   maxHeight = null;
    //   left = 0.0;
    //   right = 0.0;
    //   if (_targetCenter.dy > overlay.size.center(Offset.zero).dy) {
    //     popupDirection = TooltipDirection.up;
    //     top = 0.0;
    //   } else {
    //     popupDirection = TooltipDirection.down;
    //     bottom = 0.0;
    //   }
    // } // Only one of of them is possible, and vertical has higher priority.
    // else if (snapsFarAwayHorizontally) {
    //   maxWidth = null;
    //   top = 0.0;
    //   bottom = 0.0;
    //   if (_targetCenter.dx < overlay.size.center(Offset.zero).dx) {
    //     popupDirection = TooltipDirection.right;
    //     right = 0.0;
    //   } else {
    //     popupDirection = TooltipDirection.left;
    //     left = 0.0;
    //   }
    // }

    _ballonOverlay = OverlayEntry(builder: (context) {
      final delegate = PopupBallonLayoutDelegate(
        context: context,
        targetCenter: _targetCenter,
        renderBoxSize: renderBox.size,
        // minWidth: minWidth,
        // maxWidth: maxWidth,
        minHeight: minHeight,
        // maxHeight: maxHeight,
        outSidePadding: minimumOutSidePadding,
        // top: top,
        // bottom: bottom,
        left: left,
        right: right,
      );
      return AnimationOffsetWrapper(
        builder: (context, offset, opacity) => AnimatedOpacity(
          duration: const Duration(
            milliseconds: 200,
          ),
          opacity: opacity,
          child: AnimatedContainer(
            transform: Transform.translate(offset: offset).transform,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: Center(
                child: CustomSingleChildLayout(
                    delegate: delegate,
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [_buildPopUp(context, delegate.popupDirection)],
                    ))),
          ),
        ),
      );
    });

    Overlay.of(targetContext)!
        .insertAll([_backGroundOverlay!, _ballonOverlay!]);
    isOpen = true;
  }

  Widget _buildPopUp(BuildContext context, TooltipDirection popupDirection) {
    return Positioned(
      child: Container(
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? double.infinity
            : 334,
        key: tooltipContainerKey,
        margin: MediaQuery.of(context).orientation == Orientation.portrait
            ? EdgeInsets.zero
            : const EdgeInsets.only(left: 300),
        decoration: BoxDecoration(
          color: AppTheme.of(context).bg.bg3,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: AppTheme.of(context).fg.b10, width: 0.5),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                      color: AppTheme.of(context).fg.b5,
                      offset: const Offset(0, 1),
                      blurRadius: 8,
                      spreadRadius: 2),
                  BoxShadow(
                      color: AppTheme.of(context).fg.b10,
                      offset: const Offset(0, 2),
                      blurRadius: 16)
                ]
              : null,
        ),
        child: builder(context, popupDirection),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////

class _ShapeOverlay extends ShapeBorder {
  final Rect? clipRect;
  final Color outsideBackgroundColor;
  final ClipAreaShape clipAreaShape;
  final double clipAreaCornerRadius;

  const _ShapeOverlay(this.clipRect, this.clipAreaShape,
      this.clipAreaCornerRadius, this.outsideBackgroundColor);

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addOval(clipRect!);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path outer = Path()..addRect(rect);

    if (clipRect == null) {
      return outer;
    }
    Path exclusion;
    if (clipAreaShape == ClipAreaShape.oval) {
      exclusion = Path()..addOval(clipRect!);
    } else {
      exclusion = Path()
        ..moveTo(clipRect!.left + clipAreaCornerRadius, clipRect!.top)
        ..lineTo(clipRect!.right - clipAreaCornerRadius, clipRect!.top)
        ..arcToPoint(
            Offset(clipRect!.right, clipRect!.top + clipAreaCornerRadius),
            radius: Radius.circular(clipAreaCornerRadius))
        ..lineTo(clipRect!.right, clipRect!.bottom - clipAreaCornerRadius)
        ..arcToPoint(
            Offset(clipRect!.right - clipAreaCornerRadius, clipRect!.bottom),
            radius: Radius.circular(clipAreaCornerRadius))
        ..lineTo(clipRect!.left + clipAreaCornerRadius, clipRect!.bottom)
        ..arcToPoint(
            Offset(clipRect!.left, clipRect!.bottom - clipAreaCornerRadius),
            radius: Radius.circular(clipAreaCornerRadius))
        ..lineTo(clipRect!.left, clipRect!.top + clipAreaCornerRadius)
        ..arcToPoint(
            Offset(clipRect!.left + clipAreaCornerRadius, clipRect!.top),
            radius: Radius.circular(clipAreaCornerRadius))
        ..close();
    }

    return Path.combine(ui.PathOperation.difference, outer, exclusion);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(
        getOuterPath(rect), Paint()..color = outsideBackgroundColor);
  }

  @override
  ShapeBorder scale(double t) {
    return _ShapeOverlay(
        clipRect, clipAreaShape, clipAreaCornerRadius, outsideBackgroundColor);
  }
}
