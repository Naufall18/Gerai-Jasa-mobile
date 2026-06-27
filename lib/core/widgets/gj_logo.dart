import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// Gerai Jasa brand mark — a storefront *awning* (gerai) with a service *bolt*
/// (jasa) on a rounded badge. Pure vector (CustomPainter), so it scales crisply
/// anywhere. Matches the SVG used on the web (`web/public/gerai-jasa-logo.svg`).
class GJLogo extends StatelessWidget {
  final double size;

  /// When true, draws a white rounded badge behind the mark (for dark/colored
  /// backgrounds like the splash). When false, only the mark is drawn.
  final bool withBadge;

  const GJLogo({super.key, this.size = 96, this.withBadge = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GJLogoPainter(withBadge: withBadge)),
    );
  }
}

class _GJLogoPainter extends CustomPainter {
  final bool withBadge;
  _GJLogoPainter({required this.withBadge});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    if (withBadge) {
      final badge = RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(w * 0.27),
      );
      canvas.drawRRect(badge, Paint()..color = Colors.white);
      canvas.save();
      canvas.clipRRect(badge);
    }

    // ── Awning (gerai) — green band with three scalloped bays. ──
    const left = 0.16, right = 0.84, top = 0.22, bottom = 0.40;
    final l = w * left, r = w * right, t = h * top, b = h * bottom;
    final scallopW = (r - l) / 3;

    final awning = Path()
      ..moveTo(l, t)
      ..lineTo(r, t)
      ..lineTo(r, b);
    for (var i = 0; i < 3; i++) {
      final endX = r - scallopW * (i + 1);
      awning.arcToPoint(
        Offset(endX, b),
        radius: Radius.circular(scallopW / 2),
        clockwise: false,
      );
    }
    awning
      ..lineTo(l, t)
      ..close();
    canvas.drawPath(awning, Paint()..color = GJColors.primary);

    // Small pole hints under the awning edges.
    final pole = Paint()
      ..color = GJColors.primary
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(l + w * 0.02, b), Offset(l + w * 0.02, h * 0.5), pole);
    canvas.drawLine(Offset(r - w * 0.02, b), Offset(r - w * 0.02, h * 0.5), pole);

    // ── Service bolt (jasa) — amber lightning centered below the awning. ──
    final bolt = Path()
      ..moveTo(w * 0.55, h * 0.44)
      ..lineTo(w * 0.37, h * 0.64)
      ..lineTo(w * 0.48, h * 0.64)
      ..lineTo(w * 0.45, h * 0.82)
      ..lineTo(w * 0.65, h * 0.58)
      ..lineTo(w * 0.52, h * 0.58)
      ..close();
    canvas.drawPath(bolt, Paint()..color = GJColors.accent);

    if (withBadge) canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GJLogoPainter oldDelegate) =>
      oldDelegate.withBadge != withBadge;
}
