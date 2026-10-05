import 'package:flutter/material.dart';

enum CaptureMode { photo, video }

class CaptureModeSelector extends StatelessWidget {
  final CaptureMode currentMode;
  final ValueChanged<CaptureMode> onModeChanged;

  const CaptureModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            label: 'Foto',
            mode: CaptureMode.photo,
            selected: currentMode == CaptureMode.photo,
            onTap: onModeChanged,
          ),
          _ModeButton(
            label: 'Video',
            mode: CaptureMode.video,
            selected: currentMode == CaptureMode.video,
            onTap: onModeChanged,
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final CaptureMode mode;
  final bool selected;
  final ValueChanged<CaptureMode> onTap;

  const _ModeButton({
    required this.label,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      selected: selected,
      child: InkWell(
        onTap: () => onTap(mode),
        borderRadius: BorderRadius.circular(9999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF047857) : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
