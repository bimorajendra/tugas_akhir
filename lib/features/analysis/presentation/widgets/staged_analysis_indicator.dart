import 'dart:math' as math;
import 'package:flutter/material.dart';

enum AnalysisStage { uploading, detecting, calculating }

class StagedAnalysisIndicator extends StatefulWidget {
  final AnalysisStage stage;
  final bool isLongWait;
  const StagedAnalysisIndicator({
    super.key,
    required this.stage,
    this.isLongWait = false,
  });

  @override
  State<StagedAnalysisIndicator> createState() =>
      _StagedAnalysisIndicatorState();
}

class _StagedAnalysisIndicatorState extends State<StagedAnalysisIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _title() => switch (widget.stage) {
    AnalysisStage.uploading => 'Mengunggah media…',
    AnalysisStage.detecting => 'Mengenali makanan…',
    AnalysisStage.calculating => 'Menghitung informasi gizi…',
  };
  String _subtitle() => switch (widget.stage) {
    AnalysisStage.uploading =>
      'Mengirimkan foto ompreng ke sistem analisis GiziLens.',
    AnalysisStage.detecting =>
      'Mendeteksi kompartemen ompreng dan jenis makanan.',
    AnalysisStage.calculating =>
      'Memperkirakan porsi, kalori, dan kecukupan zat gizi.',
  };
  int _index() => widget.stage.index;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF047857);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => CustomPaint(
              painter: _RadarPainter(_controller.value),
              child: Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accent.withValues(alpha: .25),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.lunch_dining_rounded,
                    size: 40,
                    color: accent,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Row(
              children: [
                Container(
                  width: index == _index() ? 28 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: index <= _index() ? accent : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                if (index < 2)
                  Container(
                    width: 18,
                    height: 2,
                    color: index < _index() ? accent : const Color(0xFFE2E8F0),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 250),
          child: Column(
            key: ValueKey(widget.stage),
            children: [
              Text(
                _title(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _subtitle(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        if (widget.isLongWait) ...[
          const SizedBox(height: 28),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD97706).withValues(alpha: .35),
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.hourglass_top_rounded,
                  color: Color(0xFFD97706),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proses ini sedikit lebih lama dari biasanya.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Koneksi sedang lambat atau kompartemen ompreng memerlukan pemindaian mendalam. Mohon tetap di layar ini.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB45309),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double value;
  _RadarPainter(this.value);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ring = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: .1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final radius in [45.0, 72.0, 98.0]) {
      canvas.drawCircle(center, radius, ring);
    }
    final pulse = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: (1 - value) * .28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, value * 98, pulse);
    final sweep = Paint()
      ..color = const Color(0xFF047857).withValues(alpha: .08)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 94),
      value * math.pi * 2,
      math.pi / 3,
      true,
      sweep,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.value != value;
}
