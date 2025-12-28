import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/constants/app_localizations.dart';
import '../../../home/presentation/widget/app_bar.dart';
import '../provider/rsa_provider.dart';

class RSALabView extends StatelessWidget {
  const RSALabView({super.key});

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
          _buildBackground(isDark),
          SafeArea(
            child: Consumer<RSAProvider>(
              builder: (context, prov, _) {
                final textColor = isDark ? Colors.white : Colors.black87;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 5.h,
                  ),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        backgroundColor: AppColors.transparent,
                        expandedHeight: 70.h,
                        collapsedHeight: 60.h,
                        automaticallyImplyLeading: false,
                        flexibleSpace: GlassAppBar(
                          title: t.translate('rsa_lab_title'),
                          autoBack: true,
                          isDark: isDark,
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                      SliverToBoxAdapter(
                        child: _buildScenarioSwitcher(prov, textColor, t),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                      SliverToBoxAdapter(
                        child: _buildCaseStudy(textColor, context, prov, t),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                      SliverToBoxAdapter(
                        child: _buildIdentitySection(prov, glass, textColor, t),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                      SliverToBoxAdapter(
                        child: _buildSimulationPanel(prov, glass, textColor, t),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 100.h)),
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

  Widget _buildBackground(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildScenarioSwitcher(
    RSAProvider prov,
    Color textColor,
    AppLocalizations t,
  ) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _scenarioTab(
              t.translate('rsa_encryption_tab'),
              RSAScenario.encryption,
              prov.currentScenario == RSAScenario.encryption,
              Colors.blueAccent,
              () => prov.setScenario(RSAScenario.encryption),
            ),
          ),
          Expanded(
            child: _scenarioTab(
              t.translate('rsa_signature_tab'),
              RSAScenario.signature,
              prov.currentScenario == RSAScenario.signature,
              Colors.purpleAccent,
              () => prov.setScenario(RSAScenario.signature),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scenarioTab(
    String label,
    RSAScenario scenario,
    bool isActive,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: isActive ? Colors.white : Colors.grey.withValues(alpha: 0.4),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCaseStudy(
    Color textColor,
    BuildContext context,
    RSAProvider prov,
    AppLocalizations t,
  ) {
    final isEncrypt = prov.currentScenario == RSAScenario.encryption;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEncrypt
              ? [
                  Colors.blue.withValues(alpha: 0.2),
                  Colors.blue.withValues(alpha: 0.05),
                ]
              : [
                  Colors.purple.withValues(alpha: 0.2),
                  Colors.purple.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: (isEncrypt ? Colors.blueAccent : Colors.purpleAccent)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: (isEncrypt ? Colors.blueAccent : Colors.purpleAccent)
                  .withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEncrypt
                  ? Icons.lock_person_rounded
                  : Icons.verified_user_rounded,
              color: isEncrypt ? Colors.blueAccent : Colors.purpleAccent,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEncrypt
                      ? t.translate('rsa_secure_comm_title')
                      : t.translate('rsa_banking_sig_title'),
                  style: AppTypography.labelSmall.copyWith(
                    color: isEncrypt ? Colors.blueAccent : Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isEncrypt
                      ? t.translate('rsa_secure_comm_desc')
                      : t.translate('rsa_banking_sig_desc'),
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

  Widget _buildIdentitySection(
    RSAProvider prov,
    GlassTheme glass,
    Color textColor,
    AppLocalizations t,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.translate('rsa_key_mgmt_title'),
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 14.sp,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: prov.generateNewKeys,
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.blueAccent,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: glass.color,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: glass.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _keyTile(
                    t.translate('rsa_modulus_label'),
                    prov.keyPair?.n.toString() ?? "?",
                    Colors.orangeAccent,
                  ),
                  SizedBox(width: 12.w),
                  _keyTile(
                    t.translate('rsa_phi_label'),
                    prov.keyPair?.phi.toString() ?? "?",
                    Colors.tealAccent,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _keyTile(
                    t.translate('rsa_public_e_label'),
                    prov.keyPair?.e.toString() ?? "?",
                    Colors.greenAccent,
                  ),
                  SizedBox(width: 12.w),
                  _keyTile(
                    t.translate('rsa_private_d_label'),
                    prov.keyPair?.d.toString() ?? "?",
                    Colors.redAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _keyTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.firaCode(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: color.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationPanel(
    RSAProvider prov,
    GlassTheme glass,
    Color textColor,
    AppLocalizations t,
  ) {
    final accentColor = prov.currentScenario == RSAScenario.encryption
        ? Colors.blueAccent
        : Colors.purpleAccent;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: glass.color,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: glass.border),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: prov.updateMessage,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: t.translate('rsa_data_hint'),
              hintStyle: TextStyle(
                color: textColor.withValues(alpha: 0.2),
                fontSize: 12.sp,
              ),
              border: InputBorder.none,
            ),
            style: GoogleFonts.firaCode(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 20.h),
          _runButton(prov, accentColor, t),
          SizedBox(height: 30.h),
          if (prov.currentScenario == RSAScenario.encryption)
            _buildEncryptionVisuals(prov, textColor, t)
          else
            _buildSignatureVisuals(prov, textColor, t),
        ],
      ),
    );
  }

  Widget _runButton(RSAProvider prov, Color color, AppLocalizations t) {
    return InkWell(
      onTap: prov.runScenario,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: prov.isProcessing
            ? Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    t.translate('rsa_btn_start'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEncryptionVisuals(
    RSAProvider prov,
    Color textColor,
    AppLocalizations t,
  ) {
    return Column(
      children: [
        _stepInfo(
          t.translate('rsa_step_1_enc_title'),
          t.translate('rsa_step_1_enc_desc'),
        ),
        _blockRow(
          prov.inputMessage.codeUnits.map((e) => e.toString()).toList(),
          Colors.blueGrey,
          prov.currentStepIdx,
        ),
        _arrowSeparator(Colors.blueAccent),
        _stepInfo(
          t.translate('rsa_step_2_enc_title'),
          t.translate('rsa_step_2_enc_desc'),
        ),
        _blockRow(
          prov.encryptedValues.map((e) => e.toString()).toList(),
          Colors.blueAccent,
          prov.currentStepIdx,
        ),
        _arrowSeparator(Colors.greenAccent),
        _stepInfo(
          t.translate('rsa_step_3_enc_title'),
          t.translate('rsa_step_3_enc_desc'),
        ),
        _blockRow(
          prov.decryptedString.codeUnits.map((e) => e.toString()).toList(),
          Colors.greenAccent,
          prov.currentStepIdx,
        ),
        SizedBox(height: 10.h),
        _finalResult(
          t.translate('rsa_decrypted_msg_label'),
          prov.decryptedString,
          Colors.greenAccent,
        ),
      ],
    );
  }

  Widget _buildSignatureVisuals(
    RSAProvider prov,
    Color textColor,
    AppLocalizations t,
  ) {
    return Column(
      children: [
        _stepInfo(
          t.translate('rsa_step_1_sig_title'),
          t.translate('rsa_step_1_sig_desc'),
        ),
        _hashDisplay(prov.messageHash, Colors.purpleAccent, t),
        _arrowSeparator(Colors.orangeAccent),
        _stepInfo(
          t.translate('rsa_step_2_sig_title'),
          t.translate('rsa_step_2_sig_desc'),
        ),
        _blockRow(
          prov.signature.map((e) => e.toString()).toList(),
          Colors.orangeAccent,
          prov.currentStepIdx,
        ),
        _arrowSeparator(Colors.tealAccent),
        _stepInfo(
          t.translate('rsa_step_3_sig_title'),
          t.translate('rsa_step_3_sig_desc'),
        ),
        if (prov.isVerified && !prov.isProcessing)
          _verificationSuccess(t)
        else if (prov.signature.isNotEmpty)
          _verificationPending(prov, t),
      ],
    );
  }

  Widget _stepInfo(String title, String desc) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h, top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.sp),
          ),
          Text(
            desc,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blockRow(List<String> items, Color color, int activeIdx) {
    return Container(
      height: 45.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, i) {
          final isActive = i == activeIdx;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: isActive ? color : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: color.withValues(alpha: 0.3)),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              items[i],
              style: GoogleFonts.firaCode(
                color: isActive ? Colors.white : color,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hashDisplay(String hash, Color color, AppLocalizations t) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          style: BorderStyle.none,
        ),
      ),
      child: Text(
        hash.isEmpty ? t.translate('rsa_waiting_hash') : hash,
        style: GoogleFonts.firaCode(
          color: color,
          fontSize: 10.sp,
          letterSpacing: 1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _arrowSeparator(Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Icon(
        Icons.keyboard_double_arrow_down_rounded,
        color: color.withValues(alpha: 0.3),
        size: 20.sp,
      ),
    );
  }

  Widget _finalResult(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
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
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verificationSuccess(AppLocalizations t) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
          SizedBox(width: 8.w),
          Text(
            t.translate('rsa_sig_validated'),
            style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verificationPending(RSAProvider prov, AppLocalizations t) {
    return Text(
      t.translate('rsa_sig_verifying'),
      style: TextStyle(
        color: Colors.orangeAccent.withValues(alpha: 0.5),
        fontSize: 10.sp,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
