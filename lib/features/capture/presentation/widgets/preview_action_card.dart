import 'package:flutter/material.dart';

class PreviewActionCard extends StatelessWidget {
  final bool isAnalyzing;
  final VoidCallback onAnalyze;
  final VoidCallback onRetake;

  const PreviewActionCard({
    super.key,
    required this.isAnalyzing,
    required this.onAnalyze,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Siap dianalisis?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pastikan seluruh makanan dalam ompreng terlihat jelas.',
              style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isAnalyzing ? null : onAnalyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  foregroundColor: Colors.white,
                ),
                child: isAnalyzing
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Analisis Makanan'),
                        ],
                      )
                    : const Text('Analisis Makanan'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: isAnalyzing ? null : onRetake,
                child: const Text('Ambil Ulang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
