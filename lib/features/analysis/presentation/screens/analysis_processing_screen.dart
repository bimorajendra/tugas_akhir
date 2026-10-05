import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/staged_analysis_indicator.dart';

class AnalysisProcessingScreen extends StatefulWidget {
  final String mediaPath;
  final bool isVideo;
  final bool simulateProgress;
  final AnalysisStage initialStage;
  final VoidCallback? onAnalysisCompleted;
  const AnalysisProcessingScreen({
    super.key,
    required this.mediaPath,
    required this.isVideo,
    this.simulateProgress = true,
    this.initialStage = AnalysisStage.uploading,
    this.onAnalysisCompleted,
  });

  @override
  State<AnalysisProcessingScreen> createState() =>
      _AnalysisProcessingScreenState();
}

class _AnalysisProcessingScreenState extends State<AnalysisProcessingScreen> {
  late AnalysisStage _stage;
  bool _longWait = false;
  Timer? _timer;
  Timer? _waitTimer;

  @override
  void initState() {
    super.initState();
    _stage = widget.initialStage;
    if (widget.simulateProgress) _simulate();
  }

  void _simulate() {
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _stage = AnalysisStage.detecting);
      _timer = Timer(const Duration(milliseconds: 2200), () {
        if (!mounted) return;
        setState(() => _stage = AnalysisStage.calculating);
        _timer = Timer(
          const Duration(milliseconds: 5000),
          widget.onAnalysisCompleted ?? () {},
        );
      });
    });
    _waitTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) setState(() => _longWait = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waitTimer?.cancel();
    super.dispose();
  }

  Future<bool> _confirmCancel() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Batalkan Analisis?'),
          content: const Text(
            'Proses analisis makanan yang sedang berlangsung akan dihentikan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Lanjutkan Analisis'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Batalkan'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && await _confirmCancel() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Menganalisis Makananmu'),
          centerTitle: true,
          leading: IconButton(
            key: const Key('analysis_close_button'),
            tooltip: 'Batalkan Analisis',
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              if (await _confirmCancel() && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: StagedAnalysisIndicator(
                stage: _stage,
                isLongWait: _longWait,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
