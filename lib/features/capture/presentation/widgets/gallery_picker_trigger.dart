import 'package:flutter/material.dart';
import '../../domain/validators/media_constraint_validator.dart';

class GalleryPickerTrigger extends StatelessWidget {
  final bool isVideoMode;
  final Future<({String name, int size})?> Function(bool isVideo)? pickMedia;
  final ValueChanged<String>? onMediaSelected;

  const GalleryPickerTrigger({
    super.key,
    this.isVideoMode = false,
    this.pickMedia,
    this.onMediaSelected,
  });

  Future<void> _pick(BuildContext context) async {
    final picked = await pickMedia?.call(isVideoMode);
    if (picked == null) return;
    final result = MediaConstraintValidator.validate(
      fileName: picked.name,
      fileSizeBytes: picked.size,
      isVideo: isVideoMode,
    );
    if (!context.mounted) return;
    if (!result.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Media tidak dapat digunakan.'),
        ),
      );
      return;
    }
    onMediaSelected?.call(picked.name);
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Buka galeri foto dan video',
    child: IconButton(
      key: const Key('gallery_picker_trigger'),
      tooltip: 'Buka galeri foto dan video',
      onPressed: () => _pick(context),
      icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
    ),
  );
}
