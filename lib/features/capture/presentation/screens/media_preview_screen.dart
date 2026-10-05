import 'package:flutter/material.dart';
import '../widgets/preview_action_card.dart';

class MediaPreviewScreen extends StatefulWidget {
  final String mediaPath;
  final bool isVideo;
  final VoidCallback onRetake;
  final ValueChanged<String> onConfirmAnalysis;

  const MediaPreviewScreen({
    super.key,
    required this.mediaPath,
    this.isVideo = false,
    required this.onRetake,
    required this.onConfirmAnalysis,
  });

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  bool _isAnalyzing = false;

  void _analyze() {
    if (_isAnalyzing) return;
    setState(() => _isAnalyzing = true);
    widget.onConfirmAnalysis(widget.mediaPath);
  }

  @override
  Widget build(BuildContext context) {
    final hasNetworkPreview =
        !widget.isVideo &&
        (widget.mediaPath.startsWith('http://') ||
            widget.mediaPath.startsWith('https://'));
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 230,
            child: hasNetworkPreview
                ? Image.network(widget.mediaPath, fit: BoxFit.contain)
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isVideo
                              ? Icons.videocam_outlined
                              : Icons.image_outlined,
                          size: 64,
                          color: const Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.isVideo
                              ? 'Pratinjau Video Ompreng'
                              : 'Pratinjau Foto Ompreng',
                          style: const TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Kembali ke kamera',
                      onPressed: _isAnalyzing ? null : widget.onRetake,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.isVideo ? 'Mode Video' : 'Mode Foto',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PreviewActionCard(
              isAnalyzing: _isAnalyzing,
              onAnalyze: _analyze,
              onRetake: widget.onRetake,
            ),
          ),
        ],
      ),
    );
  }
}
