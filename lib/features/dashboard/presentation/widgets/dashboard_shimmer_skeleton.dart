import 'package:flutter/material.dart';

class DashboardShimmerSkeleton extends StatefulWidget {
  const DashboardShimmerSkeleton({super.key});

  @override
  State<DashboardShimmerSkeleton> createState() =>
      _DashboardShimmerSkeletonState();
}

class _DashboardShimmerSkeletonState extends State<DashboardShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(
      begin: .35,
      end: .75,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) =>
          Opacity(opacity: _opacityAnimation.value, child: child),
      child: Column(
        key: const Key('dashboard_shimmer_container'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            key: const Key('shimmer_energy_card'),
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            key: const Key('shimmer_macro_row'),
            children: List.generate(
              3,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
                  child: Container(
                    height: 84,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(width: 140, height: 20, color: const Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
