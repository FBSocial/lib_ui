import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ShowCloseButton { inside, outside, none }

enum ClipAreaShape { oval, rectangle }

typedef OutSideTapHandler = void Function();

////////////////////////////////////////////////////////////////////////////////////////////////////
/// Super flexible Tooltip class that allows you to show any content
/// inside a Tooltip in the overlay of the screen.
///
class RichEditorSuperTooltip {
  /// Allows to accedd the closebutton for UI Testing
  static Key closeButtonKey = const Key("CloseButtonKey");

  /// Signals if the Tooltip is visible at the moment
  bool isOpen = false;

  final Offset? globalPoint;

  ///
  /// The content of the Tooltip
  final Widget content;

  ///
  /// optional handler that gets called when the Tooltip is closed
  final OutSideTapHandler? onClose;

  ///
  /// [minWidth], [minHeight], [maxWidth], [maxHeight] optional size constraints.
  /// If a constraint is not set the size will ajust to the content
  // double minWidth, minHeight, maxWidth, maxHeight;

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
  double? top, right, bottom, left, offsetX, offsetY;

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

  ///
  /// Let's you pass a key to the Tooltips cotainer for UI Testing
  final Key? tooltipContainerKey;

  ///
  /// Allow the tooltip to be dismissed tapping outside
  final bool dismissOnTapOutside;

  ///
  /// Enable background overlay
  final bool containsBackgroundOverlay;
  // 在direction为auto时生效，优先取向上
  final bool preferenceTop;
  OverlayEntry? _ballonOverlay;

  RichEditorSuperTooltip({
    this.tooltipContainerKey,
    required this.content, // The contents of the tooltip.
    this.onClose,
    this.globalPoint,
    // this.minWidth,
    // this.minHeight,
    // this.maxWidth,
    // this.maxHeight,
    this.offsetX = 0,
    this.offsetY = 0,
    this.minimumOutSidePadding = 10.0,
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
    this.dismissOnTapOutside = true,
    this.containsBackgroundOverlay = true,
    this.preferenceTop = true,
  });
  // assert((maxWidth ?? double.infinity) >= (minWidth ?? 0.0)),
  // assert((maxHeight ?? double.infinity) >= (minHeight ?? 0.0));

  ///
  /// Removes the Tooltip from the overlay
  void close() {
    if (onClose != null) {
      onClose!();
    }

    _ballonOverlay!.remove();
    // _backGroundOverlay?.remove();
    isOpen = false;
  }

  ///
  /// Displays the tooltip
  /// The center of [targetContext] is used as target of the arrow
  void show(BuildContext targetContext) {
    final renderBox = targetContext.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(targetContext).context.findRenderObject() as RenderBox?;

    final x1 = renderBox
        .localToGlobal(renderBox.size.centerLeft(Offset.zero),
            ancestor: overlay)
        .dx;

    // Create the background below the popup including the clipArea.
    // if (containsBackgroundOverlay) {
    //   _backGroundOverlay = OverlayEntry(
    //       builder: (context) => _AnimationWrapper(
    //             builder: (context, opacity) => AnimatedOpacity(
    //               opacity: opacity,
    //               duration: const Duration(milliseconds: 600),
    //               child: GestureDetector(
    //                 onTap: () {
    //                   if (dismissOnTapOutside) {
    //                     close();
    //                   }
    //                 },
    //                 child: Container(
    //                     decoration: const BoxDecoration(color: Colors.black12)),
    //               ),
    //             ),
    //           ));
    // }

    _ballonOverlay = OverlayEntry(
      builder: (context) => LayoutBuilder(
        builder: (context, constraints) => _AnimationWrapper(
          builder: (context, opacity) => AnimatedOpacity(
            duration: const Duration(
              milliseconds: 300,
            ),
            opacity: opacity,
            child: CustomSingleChildLayout(
                delegate: _PopupBallonLayoutDelegate(
                  maxWidth: renderBox.constraints.maxWidth,
                  maxHeight: Get.size.height,
                  offset: Offset(x1, 0),
                ),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [_buildBackground(), _buildPopUp()],
                )),
          ),
        ),
      ),
    );

    final overlays = <OverlayEntry?>[];

    // if (containsBackgroundOverlay) {
    //   overlays.add(_backGroundOverlay);
    // }
    overlays.add(_ballonOverlay);
    Overlay.of(targetContext).insertAll(overlays as Iterable<OverlayEntry>);
    isOpen = true;
  }

  Widget _buildPopUp() {
    return Positioned.fill(
      top: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      ),
    );
  }

  Widget _buildBackground() {
    return GestureDetector(
        onTap: () {
          if (dismissOnTapOutside) {
            close();
          }
        },
        child: const DecoratedBox(
            decoration: BoxDecoration(color: Colors.black38)));
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _PopupBallonLayoutDelegate extends SingleChildLayoutDelegate {
  final Offset? offset;
  final double? _maxWidth;
  final double? _maxHeight;
  _PopupBallonLayoutDelegate({
    this.offset,
    double? maxWidth,
    double? maxHeight,
  })  : _maxWidth = maxWidth,
        _maxHeight = maxHeight;
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return offset!;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: _maxWidth, height: _maxHeight);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return false;
  }
}

typedef FadeBuilder = Widget Function(BuildContext, double);

////////////////////////////////////////////////////////////////////////////////////////////////////

class _AnimationWrapper extends StatefulWidget {
  final FadeBuilder? builder;

  const _AnimationWrapper({this.builder});

  @override
  _AnimationWrapperState createState() => _AnimationWrapperState();
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _AnimationWrapperState extends State<_AnimationWrapper> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder!(context, opacity);
  }
}
