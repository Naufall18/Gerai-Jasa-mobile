import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import '../services/push_notification_service.dart';

enum GJToastType { success, error, info, warning }

/// Animated toast that slides in from the TOP (not the default bottom SnackBar).
///
/// Usage from anywhere (no BuildContext needed — uses the root navigator overlay):
///   GJToast.show('Booking berhasil', type: GJToastType.success);
///
/// Features: slide+fade in from top, auto-dismiss, tap & swipe-up to dismiss,
/// stacked safely under the status bar, brand-token styling per type.
class GJToast {
  GJToast._();

  static OverlayEntry? _current;

  static void show(
    String message, {
    String? title,
    GJToastType type = GJToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    // Replace any visible toast so they never stack/overlap.
    _current?.remove();
    _current = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _GJToastWidget(
        title: title,
        message: message,
        type: type,
        duration: duration,
        onDismissed: () {
          if (_current == entry) _current = null;
          entry.remove();
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }

  static void success(String message, {String? title}) =>
      show(message, title: title, type: GJToastType.success);
  static void error(String message, {String? title}) =>
      show(message, title: title, type: GJToastType.error);
  static void info(String message, {String? title}) =>
      show(message, title: title, type: GJToastType.info);
  static void warning(String message, {String? title}) =>
      show(message, title: title, type: GJToastType.warning);
}

class _GJToastWidget extends StatefulWidget {
  final String? title;
  final String message;
  final GJToastType type;
  final Duration duration;
  final VoidCallback onDismissed;

  const _GJToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
    this.title,
  });

  @override
  State<_GJToastWidget> createState() => _GJToastWidgetState();
}

class _GJToastWidgetState extends State<_GJToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    ));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissing || !mounted) return;
    _dismissing = true;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ({Color bg, Color fg, IconData icon}) get _style {
    switch (widget.type) {
      case GJToastType.success:
        return (bg: GJColors.success, fg: Colors.white, icon: Icons.check_circle_rounded);
      case GJToastType.error:
        return (bg: GJColors.danger, fg: Colors.white, icon: Icons.error_rounded);
      case GJToastType.warning:
        return (bg: GJColors.warning, fg: Colors.white, icon: Icons.warning_amber_rounded);
      case GJToastType.info:
        return (bg: GJColors.primary, fg: Colors.white, icon: Icons.notifications_active_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    final topInset = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topInset + 8,
      left: GJSpacing.lg,
      right: GJSpacing.lg,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: Dismissible(
              key: const ValueKey('gj_toast'),
              direction: DismissDirection.up,
              onDismissed: (_) => widget.onDismissed(),
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: GJSpacing.lg, vertical: GJSpacing.md),
                  decoration: BoxDecoration(
                    color: s.bg,
                    borderRadius: BorderRadius.circular(GJRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: s.bg.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(s.icon, color: s.fg, size: 22),
                      ),
                      const SizedBox(width: GJSpacing.md),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.title != null) ...[
                              Text(
                                widget.title!,
                                style: TextStyle(
                                  color: s.fg,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                            Text(
                              widget.message,
                              style: TextStyle(
                                color: s.fg.withValues(alpha: 0.95),
                                fontSize: 13.5,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
