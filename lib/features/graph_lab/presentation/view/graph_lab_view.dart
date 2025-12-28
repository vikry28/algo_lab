import 'package:algo_lab/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../provider/graph_provider.dart';
import '../widget/graph_visualizer.dart';
import '../widget/realtime_dashboard.dart';
import '../widget/system_log_panel.dart';
import '../widget/footer_controls.dart';
import '../widget/algorithm_selector.dart';
import '../widget/simulation_result_overlay.dart';
import '../widget/zoom_controls.dart';
import '../widget/grid_painter.dart';

class GraphLabView extends StatelessWidget {
  const GraphLabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          // Background Gradient
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
            child: Consumer<GraphProvider>(
              builder: (context, prov, _) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: GlassAppBar(
                            title: t.translate('lab_graph_title'),
                            autoBack: true,
                            isDark: isDark,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // 1. Realtime Dashboard (Handles its own 16.w margin)
                        RealtimeDashboard(
                          prov: prov,
                          glass: glass,
                          isDark: isDark,
                        ),

                        SizedBox(height: 10.h),

                        // 2. Interactive Topology Canvas (Maximizing height)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: glass.color,
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: glass.border,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child: Stack(
                                children: [
                                  // 1. Grid Background
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: GridPainter(isDark: isDark),
                                    ),
                                  ),

                                  // 2. Interactive Graph Viewer
                                  InteractiveViewer(
                                    transformationController:
                                        prov.transformationController,
                                    boundaryMargin: EdgeInsets.zero,
                                    constrained: false,
                                    minScale: 0.3,
                                    maxScale: 2.5,
                                    child: SizedBox(
                                      width: 1400.w,
                                      height: 1200.h,
                                      child: CustomPaint(
                                        painter: GraphPainter(
                                          nodes: prov.nodes,
                                          edges: prov.edges,
                                          activeNodeId:
                                              prov.currentStepIndex >= 0 &&
                                                  prov.currentStepIndex <
                                                      prov.steps.length
                                              ? prov
                                                    .steps[prov
                                                        .currentStepIndex]
                                                    .activeNodeId
                                              : null,
                                          packetPosition: prov.packetPosition,
                                          isPacketVisible: prov.isPacketVisible,
                                          backgroundPackets:
                                              prov.backgroundPackets,
                                          isDark: isDark,
                                          t: t,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Telemetry Badge (Inside Canvas)
                                  Positioned(
                                    left: 16.w,
                                    top: 16.h,
                                    child: _buildLiveTrafficBadge(t),
                                  ),

                                  // Zoom Controls (Inside Canvas)
                                  Positioned(
                                    right: 16.w,
                                    bottom: 16.h,
                                    child: ZoomControls(
                                      onZoomIn: () => prov.zoomIn(),
                                      onZoomOut: () => prov.zoomOut(),
                                      glass: glass,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // 3. System Log (Handles its own 16.w margin)
                        SystemLogPanel(prov: prov, glass: glass),

                        SizedBox(height: 10.h),

                        // 4. Algorithm Selector (Handles its own 16.w margin)
                        AlgorithmSelector(
                          prov: prov,
                          glass: glass,
                          isDark: isDark,
                        ),

                        SizedBox(height: 10.h),

                        // 5. Main Controls (Handles its own 16.w padding)
                        FooterControls(prov: prov),

                        SizedBox(height: 10.h),
                      ],
                    ),
                    if (prov.isFinished) SimulationResultOverlay(prov: prov),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTrafficBadge(AppLocalizations t) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.flash_on_rounded,
            color: Colors.yellowAccent,
            size: 12,
          ),
          SizedBox(width: 4.w),
          Text(
            t.translate('graph_monitor_title'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
