import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../../domain/entities/algorithm_content_entity.dart';
import '../provider/universal_algorithm_provider.dart';
import '../../../home/presentation/widget/modern_confirm_dialog.dart';

class UniversalAlgorithmLearningView extends StatefulWidget {
  final String algorithmId;
  final String title;

  const UniversalAlgorithmLearningView({
    super.key,
    required this.algorithmId,
    required this.title,
  });

  @override
  State<UniversalAlgorithmLearningView> createState() =>
      _UniversalAlgorithmLearningViewState();
}

class _UniversalAlgorithmLearningViewState
    extends State<UniversalAlgorithmLearningView> {
  final Map<int, TextEditingController> _quizControllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UniversalAlgorithmProvider>(
        context,
        listen: false,
      );
      provider.loadContent(
        widget.algorithmId,
        AppLocalizations.of(context).locale.languageCode,
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _quizControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _tr(BuildContext context, String key) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    return localizations?.translate(key) ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final glassTheme = Theme.of(context).extension<GlassTheme>();
    final glass =
        glassTheme ??
        GlassTheme(
          blur: 10,
          saturation: 1.0,
          color: Colors.black.withValues(alpha: 0.1),
          border: Colors.white.withValues(alpha: 0.1),
          borderWidth: 1.0,
        );
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground[0]
          : AppColors.lightBackground[0],
      body: Stack(
        children: [
          // Background gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
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
          // Overall Glass Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
            child: Container(color: glass.color.withValues(alpha: 0.05)),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 5.h),
              child: Consumer<UniversalAlgorithmProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: isDark ? AppColors.primary : AppColors.primary,
                      ),
                    );
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.sp,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            '${_tr(context, "common_error_prefix")}${provider.error}',
                            style: AppTypography.body.copyWith(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final content = provider.content;

                  if (content == null) {
                    return Center(
                      child: Text(
                        _tr(context, "learning_content_unavailable"),
                        style: AppTypography.body,
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      // App Bar
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: 0,
                        floating: true,
                        pinned: false,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        flexibleSpace: GlassAppBar(
                          title: widget.title,
                          isDark: isDark,
                          autoBack: true,
                          actions: [
                            if (provider.isCompleted)
                              Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 24.sp,
                                ),
                              ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => ModernConfirmDialog(
                                    title: _tr(
                                      context,
                                      "learning_reset_progress_title",
                                    ),
                                    message: _tr(
                                      context,
                                      "learning_reset_progress_content",
                                    ),
                                    icon: Icons.refresh_rounded,
                                    confirmLabel: _tr(context, "common_reset"),
                                    cancelLabel: _tr(context, "common_cancel"),
                                    onConfirm: () => provider.resetProgress(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.refresh_rounded,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              tooltip: _tr(
                                context,
                                "learning_reset_progress_tooltip",
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        ),
                      ),

                      // Progress Indicator
                      SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                      SliverToBoxAdapter(
                        child: _buildProgressIndicator(provider, isDark),
                      ),

                      // Title
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Text(
                            widget.title,
                            style: AppTypography.h1.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                      ),

                      // Summary
                      SliverToBoxAdapter(
                        child: _buildSection(
                          title: _tr(context, 'learning_summary'),
                          isDark: isDark,
                          child: Text(
                            _tr(context, content.summaryText),
                            style: AppTypography.body.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),

                      // Understanding
                      SliverToBoxAdapter(
                        child: _buildSection(
                          title: _tr(context, 'learning_concept'),
                          isDark: isDark,
                          child: Text(
                            _tr(context, content.understandingText),
                            style: AppTypography.body.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),

                      // Algorithm Steps
                      SliverToBoxAdapter(
                        child: _buildSection(
                          title: _tr(context, 'learning_algorithm_steps'),
                          isDark: isDark,
                          child: _buildBulletPoints(
                            content.algorithmSteps,
                            isDark,
                          ),
                        ),
                      ),

                      // Visual Steps
                      SliverToBoxAdapter(
                        child: _buildSection(
                          title: _tr(context, 'learning_step_by_step'),
                          isDark: isDark,
                          child: _buildVisualSteps(content.visualSteps, isDark),
                        ),
                      ),

                      // Complexity
                      SliverToBoxAdapter(
                        child: _buildSection(
                          title: _tr(context, 'learning_complexity'),
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildComplexityCard(
                                _tr(context, 'learning_time_complexity'),
                                _tr(context, content.timeComplexity),
                                isDark,
                              ),
                              SizedBox(height: 12.h),
                              _buildComplexityCard(
                                _tr(context, 'learning_space_complexity'),
                                _tr(context, content.spaceComplexity),
                                isDark,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Advantages & Disadvantages
                      SliverToBoxAdapter(
                        child: _buildSection(
                          title: _tr(context, 'learning_pros_cons'),
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProsCons(
                                _tr(context, 'learning_advantages'),
                                content.advantages,
                                isDark,
                                Colors.green,
                              ),
                              SizedBox(height: 16.h),
                              _buildProsCons(
                                _tr(context, 'learning_disadvantages'),
                                content.disadvantages,
                                isDark,
                                Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Use Cases
                      if (content.useCases != null)
                        SliverToBoxAdapter(
                          child: _buildSection(
                            title: _tr(context, 'learning_use_cases'),
                            isDark: isDark,
                            child: Text(
                              _tr(context, content.useCases!),
                              style: AppTypography.body.copyWith(
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),

                      // Real World Example
                      if (content.realWorldExample != null)
                        SliverToBoxAdapter(
                          child: _buildSection(
                            title: _tr(context, 'learning_real_world'),
                            isDark: isDark,
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color:
                                    (isDark
                                            ? AppColors.primary
                                            : AppColors.primary)
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.primary
                                      : AppColors.primary,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _tr(context, content.realWorldExample!),
                                style: AppTypography.body.copyWith(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Code Example
                      SliverToBoxAdapter(
                        child: _buildSection(
                          title: _tr(context, 'learning_code_implementation'),
                          isDark: isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCodeEditor(
                                content.codeExample,
                                isDark,
                                readOnly: true,
                              ),
                              SizedBox(height: 12.h),
                              _buildRunCodeButton(provider, isDark),
                            ],
                          ),
                        ),
                      ),

                      // Output
                      if (provider.output.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildSection(
                            title: _tr(context, 'learning_output'),
                            isDark: isDark,
                            child: _buildCodeEditor(
                              provider.output,
                              isDark,
                              readOnly: true,
                              isOutput: true,
                            ),
                          ),
                        ),

                      // Quizzes
                      SliverToBoxAdapter(
                        child: _buildSection(
                          title: _tr(context, 'learning_quiz'),
                          isDark: isDark,
                          child:
                              (provider.output.isEmpty && !provider.isCompleted)
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.h),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.lock_rounded,
                                          size: 48.sp,
                                          color: isDark
                                              ? Colors.white24
                                              : Colors.black26,
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          _tr(
                                            context,
                                            "learning_unlock_quiz_msg",
                                          ),
                                          textAlign: TextAlign.center,
                                          style: AppTypography.body.copyWith(
                                            color: isDark
                                                ? Colors.white54
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: List.generate(
                                    content.quizQuestions.length,
                                    (index) => _buildQuizCard(
                                      index,
                                      content.quizQuestions[index],
                                      provider,
                                      isDark,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      // Bottom spacing
                      SliverToBoxAdapter(child: SizedBox(height: 32.h)),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
    UniversalAlgorithmProvider provider,
    bool isDark,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.cardDark : AppColors.cardGlass).withValues(
          alpha: 0.3,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                _tr(context, 'learning_progress'),
                style: AppTypography.body.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${(provider.progress * 100).toInt()}%',
                style: AppTypography.body.copyWith(
                  color: isDark ? AppColors.primary : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: provider.progress,
              minHeight: 8.h,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.primary : AppColors.primary,
              ),
            ),
          ),
          if (provider.isCompleted)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    _tr(context, 'learning_completed_msg'),
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.cardDark : AppColors.cardGlass).withValues(
          alpha: 0.3,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h2.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6.h, right: 12.w),
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primary : AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  _tr(context, point),
                  style: AppTypography.body.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVisualSteps(List<String> steps, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: (isDark ? Colors.black : Colors.grey[100])?.withValues(
          alpha: 0.5,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: steps.map((step) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              _tr(context, step),
              style: AppTypography.body.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildComplexityCard(String title, String content, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.cardDark : AppColors.cardGlass).withValues(
          alpha: 0.5,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: AppTypography.body.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: AppTypography.body.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProsCons(
    String title,
    List<String> items,
    bool isDark,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: AppTypography.body.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12.h),
        ...items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6.h, right: 12.w),
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    _tr(context, item),
                    style: AppTypography.body.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCodeEditor(
    String code,
    bool isDark, {
    bool readOnly = false,
    bool isOutput = false,
    TextEditingController? controller,
  }) {
    // Colors based on CodeCard
    final bgMain = isDark ? const Color(0xFF0A141D) : Colors.white;
    final bgEditor = isOutput
        ? (isDark ? const Color(0xFF071019) : const Color(0xFFE9F0FC))
        : (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA));

    final showGutter = !isOutput;
    final gutterWidth = showGutter ? 35.w : 0.0;

    final gutterColor = isDark
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFEEEEEE);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.grey[300]!;

    // Controller & Lines
    final effectiveController = controller ?? TextEditingController(text: code);
    final codeLines = effectiveController.text.split('\n');
    final lineCount = codeLines.length;
    final maxLines = lineCount < 5 ? 5 : lineCount;

    // Code Style
    final codeStyle = TextStyle(
      fontFamily: 'monospace',
      color: isOutput
          ? (isDark ? const Color(0xFF84FF7E) : const Color(0xFF2E7D32))
          : (isDark ? const Color(0xFFD4D4D4) : const Color(0xFF24292E)),
      fontSize: 13.sp,
      height: 1.5,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgMain,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                if (showGutter) ...[
                  _buildDot(const Color(0xFFFF5F56)),
                  SizedBox(width: 8.w),
                  _buildDot(const Color(0xFFFFBD2E)),
                  SizedBox(width: 8.w),
                  _buildDot(const Color(0xFF27C93F)),
                  const Spacer(),
                ],
                Text(
                  isOutput
                      ? _tr(context, "common_debug_console")
                      : _tr(context, "common_solution_file"),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: 11.sp,
                    fontWeight: isOutput ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: isOutput ? 0.5 : 0,
                  ),
                ),
                if (isOutput) const Spacer(),
              ],
            ),
          ),

          // Editor Area with Wrap Sync
          Container(
            width: double.infinity,
            color: bgEditor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine widths
                final paddingHorizontal = 16.w;
                // Available text width
                final textAvailableWidth =
                    constraints.maxWidth -
                    gutterWidth -
                    (paddingHorizontal * 2);

                // Calculate line heights
                final lineHeights = List<double>.filled(maxLines, 0);

                if (textAvailableWidth > 0 && showGutter) {
                  for (int i = 0; i < maxLines; i++) {
                    String lineText = '';
                    if (i < codeLines.length) {
                      lineText = codeLines[i];
                    }
                    if (lineText.isEmpty && i < codeLines.length) {
                      // Empty line needs height
                      lineHeights[i] = 13.sp * 1.5;
                      continue;
                    }

                    // Measure
                    final span = TextSpan(text: lineText, style: codeStyle);
                    final painter = TextPainter(
                      text: span,
                      textDirection: TextDirection.ltr,
                    );
                    painter.layout(maxWidth: textAvailableWidth);

                    final minHeight = 13.sp * 1.5;
                    lineHeights[i] = painter.height < minHeight
                        ? minHeight
                        : painter.height;
                  }
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gutter
                    if (showGutter)
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 8.w,
                        ),
                        width: gutterWidth,
                        decoration: BoxDecoration(
                          color: gutterColor,
                          border: Border(right: BorderSide(color: borderColor)),
                        ),
                        child: Column(
                          children: List.generate(maxLines, (index) {
                            final h = textAvailableWidth > 0
                                ? lineHeights[index]
                                : (13.sp * 1.5);
                            return SizedBox(
                              height: h,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                ), // alignment
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    color: isDark
                                        ? const Color(0xFF858585)
                                        : Colors.grey[500],
                                    fontSize: 11.sp,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                    // Code Input (Wrapped)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: paddingHorizontal,
                        ),
                        child: TextField(
                          controller: effectiveController,
                          readOnly: readOnly,
                          maxLines: null, // Unlimited lines, allows wrapping
                          style: codeStyle,
                          cursorColor: isDark ? Colors.white : Colors.black,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildRunCodeButton(UniversalAlgorithmProvider provider, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => provider.runCode(),
        icon: Icon(Icons.play_arrow_rounded, size: 24.sp),
        label: Text(
          AppLocalizations.of(context).translate('learning_run_code'),
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.primary : AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard(
    int index,
    QuizQuestion quiz,
    UniversalAlgorithmProvider provider,
    bool isDark,
  ) {
    // Initialize controller if not exists
    final controller = _quizControllers.putIfAbsent(
      index,
      () => TextEditingController(text: provider.userAnswers[index] ?? ''),
    );

    final result = provider.quizResults[index];
    final output = provider.quizOutputs[index] ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.cardDark : AppColors.cardGlass).withValues(
          alpha: 0.5,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: result == null
              ? Colors.white.withValues(alpha: 0.1)
              : result
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primary : AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${AppLocalizations.of(context).translate('quiz_label')} ${index + 1}',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (result != null)
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Icon(
                    result ? Icons.check_circle : Icons.cancel,
                    color: result ? Colors.green : Colors.red,
                    size: 24.sp,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            _tr(context, quiz.question),
            style: AppTypography.body.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16.h),

          // Code Editor
          _buildCodeEditor('', isDark, controller: controller),
          SizedBox(height: 12.h),

          // Hint
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${_tr(context, "learning_hint_prefix")}${_tr(context, quiz.hint)}',
                    style: AppTypography.bodySmall.copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    provider.submitQuiz(
                      index,
                      controller.text,
                      AppLocalizations.of(context),
                    );
                  },
                  icon: Icon(Icons.check, size: 20.sp),
                  label: Text(_tr(context, "common_submit")),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.primary
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    provider.resetQuiz(index);
                    controller.text = quiz.codeTemplate;
                  },
                  icon: Icon(Icons.refresh, size: 20.sp),
                  label: Text(_tr(context, "common_reset")),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textPrimaryLight,
                    side: BorderSide(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : Colors.grey[400]!,
                      width: 1.5,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Output
          if (output.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: result == true
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: result == true ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Text(
                  output,
                  style: AppTypography.body.copyWith(
                    color: result == true ? Colors.green : Colors.red,
                    height: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
