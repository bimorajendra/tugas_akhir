import 'package:flutter/material.dart';

class PermissionDeniedScreen extends StatelessWidget {
  final VoidCallback? onOpenSettings;
  final VoidCallback? onPickFromGallery;

  const PermissionDeniedScreen({
    super.key,
    this.onOpenSettings,
    this.onPickFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Izin Kamera Diperlukan'),
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.no_photography_outlined,
                  size: 44,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Kamera belum tersedia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Aktifkan akses kamera dan mikrofon dari Pengaturan agar kamu bisa memotret atau merekam makanan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onOpenSettings,
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Buka Pengaturan'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onPickFromGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Pilih dari Galeri'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
