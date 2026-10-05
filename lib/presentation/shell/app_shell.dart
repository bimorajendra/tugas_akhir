import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/presentation/shell/widgets/bottom_nav_bar.dart';
import 'package:gizilens/presentation/shell/widgets/floating_capture_button.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;
  final VoidCallback? onCaptureTap;
  final List<Widget>? children;

  const AppShell({super.key, this.initialIndex = 0, this.onCaptureTap, this.children});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = widget.children ?? const [
      Center(key: Key('tab_beranda_default'), child: Text('Beranda Content')),
      Center(key: Key('tab_riwayat_default'), child: Text('Riwayat Content')),
      Center(key: Key('tab_profil_default'), child: Text('Profil Content')),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: FloatingCaptureButton(onTap: widget.onCaptureTap),
      ),
    );
  }
}
