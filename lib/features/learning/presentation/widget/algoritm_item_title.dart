import 'package:flutter/material.dart';

import '../../domain/entities/learning_entity.dart';
import 'circle_icon.dart';

class AlgorithmLearningTile extends StatelessWidget {
  final LearningEntity item;
  const AlgorithmLearningTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.92, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        builder: (_, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.blueAccent.withValues(alpha: 0.18)
                    : Colors.blue.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // TITLE
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // ACTIONS
              Row(
                children: [
                  if (item.hasCode)
                    CircleIcon(icon: Icons.code, color: primary),
                  if (item.hasLink)
                    CircleIcon(icon: Icons.link, color: primary),
                  if (item.hasPlay)
                    CircleIcon(icon: Icons.play_arrow_rounded, color: primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final Widget child;
  const _AnimatedCard({required this.child});

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );

    _controller.addListener(() {
      setState(() {
        _scale = 1 - _controller.value;
      });
    });
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(scale: _scale, child: widget.child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
