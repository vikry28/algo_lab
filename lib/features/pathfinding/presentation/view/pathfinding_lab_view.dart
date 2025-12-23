import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../provider/pathfinding_provider.dart';
import '../../domain/entities/grid_node.dart';
import '../../domain/usecases/astar_usecase.dart';

class PathfindingLabView extends StatelessWidget {
  const PathfindingLabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final t = AppLocalizations.of(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Consumer<PathfindingProvider>(
              builder: (context, prov, _) {
                final textColor = isDark ? Colors.white : Colors.black87;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      GlassAppBar(
                        title: t.translate('lab_pathfinding_title'),
                        autoBack: true,
                        isDark: isDark,
                      ),

                      SizedBox(height: 12.h),

                      // Metrics Panel
                      _buildMetricsPanel(prov, textColor, glass),

                      SizedBox(height: 12.h),

                      // Tool Toolbar
                      _buildToolbar(prov, glass, isDark),

                      SizedBox(height: 12.h),

                      // Grid Visualizer
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: glass.color,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(color: glass.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: _buildGrid(prov),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Bottom Settings
                      _buildSettingsPanel(prov, textColor, glass, isDark),

                      SizedBox(height: 12.h),

                      // Controls
                      _buildControls(context, prov, t, glass, textColor),

                      SizedBox(height: 16.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsPanel(
    PathfindingProvider prov,
    Color textColor,
    GlassTheme glass,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: glass.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _metricItem(
            "Nodes",
            prov.nodesVisited.toString(),
            Icons.analytics,
            Colors.blueAccent,
          ),
          _metricItem(
            "Cost",
            prov.totalPathCost.toStringAsFixed(1),
            Icons.currency_bitcoin_rounded,
            Colors.orangeAccent,
          ),
          _metricItem(
            "Time",
            "${prov.stopwatch.elapsed.inMilliseconds}ms",
            Icons.timer_outlined,
            Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  Widget _metricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 10.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(
    PathfindingProvider prov,
    GlassTheme glass,
    bool isDark,
  ) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: glass.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _toolItem(
            BrushMode.start,
            Icons.home_rounded,
            Colors.greenAccent,
            prov,
          ),
          _toolItem(
            BrushMode.end,
            Icons.location_on_rounded,
            Colors.redAccent,
            prov,
          ),
          _toolItem(
            BrushMode.wall,
            Icons.block_rounded,
            Colors.grey[600]!,
            prov,
          ),
          _toolItem(
            BrushMode.weight,
            Icons.traffic_rounded,
            Colors.orangeAccent,
            prov,
          ),
          _toolItem(
            BrushMode.erase,
            Icons.auto_fix_normal_rounded,
            Colors.blueAccent,
            prov,
          ),
        ],
      ),
    );
  }

  Widget _toolItem(
    BrushMode mode,
    IconData icon,
    Color color,
    PathfindingProvider prov,
  ) {
    final isSelected = prov.brushMode == mode;
    return GestureDetector(
      onTap: () => prov.setBrushMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: isSelected ? color : color.withValues(alpha: 0.5),
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildSettingsPanel(
    PathfindingProvider prov,
    Color textColor,
    GlassTheme glass,
    bool isDark,
  ) {
    return Row(
      children: [
        // Diagonal Toggle
        Expanded(
          child: GestureDetector(
            onTap: prov.toggleDiagonal,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: glass.color,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: prov.allowDiagonal
                      ? Colors.cyanAccent.withValues(alpha: 0.5)
                      : glass.border,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    prov.allowDiagonal
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: prov.allowDiagonal ? Colors.cyanAccent : Colors.grey,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Diagonal",
                    style: AppTypography.labelSmall.copyWith(
                      color: prov.allowDiagonal ? Colors.cyanAccent : textColor,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Heuristic Dropdown (Simplified as Toggle for now or popup)
        Expanded(
          child: PopupMenuButton<HeuristicType>(
            onSelected: prov.setHeuristic,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: HeuristicType.manhattan,
                child: Text("Manhattan"),
              ),
              const PopupMenuItem(
                value: HeuristicType.euclidean,
                child: Text("Euclidean"),
              ),
              const PopupMenuItem(
                value: HeuristicType.chebyshev,
                child: Text("Chebyshev"),
              ),
            ],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: glass.color,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: glass.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.psychology_rounded,
                    color: Colors.purpleAccent,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    prov.heuristic.name.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(fontSize: 11.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(PathfindingProvider prov) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = (constraints.maxWidth - (prov.cols - 1)) / prov.cols;
        return GestureDetector(
          onPanUpdate: (details) {
            final x = (details.localPosition.dy / cellSize).floor();
            final y = (details.localPosition.dx / cellSize).floor();
            if (x >= 0 && x < prov.rows && y >= 0 && y < prov.cols) {
              prov.handleTap(x, y);
            }
          },
          onTapDown: (details) {
            final x = (details.localPosition.dy / cellSize).floor();
            final y = (details.localPosition.dx / cellSize).floor();
            if (x >= 0 && x < prov.rows && y >= 0 && y < prov.cols) {
              prov.handleTap(x, y);
            }
          },
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: prov.cols,
              childAspectRatio: 1,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemCount: prov.rows * prov.cols,
            itemBuilder: (context, index) {
              final x = index ~/ prov.cols;
              final y = index % prov.cols;
              final node = prov.grid[x][y];
              final isDark = Provider.of<ThemeProvider>(context).isDark;
              return _buildNode(node, prov, isDark);
            },
          ),
        );
      },
    );
  }

  Widget _buildNode(GridNode node, PathfindingProvider prov, bool isDark) {
    Color color;
    IconData? icon;

    switch (node.type) {
      case NodeType.empty:
        color = isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05);
        break;
      case NodeType.wall:
        color = Colors.grey[800]!;
        icon = Icons.block_rounded;
        break;
      case NodeType.weight:
        color = Colors.orangeAccent.withValues(alpha: 0.3);
        icon = Icons.traffic_rounded;
        break;
      case NodeType.start:
        color = Colors.greenAccent;
        icon = Icons.home_rounded;
        break;
      case NodeType.end:
        color = Colors.redAccent;
        icon = Icons.location_on_rounded;
        break;
      case NodeType.visited:
        color = AppColors.primary.withValues(alpha: 0.3);
        break;
      case NodeType.searching:
        color = Colors.amberAccent.withValues(alpha: 0.5);
        break;
      case NodeType.path:
        color = Colors.cyanAccent;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          node.type == NodeType.wall ? 4.r : 2.r,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
        boxShadow:
            (node.type == NodeType.path ||
                node.type == NodeType.start ||
                node.type == NodeType.end)
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : (node.type == NodeType.wall
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ]
                  : null),
      ),
      transform: node.type == NodeType.wall
          ? Matrix4.translationValues(0, -2, 0)
          : Matrix4.identity(),
      child: Center(
        child: icon != null
            ? Icon(
                icon,
                size: 10.sp,
                color:
                    (node.type == NodeType.start || node.type == NodeType.end)
                    ? Colors.white
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.black.withValues(alpha: 0.8)),
              )
            : (node.g != double.infinity &&
                      node.type != NodeType.empty &&
                      node.type != NodeType.visited &&
                      node.type != NodeType.searching
                  ? Text(
                      node.f.toInt().toString(),
                      style: TextStyle(
                        fontSize: 6.sp,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    )
                  : null),
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    PathfindingProvider prov,
    AppLocalizations t,
    GlassTheme glass,
    Color textColor,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _controlButton(
            label: t.translate('lab_start_logistics'),
            icon: prov.isRunning
                ? Icons.hourglass_empty
                : Icons.play_arrow_rounded,
            color: prov.isRunning ? Colors.grey : Colors.greenAccent,
            onTap: prov.isRunning ? null : () => prov.startAStar(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _controlButton(
            label: "",
            icon: Icons.refresh_rounded,
            color: Colors.orangeAccent,
            onTap: () => prov.reset(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _controlButton(
            label: "",
            icon: Icons.layers_clear_rounded,
            color: Colors.pinkAccent,
            onTap: () => prov.clearObstacles(),
          ),
        ),
      ],
    );
  }

  Widget _controlButton({
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    // ignore: unused_element_parameter
    bool isFullWidth = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20.sp),
            if (label.isNotEmpty) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
