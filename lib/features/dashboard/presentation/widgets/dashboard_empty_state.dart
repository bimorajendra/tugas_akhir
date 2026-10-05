import 'package:flutter/material.dart';

class DashboardEmptyState extends StatelessWidget {
  final VoidCallback? onRecordFood;

  const DashboardEmptyState({
    super.key,
    this.onRecordFood,
    VoidCallback? onRecordFoodLegacy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            key: const Key('ompreng_tray_illustration'),
            width: 130,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: CustomPaint(painter: OmprengTrayPainter()),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Belum ada makanan yang dicatat',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Foto atau rekam makanan pertamamu untuk mulai memantau asupan hari ini.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.5),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: onRecordFood,
            icon: const Icon(Icons.camera_alt_outlined, size: 20),
            label: const Text(
              'Catat Makanan',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF047857),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OmprengTrayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final divider = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(14, 12, size.width - 28, size.height - 24),
        const Radius.circular(8),
      ),
      border,
    );
    final innerWidth = size.width - 40;
    final innerHeight = size.height - 36;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 18, innerWidth * .48, innerHeight),
        const Radius.circular(4),
      ),
      divider,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          20 + innerWidth * .54,
          18,
          innerWidth * .46,
          (size.height - 40) * .46,
        ),
        const Radius.circular(4),
      ),
      divider,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          20 + innerWidth * .54,
          22 + (size.height - 40) * .48,
          innerWidth * .46,
          (size.height - 40) * .46,
        ),
        const Radius.circular(4),
      ),
      divider,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
