import 'package:flutter/material.dart';

/// Base class for all entries displayed in an [AdaptiveContextMenu].
abstract class AdaptiveContextMenuEntry {
  /// Default const constructor.
  const AdaptiveContextMenuEntry();
}

/// An actionable item displayed in an [AdaptiveContextMenu].
class AdaptiveContextAction extends AdaptiveContextMenuEntry {
  /// Creates an actionable item with title, optional icon, and callback.
  const AdaptiveContextAction({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.isDestructive = false,
    this.enabled = true,
    this.onPressed,
  });

  /// The primary label text.
  final String title;

  /// Optional secondary text displayed under the title.
  final String? subtitle;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional custom trailing widget.
  final Widget? trailing;

  /// Whether this action represents a destructive operation (rendered in red).
  final bool isDestructive;

  /// Whether this action is interactive.
  final bool enabled;

  /// Callback executed when the user taps this action.
  final VoidCallback? onPressed;
}

/// A visual separator line between menu actions.
class AdaptiveContextDivider extends AdaptiveContextMenuEntry {
  /// Creates a visual divider line.
  const AdaptiveContextDivider({this.height = 1.0, this.color});

  /// Height or thickness of the divider.
  final double height;

  /// Custom color of the divider.
  final Color? color;
}
