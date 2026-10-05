import 'dart:async';
import 'package:flutter/material.dart';
import 'capture_mode_selector.dart';

class ShutterControlBar extends StatefulWidget {
  final CaptureMode mode;
  final VoidCallback onTakePhoto;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onGalleryTap;
  final VoidCallback onFlipCameraTap;
  final int maxDurationSeconds;

  const ShutterControlBar({
    super.key,
    required this.mode,
    required this.onTakePhoto,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onGalleryTap,
    required this.onFlipCameraTap,
    this.maxDurationSeconds = 30,
  });

  @override
  State<ShutterControlBar> createState() => _ShutterControlBarState();
}

class _ShutterControlBarState extends State<ShutterControlBar> {
  Timer? _timer;
  late int _remaining;
  bool _recording = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.maxDurationSeconds;
  }

  @override
  void didUpdateWidget(covariant ShutterControlBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxDurationSeconds != widget.maxDurationSeconds &&
        !_recording) {
      _remaining = widget.maxDurationSeconds;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    if (_recording) {
      _stop();
      return;
    }
    setState(() {
      _recording = true;
      _remaining = widget.maxDurationSeconds;
    });
    widget.onStartRecording();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining <= 1) {
        _stop();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    final shouldNotify = _recording;
    if (mounted) {
      setState(() {
        _recording = false;
        _remaining = widget.maxDurationSeconds;
      });
    }
    if (shouldNotify) widget.onStopRecording();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_recording) _buildTimer(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sideButton(
                const Key('gallery_button'),
                Icons.photo_library_outlined,
                'Buka galeri foto dan video',
                _recording ? null : widget.onGalleryTap,
              ),
              Semantics(
                container: true,
                button: true,
                label: widget.mode == CaptureMode.video
                    ? (_recording
                          ? 'Hentikan rekaman video'
                          : 'Mulai rekaman video')
                    : 'Ambil foto makanan',
                child: GestureDetector(
                  key: const Key('shutter_button'),
                  onTap: widget.mode == CaptureMode.video
                      ? _start
                      : widget.onTakePhoto,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: widget.mode == CaptureMode.video
                          ? const Color(0xFFDC2626)
                          : Colors.white,
                      shape: _recording ? BoxShape.rectangle : BoxShape.circle,
                      borderRadius: _recording
                          ? BorderRadius.circular(10)
                          : null,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: _recording
                        ? const Icon(
                            Icons.stop_rounded,
                            color: Colors.white,
                            size: 34,
                          )
                        : null,
                  ),
                ),
              ),
              _sideButton(
                const Key('flip_camera_button'),
                Icons.flip_camera_ios_outlined,
                'Ganti kamera depan atau belakang',
                _recording ? null : widget.onFlipCameraTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimer() => Container(
    key: const Key('video_timer_badge'),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFDC2626).withValues(alpha: .9),
      borderRadius: BorderRadius.circular(9999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.fiber_manual_record, size: 10, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          '00:${_remaining.toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    ),
  );

  Widget _sideButton(
    Key key,
    IconData icon,
    String label,
    VoidCallback? onTap,
  ) => Semantics(
    button: true,
    enabled: onTap != null,
    label: label,
    child: InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          icon,
          color: onTap == null ? Colors.white38 : Colors.white,
          size: 24,
        ),
      ),
    ),
  );
}
