import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: AppColors.surface,
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _NavBarItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: 'Beranda',
                isSelected: currentIndex == 0,
                onTap: () => onTabSelected(0),
              ),
            ),
            const SizedBox(width: AppSpacing.xl * 2),
            Expanded(
              child: _NavBarItem(
                icon: Icons.history_rounded,
                activeIcon: Icons.history_toggle_off_rounded,
                label: 'Riwayat',
                isSelected: currentIndex == 1,
                onTap: () => onTabSelected(1),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profil',
                isSelected: currentIndex == 2,
                onTap: () => onTabSelected(2),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.accent : AppColors.mutedForeground;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.muted,
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: 44,
                height: 30,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withValues(alpha: 0.11)
                      : Colors.transparent,
                  borderRadius: AppRadius.roundedFull,
                ),
                child: AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey(isSelected),
                    color: color,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AnimatedDefaultTextStyle(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  height: 1,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
