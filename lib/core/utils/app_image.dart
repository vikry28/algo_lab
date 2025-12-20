import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';
import '../utils/image_paths.dart';
import '../../features/home/presentation/widget/modern_image_preview.dart';

class AppImage extends StatelessWidget {
  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? radius;
  final Color? color;
  final double? placeholderSize;
  final VoidCallback? onTap;
  final bool showPreview;
  final bool canEdit;
  final Function(String)? onImageEdited;

  const AppImage({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
    this.color,
    this.placeholderSize,
    this.onTap,
    this.showPreview = false,
    this.canEdit = false,
    this.onImageEdited,
  });

  bool get isNetwork => src.startsWith('http') || src.startsWith('https');
  bool get isSvg => src.toLowerCase().contains('.svg');
  bool get isFile =>
      src.startsWith('/') ||
      src.startsWith('file://') ||
      (src.length > 2 && src[1] == ':');

  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final int? cacheWidth = (width != null && width!.isFinite)
        ? (width! * devicePixelRatio).round()
        : null;
    final int? cacheHeight = (height != null && height!.isFinite)
        ? (height! * devicePixelRatio).round()
        : null;

    Widget image;

    if (isNetwork) {
      if (isSvg) {
        image = SvgPicture.network(
          src,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) => _buildShimmerPlaceholder(),
        );
      } else {
        image = CachedNetworkImage(
          imageUrl: src,
          width: width,
          height: height,
          fit: fit,
          color: color,
          memCacheWidth: cacheWidth,
          memCacheHeight: cacheHeight,
          maxWidthDiskCache: 1000,
          maxHeightDiskCache: 1000,
          fadeInDuration: const Duration(milliseconds: 200),
          fadeOutDuration: const Duration(milliseconds: 200),
          placeholder: (context, url) => _buildShimmerPlaceholder(),
          errorWidget: (context, url, error) => _buildError(),
        );
      }
    } else if (isSvg) {
      if (isFile) {
        image = SvgPicture.file(
          File(src.replaceFirst('file://', '')),
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) => _buildShimmerPlaceholder(),
        );
      } else {
        image = SvgPicture.asset(
          src,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) => _buildShimmerPlaceholder(),
        );
      }
    } else {
      if (isFile) {
        image = Image.file(
          File(src.replaceFirst('file://', '')),
          width: width,
          height: height,
          fit: fit,
          color: color,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
      } else {
        image = Image.asset(
          src,
          width: width,
          height: height,
          fit: fit,
          color: color,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
      }
    }

    if (radius != null) {
      image = ClipRRect(borderRadius: radius!, child: image);
    }

    if (showPreview) {
      image = Hero(tag: src, child: image);
    }

    if (onTap != null || showPreview) {
      return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else if (showPreview) {
            _showImagePreview(context);
          }
        },
        child: image,
      );
    }

    return image;
  }

  void _showImagePreview(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.8),
        pageBuilder: (context, animation, secondaryAnimation) {
          return ModernImagePreview(
            src: src,
            canEdit: canEdit,
            onImageEdited: onImageEdited,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withValues(alpha: 0.1),
      highlightColor: Colors.grey.withValues(alpha: 0.05),
      period: const Duration(milliseconds: 1000),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.zero,
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.textGrey.withValues(alpha: 0.05),
        borderRadius: radius ?? BorderRadius.zero,
      ),
      child: Center(
        child: Opacity(
          opacity: 0.5,
          child: Image.asset(
            ImagePaths.error,
            width: (width ?? 40) * 0.4,
            height: (height ?? 40) * 0.4,
            fit: BoxFit.contain,
            errorBuilder: (context, err, stack) => Icon(
              Icons.image_not_supported_outlined,
              size: (width ?? 40) * 0.4,
              color: AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}
