# adaptive_context_menu

[![Pub Version](https://img.shields.io/pub/v/adaptive_context_menu)](https://pub.dev/packages/adaptive_context_menu)
[![Pub Points](https://img.shields.io/pub/points/adaptive_context_menu)](https://pub.dev/packages/adaptive_context_menu/score)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Donate-orange.svg)](https://buymeacoffee.com/govindtanko)
[![GitHub Sponsors](https://img.shields.io/badge/GitHub-Sponsor-ff69b4.svg)](https://github.com/sponsors/govindtank)

An adaptive context menu for Flutter featuring a Telegram / iOS 18 style 3D pop preview, real-time Gaussian backdrop blur, intelligent screen-edge collision protection, and platform-adaptive Cupertino & Material 3 styling.

---

## ✨ Features

- **🔍 3D Pop Preview Elevation:** Long-press lifts the target widget smoothly toward the user with spring physics while blurring the background.
- **🛡️ Collision-Safe Positioning Engine:** Automatically measures screen boundaries (`MediaQuery.sizeOf`). If tapped near the screen bottom or edges, the menu flips upward or shifts inward so menu items are never clipped off-screen.
- **🍏 Adaptive Design:** Renders authentic iOS/macOS frosted-glass blur cards on Apple devices and clean Material 3 tonal elevation with ripple feedback on Android and web.
- **🖱️ Web & Desktop First:** Native secondary click (right-click) support on desktop and browser, combined with smooth mobile long-press gestures.
- **📳 Haptic Detents:** Tactile haptic feedback on menu open and option selection.
- **📦 Zero External Dependencies:** Pure Flutter widget layer.

---

## 🚀 Getting Started

Add `adaptive_context_menu` to your `pubspec.yaml`:

```yaml
dependencies:
  adaptive_context_menu: ^1.0.0
```

Import the package:

```dart
import 'package:adaptive_context_menu/adaptive_context_menu.dart';
```

---

## 💡 Usage

Wrap any widget with `AdaptiveContextMenu`:

```dart
AdaptiveContextMenu(
  actions: [
    AdaptiveContextAction(
      title: 'Reply',
      icon: Icons.reply,
      onPressed: () => handleReply(),
    ),
    AdaptiveContextAction(
      title: 'Copy Text',
      icon: Icons.copy,
      onPressed: () => handleCopy(),
    ),
    const AdaptiveContextDivider(),
    AdaptiveContextAction(
      title: 'Delete',
      icon: Icons.delete_outline,
      isDestructive: true,
      onPressed: () => handleDelete(),
    ),
  ],
  child: ChatBubbleWidget(),
)
```

---

## ⚙️ Configuration

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `child` | `Widget` | *required* | The widget that triggers the context menu. |
| `actions` | `List<AdaptiveContextMenuEntry>` | *required* | List of `AdaptiveContextAction` and `AdaptiveContextDivider`. |
| `previewBuilder` | `Widget Function(BuildContext, Widget)?` | `null` | Optional custom widget builder for the elevated preview. |
| `popScale` | `double` | `1.05` | Scale multiplier for the preview lift animation. |
| `blurSigma` | `double` | `12.0` | Gaussian backdrop blur intensity. |
| `backdropColor` | `Color` | `Color(0x66000000)` | Overlay tint color behind the popped widget. |
| `menuWidth` | `double` | `250.0` | Width of the contextual actions card. |
| `enableHaptics` | `bool` | `true` | Triggers subtle haptic feedback on open and item taps. |
| `enableLongPress` | `bool` | `true` | Enables mobile long-press trigger. |
| `enableSecondaryClick` | `bool` | `true` | Enables right-click trigger on desktop & web. |

---

## 🧪 Testing

Run package tests:

```bash
flutter test
```

---

## 📄 License

Licensed under the [Apache 2.0 License](LICENSE).
