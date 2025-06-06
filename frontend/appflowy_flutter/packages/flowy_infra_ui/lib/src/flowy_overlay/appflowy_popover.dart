import 'package:appflowy_popover/appflowy_popover.dart';
import 'package:flowy_infra/colorscheme/default_colorscheme.dart';
import 'package:flutter/material.dart';

export 'package:appflowy_popover/appflowy_popover.dart';

class ShadowConstants {
  ShadowConstants._();

  static const List<BoxShadow> lightSmall = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 20, color: Color(0x1A1F2329)),
  ];
  static const List<BoxShadow> lightMedium = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 32, color: Color(0x121F2225)),
  ];
  static const List<BoxShadow> darkSmall = [
    BoxShadow(offset: Offset(0, 2), blurRadius: 16, color: Color(0x7A000000)),
  ];
  static const List<BoxShadow> darkMedium = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 32, color: Color(0x7A000000)),
  ];
}

class AppFlowyPopover extends StatelessWidget {
  const AppFlowyPopover({
    super.key,
    required this.child,
    required this.popupBuilder,
    this.direction = PopoverDirection.rightWithTopAligned,
    this.onOpen,
    this.onClose,
    this.canClose,
    this.constraints = const BoxConstraints(maxWidth: 240, maxHeight: 600),
    this.mutex,
    this.triggerActions = PopoverTriggerFlags.click,
    this.offset,
    this.controller,
    this.asBarrier = false,
    this.margin = const EdgeInsets.all(6),
    this.windowPadding = const EdgeInsets.all(8.0),
    this.clickHandler = PopoverClickHandler.listener,
    this.skipTraversal = false,
    this.decorationColor,
    this.borderRadius,
    this.popoverDecoration,
    this.animationDuration = const Duration(),
    this.slideDistance = 5.0,
    this.beginScaleFactor = 0.9,
    this.endScaleFactor = 1.0,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
    this.showAtCursor = false,
  });

  final Widget child;
  final PopoverController? controller;
  final Widget Function(BuildContext context) popupBuilder;
  final PopoverDirection direction;
  final int triggerActions;
  final BoxConstraints constraints;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final Future<bool> Function()? canClose;
  final PopoverMutex? mutex;
  final Offset? offset;
  final bool asBarrier;
  final EdgeInsets margin;
  final EdgeInsets windowPadding;
  final Color? decorationColor;
  final BorderRadius? borderRadius;
  final Duration animationDuration;
  final double slideDistance;
  final double beginScaleFactor;
  final double endScaleFactor;
  final double beginOpacity;
  final double endOpacity;
  final Decoration? popoverDecoration;

  /// The widget that will be used to trigger the popover.
  ///
  /// Why do we need this?
  /// Because if the parent widget of the popover is GestureDetector,
  ///  the conflict won't be resolve by using Listener, we want these two gestures exclusive.
  final PopoverClickHandler clickHandler;

  /// If true the popover will not participate in focus traversal.
  ///
  final bool skipTraversal;

  /// Whether the popover should be shown at the cursor position.
  /// If true, the [offset] will be ignored.
  ///
  /// This only works when using [PopoverClickHandler.listener] as the click handler.
  ///
  /// Alternatively for having a normal popover, and use the cursor position only on
  /// secondary click, consider showing the popover programatically with [PopoverController.showAt].
  ///
  final bool showAtCursor;

  @override
  Widget build(BuildContext context) {
    return Popover(
      controller: controller,
      animationDuration: animationDuration,
      slideDistance: slideDistance,
      beginScaleFactor: beginScaleFactor,
      endScaleFactor: endScaleFactor,
      beginOpacity: beginOpacity,
      endOpacity: endOpacity,
      onOpen: onOpen,
      onClose: onClose,
      canClose: canClose,
      direction: direction,
      mutex: mutex,
      asBarrier: asBarrier,
      triggerActions: triggerActions,
      windowPadding: windowPadding,
      offset: offset,
      clickHandler: clickHandler,
      skipTraversal: skipTraversal,
      popupBuilder: (context) => _PopoverContainer(
        constraints: constraints,
        margin: margin,
        decoration: popoverDecoration,
        decorationColor: decorationColor,
        borderRadius: borderRadius,
        child: popupBuilder(context),
      ),
      showAtCursor: showAtCursor,
      child: child,
    );
  }
}

class _PopoverContainer extends StatelessWidget {
  const _PopoverContainer({
    this.decorationColor,
    this.borderRadius,
    this.decoration,
    required this.child,
    required this.margin,
    required this.constraints,
  });

  final Widget child;
  final BoxConstraints constraints;
  final EdgeInsets margin;
  final Color? decorationColor;
  final BorderRadius? borderRadius;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: margin,
        decoration: decoration ??
            context.getPopoverDecoration(
              color: decorationColor,
              borderRadius: borderRadius,
            ),
        constraints: constraints,
        child: child,
      ),
    );
  }
}

extension PopoverDecoration on BuildContext {
  /// The decoration of the popover.
  ///
  /// Don't customize the entire decoration of the popover,
  ///   use the built-in popoverDecoration instead and ask the designer before changing it.
  ShapeDecoration getPopoverDecoration({
    Color? color,
    BorderRadius? borderRadius,
  }) {
    final borderColor = Theme.of(this).brightness == Brightness.light
        ? ColorSchemeConstants.lightBorderColor
        : ColorSchemeConstants.darkBorderColor;
    final shadows = Theme.of(this).brightness == Brightness.light
        ? ShadowConstants.lightSmall
        : ShadowConstants.darkSmall;
    return ShapeDecoration(
      color: color ?? Theme.of(this).cardColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: color != Colors.transparent ? borderColor : color!,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(10),
      ),
      shadows: shadows,
    );
  }
}
