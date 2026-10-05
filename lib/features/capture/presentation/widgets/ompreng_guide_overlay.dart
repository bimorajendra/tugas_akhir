import 'package:flutter/material.dart';

class OmprengGuideOverlay extends StatelessWidget {
  const OmprengGuideOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16).withValues(alpha: .72),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.crop_free_rounded, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Posisikan ompreng agar semua makanan terlihat jelas',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: CustomPaint(
            painter: _OmprengGuidePainter(),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _OmprengGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final horizontal = size.width * .08;
    final vertical = size.height * .18;
    final tray = Rect.fromLTRB(
      horizontal,
      vertical,
      size.width - horizontal,
      size.height - vertical,
    );
    final guide = Paint()
      ..color = Colors.white.withValues(alpha: .72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final divider = Paint()
      ..color = Colors.white.withValues(alpha: .42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(
      RRect.fromRectAndRadius(tray, const Radius.circular(24)),
      guide,
    );
    final gap = 8.0;
    final innerWidth = tray.width - gap * 3;
    final main = Rect.fromLTWH(
      tray.left + gap,
      tray.top + gap,
      innerWidth * .52,
      tray.height - gap * 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(main, const Radius.circular(16)),
      divider,
    );
    final rightLeft = main.right + gap;
    final rightWidth = tray.right - gap - rightLeft;
    final subHeight = (tray.height - gap * 3) / 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rightLeft, tray.top + gap, rightWidth, subHeight),
        const Radius.circular(12),
      ),
      divider,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rightLeft,
          tray.top + gap * 2 + subHeight,
          rightWidth,
          subHeight,
        ),
        const Radius.circular(12),
      ),
      divider,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
