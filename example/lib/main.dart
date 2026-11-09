import 'package:flutter/material.dart';
import 'package:adaptive_context_menu/adaptive_context_menu.dart';

void main() {
  runApp(const ContextMenuShowcaseApp());
}

/// Main showcase application for adaptive_context_menu.
class ContextMenuShowcaseApp extends StatelessWidget {
  /// Default constructor.
  const ContextMenuShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Context Menu Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      home: const ContextMenuHomeScreen(),
    );
  }
}

/// Home screen showing interactive context menu examples.
class ContextMenuHomeScreen extends StatelessWidget {
  /// Default constructor.
  const ContextMenuHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive Context Menu'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 28),
                const Text(
                  '1. Chat Message Bubble (Telegram / iOS Style)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: AdaptiveContextMenu(
                    actions: [
                      AdaptiveContextAction(
                        title: 'Reply',
                        icon: Icons.reply,
                        onPressed: () =>
                            _showSnackBar(context, 'Replying to message'),
                      ),
                      AdaptiveContextAction(
                        title: 'Copy Text',
                        icon: Icons.copy,
                        onPressed: () =>
                            _showSnackBar(context, 'Copied to clipboard'),
                      ),
                      AdaptiveContextAction(
                        title: 'Pin Message',
                        icon: Icons.push_pin_outlined,
                        onPressed: () =>
                            _showSnackBar(context, 'Pinned message'),
                      ),
                      const AdaptiveContextDivider(),
                      AdaptiveContextAction(
                        title: 'Delete Message',
                        icon: Icons.delete_outline,
                        isDestructive: true,
                        onPressed: () =>
                            _showSnackBar(context, 'Message deleted'),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        'Hey! Long-press this bubble to trigger the 3D pop context menu ✨',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  '2. Instagram / Photo Grid Tile',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),
                AdaptiveContextMenu(
                  actions: [
                    AdaptiveContextAction(
                      title: 'Like Post',
                      icon: Icons.favorite,
                      onPressed: () => _showSnackBar(context, 'Post liked!'),
                    ),
                    AdaptiveContextAction(
                      title: 'Share via...',
                      icon: Icons.share,
                      onPressed: () =>
                          _showSnackBar(context, 'Opening share sheet'),
                    ),
                    AdaptiveContextAction(
                      title: 'Save to Collection',
                      icon: Icons.bookmark_border,
                      onPressed: () =>
                          _showSnackBar(context, 'Saved to bookmarks'),
                    ),
                  ],
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image_outlined,
                              size: 48, color: Color(0xFF64748B)),
                          SizedBox(height: 8),
                          Text(
                            'Hold or Right-Click to Preview',
                            style: TextStyle(
                                color: Color(0xFF94A3B8), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adaptive Context Menu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pop-out preview with live backdrop blur. Smart edge bounds protect against off-screen clipping. Auto-switches between iOS frosted glass and Material 3 surfaces.',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
