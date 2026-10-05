import 'package:flutter/material.dart';
import '../widgets/capture_mode_selector.dart';
import '../widgets/ompreng_guide_overlay.dart';
import '../widgets/shutter_control_bar.dart';

class CameraCaptureScreen extends StatefulWidget {
  final VoidCallback? onClose;
  const CameraCaptureScreen({super.key, this.onClose});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CaptureMode _mode = CaptureMode.photo;
  bool _flashOn = false;

  void _openPreview() => Navigator.of(context).pushNamed('/capture/preview');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Color(0xFF0F172A))),
            const Positioned.fill(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: OmprengGuideOverlay(),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      button: true,
                      label: 'Tutup kamera',
                      child: IconButton(
                        tooltip: 'Tutup kamera',
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed:
                            widget.onClose ??
                            () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: 'Pengaturan lampu kilat',
                      child: IconButton(
                        tooltip: 'Pengaturan lampu kilat',
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        icon: Icon(
                          _flashOn ? Icons.flash_on : Icons.flash_off,
                          color: _flashOn
                              ? const Color(0xFFFBBF24)
                              : Colors.white,
                          size: 26,
                        ),
                        onPressed: () => setState(() => _flashOn = !_flashOn),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 12),
                color: Colors.black.withValues(alpha: .55),
                child: Column(
                  children: [
                    CaptureModeSelector(
                      currentMode: _mode,
                      onModeChanged: (mode) => setState(() => _mode = mode),
                    ),
                    const SizedBox(height: 12),
                    ShutterControlBar(
                      mode: _mode,
                      onTakePhoto: _openPreview,
                      onStartRecording: () {},
                      onStopRecording: _openPreview,
                      onGalleryTap: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Membuka galeri media...'),
                            ),
                          ),
                      onFlipCameraTap: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Beralih kamera...')),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
