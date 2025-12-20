import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/app_image.dart';
import 'modern_notification.dart';

class ModernImagePreview extends StatelessWidget {
  final String src;
  final bool canEdit;
  final Function(String)? onImageEdited;

  const ModernImagePreview({
    super.key,
    required this.src,
    this.canEdit = false,
    this.onImageEdited,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: (isDark ? AppColors.darkBackground[0] : Colors.black)
              .withValues(alpha: 0.6),
          child: SafeArea(
            child: Column(
              children: [
                /// Header with Close Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Image Preview',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          shape: const CircleBorder(),
                        ),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textPrimaryDark,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Main Image with Zoom Support
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Center(
                        child: Hero(
                          tag: src,
                          child: AppImage(
                            src: src,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            radius: BorderRadius.circular(20.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Action Buttons (Edit Mode)
                if (canEdit)
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 24.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(32.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(
                            icon: Icons.photo_library_rounded,
                            label: 'Gallery',
                            onTap: () =>
                                _pickImage(context, ImageSource.gallery),
                          ),
                          Container(
                            width: 1,
                            height: 40.h,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          _ActionButton(
                            icon: Icons.camera_alt_rounded,
                            label: 'Camera',
                            onTap: () =>
                                _pickImage(context, ImageSource.camera),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1000,
      );
    } catch (e) {
      if (context.mounted) {
        String errorMessage = 'Failed to pick image: $e';
        if (e.toString().contains('channel-error')) {
          errorMessage =
              'Plugin error: Please RESTART the app completely to link new dependencies.';
        }
        ModernNotification.show(
          context,
          message: errorMessage,
          type: ModernNotificationType.error,
        );
      }
      return;
    }

    if (pickedFile != null && context.mounted) {
      // Show loading
      ModernNotification.show(
        context,
        message: 'Uploading image...',
        type: ModernNotificationType.info,
      );

      try {
        final File file = File(pickedFile.path);
        final String fileName =
            'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // This is a simplified upload logic.
        // In a real app, you'd use a specific path related to the user ID.
        final storageRef = FirebaseStorage.instance.ref().child(
          'uploads/$fileName',
        );
        final uploadTask = await storageRef.putFile(file);
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        if (onImageEdited != null) {
          onImageEdited!(downloadUrl);
        }

        if (context.mounted) {
          ModernNotification.show(
            context,
            message: 'Image updated successfully!',
            type: ModernNotificationType.success,
          );
          Navigator.pop(context); // Close preview after edit
        }
      } catch (e) {
        if (context.mounted) {
          ModernNotification.show(
            context,
            message: 'Failed to upload image: $e',
            type: ModernNotificationType.error,
          );
        }
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
