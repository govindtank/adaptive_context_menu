import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'adaptive_context_action.dart';

/// A cross-platform adaptive context menu widget.
///
/// Wraps any [child] widget. On long press (mobile) or secondary click (desktop/web),
/// it elevates the target into a 3D pop preview with real-time backdrop blur,
/// intelligently placing the action sheet to prevent off-screen clipping.
class AdaptiveContextMenu extends StatefulWidget {
  /// Creates an adaptive context menu wrapper.
  const AdaptiveContextMenu({
    super.key,
    required this.child,
    required this.actions,
    this.previewBuilder,
    this.popScale = 1.05,
    this.blurSigma = 12.0,
    this.backdropColor = const Color(0x66000000),
    this.menuWidth = 250.0,
    this.enableHaptics = true,
    this.enableLongPress = true,
    this.enableSecondaryClick = true,
  }) : assert(popScale >= 1.0, 'popScale must be at least 1.0');

  /// The child widget that triggers the context menu.
  final Widget child;

  /// The list of actions or dividers displayed in the context menu.
  final List<AdaptiveContextMenuEntry> actions;

  /// Optional custom builder for the popped preview widget.
  /// If null, the [child] is rendered with an elevated scale animation.
  final Widget Function(BuildContext context, Widget child)? previewBuilder;

  /// Scale factor applied to the child during preview lift. Defaults to 1.05.
  final double popScale;

  /// Amount of Gaussian backdrop blur applied behind the menu. Defaults to 12.0.
  final double blurSigma;

  /// Background color tint applied over the blurred backdrop.
  final Color backdropColor;

  /// Width of the popped action menu card. Defaults to 250.0.
  final double menuWidth;

  /// Whether to trigger subtle haptic vibrations on open and selection.
  final bool enableHaptics;

  /// Whether long-press opens the menu (mobile standard). Defaults to true.
  final bool enableLongPress;

  /// Whether secondary tap / right click opens the menu (desktop/web standard). Defaults to true.
  final bool enableSecondaryClick;

  @override
  State<AdaptiveContextMenu> createState() => _AdaptiveContextMenuState();
}

class _AdaptiveContextMenuState extends State<AdaptiveContextMenu> {
  final GlobalKey _childKey = GlobalKey();

  void _showMenu(Offset tapPosition) {
    if (widget.actions.isEmpty) return;

    if (widget.enableHaptics) {
      HapticFeedback.mediumImpact();
    }

    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final targetRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    Navigator.of(context).push(
      _AdaptiveContextMenuRoute(
        targetRect: targetRect,
        childWidget: widget.previewBuilder != null
            ? widget.previewBuilder!(context, widget.child)
            : widget.child,
        actions: widget.actions,
        popScale: widget.popScale,
        blurSigma: widget.blurSigma,
        backdropColor: widget.backdropColor,
        menuWidth: widget.menuWidth,
        enableHaptics: widget.enableHaptics,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _childKey,
      behavior: HitTestBehavior.opaque,
      onLongPress: widget.enableLongPress
          ? () {
              final box =
                  _childKey.currentContext?.findRenderObject() as RenderBox?;
              final offset =
                  box != null ? box.localToGlobal(Offset.zero) : Offset.zero;
              _showMenu(offset);
            }
          : null,
      onSecondaryTapUp: widget.enableSecondaryClick
          ? (details) => _showMenu(details.globalPosition)
          : null,
      child: widget.child,
    );
  }
}

class _AdaptiveContextMenuRoute<T> extends PopupRoute<T> {
  _AdaptiveContextMenuRoute({
    required this.targetRect,
    required this.childWidget,
    required this.actions,
    required this.popScale,
    required this.blurSigma,
    required this.backdropColor,
    required this.menuWidth,
    required this.enableHaptics,
  });

  final Rect targetRect;
  final Widget childWidget;
  final List<AdaptiveContextMenuEntry> actions;
  final double popScale;
  final double blurSigma;
  final Color backdropColor;
  final double menuWidth;
  final bool enableHaptics;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss Context Menu';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _AdaptiveContextMenuOverlay(
      animation: animation,
      targetRect: targetRect,
      childWidget: childWidget,
      actions: actions,
      popScale: popScale,
      blurSigma: blurSigma,
      backdropColor: backdropColor,
      menuWidth: menuWidth,
      enableHaptics: enableHaptics,
    );
  }
}

class _AdaptiveContextMenuOverlay extends StatelessWidget {
  const _AdaptiveContextMenuOverlay({
    required this.animation,
    required this.targetRect,
    required this.childWidget,
    required this.actions,
    required this.popScale,
    required this.blurSigma,
    required this.backdropColor,
    required this.menuWidth,
    required this.enableHaptics,
  });

  final Animation<double> animation;
  final Rect targetRect;
  final Widget childWidget;
  final List<AdaptiveContextMenuEntry> actions;
  final double popScale;
  final double blurSigma;
  final Color backdropColor;
  final double menuWidth;
  final bool enableHaptics;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isIos = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    // Smart collision logic: decide if menu goes above or below target
    final spaceBelow = screenSize.height - targetRect.bottom;
    final spaceAbove = targetRect.top;
    final placeBelow = spaceBelow >= 260 || spaceBelow >= spaceAbove;

    // Horizontal placement with screen edge padding
    const horizontalMargin = 16.0;
    double left = targetRect.left;
    if (left + menuWidth > screenSize.width - horizontalMargin) {
      left = screenSize.width - menuWidth - horizontalMargin;
    }
    if (left < horizontalMargin) {
      left = horizontalMargin;
    }

    final curvedAnim = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Blurred backdrop with tap-to-dismiss
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigma * animation.value,
                      sigmaY: blurSigma * animation.value,
                    ),
                    child: Container(
                      color: backdropColor.withValues(
                        alpha: backdropColor.a * animation.value,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Popped child preview widget
          Positioned(
            left: targetRect.left,
            top: targetRect.top,
            width: targetRect.width,
            height: targetRect.height,
            child: ScaleTransition(
              scale:
                  Tween<double>(begin: 1.0, end: popScale).animate(curvedAnim),
              child: IgnorePointer(
                child: childWidget,
              ),
            ),
          ),

          // Positioned Context Menu Actions Card
          Positioned(
            left: left,
            top: placeBelow ? targetRect.bottom + 12.0 : null,
            bottom:
                placeBelow ? null : (screenSize.height - targetRect.top) + 12.0,
            width: menuWidth,
            child: ScaleTransition(
              alignment:
                  placeBelow ? Alignment.topCenter : Alignment.bottomCenter,
              scale: curvedAnim,
              child: FadeTransition(
                opacity: animation,
                child: isIos
                    ? _buildCupertinoMenu(context)
                    : _buildMaterialMenu(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupertinoMenu(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemGroupedBackground
                .resolveFrom(context)
                .withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: CupertinoColors.separator.resolveFrom(context),
              width: 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: actions
                .map((entry) => _buildEntry(context, entry, true))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialMenu(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 6,
      shadowColor: Colors.black45,
      surfaceTintColor: theme.colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            actions.map((entry) => _buildEntry(context, entry, false)).toList(),
      ),
    );
  }

  Widget _buildEntry(
    BuildContext context,
    AdaptiveContextMenuEntry entry,
    bool isCupertino,
  ) {
    if (entry is AdaptiveContextDivider) {
      return Divider(
        height: entry.height,
        thickness: entry.height,
        color: entry.color ??
            (isCupertino
                ? CupertinoColors.separator.resolveFrom(context)
                : Theme.of(context).dividerColor),
      );
    }

    if (entry is AdaptiveContextAction) {
      final color = entry.isDestructive
          ? (isCupertino
              ? CupertinoColors.destructiveRed
              : Theme.of(context).colorScheme.error)
          : (isCupertino
              ? CupertinoColors.label.resolveFrom(context)
              : Theme.of(context).colorScheme.onSurface);

      return InkWell(
        onTap: entry.enabled
            ? () {
                if (enableHaptics) HapticFeedback.selectionClick();
                Navigator.of(context).pop();
                entry.onPressed?.call();
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (entry.icon != null) ...[
                Icon(entry.icon, size: 20, color: color),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                    if (entry.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        entry.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: color.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (entry.trailing != null) entry.trailing!,
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
