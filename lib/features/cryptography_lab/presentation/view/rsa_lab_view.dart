import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../../../../core/constants/app_localizations.dart';
import '../provider/rsa_provider.dart';

class RSALabView extends StatelessWidget {
  const RSALabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final glass = Theme.of(context).extension<GlassTheme>()!;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
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
            child: Consumer<RSAProvider>(
              builder: (context, prov, _) {
                final textColor = isDark ? Colors.white : Colors.black87;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      GlassAppBar(
                        title: "RSA Encryption Lab",
                        autoBack: true,
                        isDark: isDark,
                      ),

                      SizedBox(height: 20.h),

                      // Case Study Header
                      _buildCaseStudy(textColor, context),

                      SizedBox(height: 20.h),

                      // Section 1: Keys
                      _buildKeyPanel(prov, glass, isDark, textColor),

                      SizedBox(height: 24.h),

                      // Section 2: Playground
                      _buildPlayground(prov, glass, isDark, textColor),

                      SizedBox(height: 100.h),
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

  Widget _buildCaseStudy(Color textColor, BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_rounded,
            color: Colors.purpleAccent,
            size: 32.sp,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.translate('rsa_title_pro').toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  t.translate('rsa_desc_pro'),
                  style: AppTypography.bodySmall.copyWith(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPanel(
    RSAProvider prov,
    GlassTheme glass,
    bool isDark,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: glass.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Digital Identity",
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 16.sp,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: prov.generateNewKeys,
                icon: Icon(Icons.refresh_rounded, color: Colors.purpleAccent),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _infoTile(
                "Prime P",
                prov.keyPair?.p.toString() ?? "?",
                Colors.blueAccent,
              ),
              SizedBox(width: 12.w),
              _infoTile(
                "Prime Q",
                prov.keyPair?.q.toString() ?? "?",
                Colors.cyanAccent,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _infoTile(
            "Modulus (N)",
            prov.keyPair?.n.toString() ?? "?",
            Colors.orangeAccent,
            fullWidth: true,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _infoTile(
                "Public (E)",
                prov.keyPair?.e.toString() ?? "?",
                Colors.greenAccent,
              ),
              SizedBox(width: 12.w),
              _infoTile(
                "Private (D)",
                prov.keyPair?.d.toString() ?? "?",
                Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    String label,
    String value,
    Color color, {
    bool fullWidth = false,
  }) {
    return Expanded(
      flex: fullWidth ? 0 : 1,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: GoogleFonts.firaCode(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayground(
    RSAProvider prov,
    GlassTheme glass,
    bool isDark,
    Color textColor,
  ) {
    return Column(
      children: [
        // Input Message
        TextField(
          onChanged: prov.updateMessage,
          textAlign: TextAlign.center,
          style: AppTypography.h2.copyWith(color: textColor, letterSpacing: 4),
          decoration: InputDecoration(
            hintText: "TYPE MESSAGE",
            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.3)),
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 20.h),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: _actionBtn(
                label: "ENCRYPT",
                icon: Icons.lock_outline,
                color: Colors.blueAccent,
                onTap: prov.startEncryption,
                isLoading: prov.isEncrypting,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _actionBtn(
                label: "DECRYPT",
                icon: Icons.lock_open_rounded,
                color: Colors.greenAccent,
                onTap: prov.startDecryption,
                isLoading: prov.isDecrypting,
              ),
            ),
          ],
        ),

        SizedBox(height: 30.h),

        // Data Visualization
        _buildDataFlow(prov, glass, textColor),
      ],
    );
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(icon, color: color, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataFlow(RSAProvider prov, GlassTheme glass, Color textColor) {
    return Column(
      children: [
        // Original Blocks
        _labeledRow(
          "Blocks (ASCII)",
          prov.inputMessage.codeUnits.map((e) => e.toString()).toList(),
          Colors.blueGrey,
          prov.currentBlockIdx,
        ),
        SizedBox(height: 20.h),
        Icon(
          Icons.keyboard_double_arrow_down_rounded,
          color: Colors.purpleAccent.withValues(alpha: 0.5),
        ),
        SizedBox(height: 20.h),
        // Encrypted Blocks
        _labeledRow(
          "Encrypted (C)",
          prov.encryptedValues.map((e) => e.toString()).toList(),
          Colors.blueAccent,
          prov.currentBlockIdx,
        ),
        SizedBox(height: 20.h),
        Icon(
          Icons.keyboard_double_arrow_down_rounded,
          color: Colors.greenAccent.withValues(alpha: 0.5),
        ),
        SizedBox(height: 20.h),
        // Decrypted Blocks
        _labeledRow(
          "Final Message",
          [prov.decryptedString],
          Colors.greenAccent,
          -1,
          isMessage: true,
        ),
      ],
    );
  }

  Widget _labeledRow(
    String label,
    List<String> items,
    Color color,
    int highlightIdx, {
    bool isMessage = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color.withValues(alpha: 0.7),
              fontSize: 10.sp,
            ),
          ),
        ),
        if (isMessage)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              items.first,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaCode(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(items.length, (i) {
                final isHighlight = i == highlightIdx;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isHighlight ? color : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    items[i],
                    style: GoogleFonts.firaCode(
                      color: isHighlight
                          ? (color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white)
                          : color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
