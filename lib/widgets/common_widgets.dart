import 'package:flutter/material.dart';
import 'package:lokse/core/constants/app_colors.dart';
import 'package:lokse/core/constants/app_sizes.dart';
import 'package:lokse/core/constants/app_text_styles.dart';
import 'package:get/get.dart';
import 'package:lokse/core/utils/global_controller.dart';

// ═══════════════════════════════════════════════════════════════
// APP BUTTON
// ═══════════════════════════════════════════════════════════════
enum AppButtonVariant { primary, secondary, danger, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final AppButtonVariant variant;
  final double? width;
  final double height;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.width,
    this.height = AppSizes.buttonMd,
    this.icon,
  });

  Color get _bg {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.primarySurface;
      case AppButtonVariant.danger:
        return AppColors.error;
      case AppButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color get _fg {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.white;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.danger:
        return AppColors.white;
      case AppButtonVariant.ghost:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: (isLoading || onTap == null) ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _bg,
          foregroundColor: _fg,
          disabledBackgroundColor: _bg.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            side: variant == AppButtonVariant.ghost
                ? BorderSide(color: AppColors.primary.withOpacity(0.3))
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _fg,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppSizes.iconSm, color: _fg),
                    const SizedBox(width: AppSizes.sm),
                  ],
                  Text(label,
                      style: AppTextStyles.buttonMd.copyWith(color: _fg)),
                ],
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// APP CARD
// ═══════════════════════════════════════════════════════════════
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double radius;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.radius = AppSizes.radiusLg,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppSizes.cardPadMd),
        decoration: BoxDecoration(
          color: color ?? AppColors.cardBg,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// APP TEXT FIELD
// ═══════════════════════════════════════════════════════════════
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? hint;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMd,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, size: AppSizes.iconMd),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// COIN BADGE  — shows live coin count from GlobalController
// ═══════════════════════════════════════════════════════════════
class CoinBadge extends StatelessWidget {
  final bool dark; // dark=true for headers on colored backgrounds
  const CoinBadge({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final gc = GlobalController.instance;
    return Obx(() => _Badge(
          icon: Icons.monetization_on_rounded,
          iconColor: AppColors.coin,
          value: gc.totalCoins.value.toString(),
          label: 'coins',
          dark: dark,
        ));
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool dark;

  const _Badge({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = dark ? Colors.white.withOpacity(0.15) : AppColors.coinSurface;
    final textColor = dark ? AppColors.white : AppColors.coinText;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md, vertical: AppSizes.sm - 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: AppSizes.iconSm),
          const SizedBox(width: AppSizes.xs + 2),
          Text(value, style: AppTextStyles.labelLg.copyWith(color: textColor)),
          const SizedBox(width: AppSizes.xs),
          Text(label,
              style: AppTextStyles.labelSm
                  .copyWith(color: textColor.withOpacity(0.65))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.lg, 0, AppSizes.lg, AppSizes.sm + 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h4),
          if (actionLabel != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// GRADIENT HEADER (used in Home, Learn, Quiz pages)
// ═══════════════════════════════════════════════════════════════
class GradientHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final double paddingBottom;

  const GradientHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.paddingBottom = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.headerPadH,
        AppSizes.headerPadV,
        AppSizes.headerPadH,
        paddingBottom,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h2OnDark),
                const SizedBox(height: AppSizes.xs),
                Text(subtitle, style: AppTextStyles.captionOnDark),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.grey300),
            const SizedBox(height: AppSizes.lg),
            Text(message,
                style: AppTextStyles.bodySm, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSizes.xl),
              AppButton(
                label: actionLabel!,
                onTap: onAction,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// LOADING OVERLAY
// ═══════════════════════════════════════════════════════════════
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STAR ROW  (quiz levels)
// ═══════════════════════════════════════════════════════════════
class StarRow extends StatelessWidget {
  final int stars;
  final double size;
  final bool dark;

  const StarRow({
    super.key,
    required this.stars,
    this.size = 14,
    this.dark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Icon(
          Icons.star_rounded,
          size: size,
          color: i < stars
              ? AppColors.coin
              : (dark ? Colors.white.withOpacity(0.2) : AppColors.grey200),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DIFFICULTY BADGE
// ═══════════════════════════════════════════════════════════════
class DifficultyBadge extends StatelessWidget {
  final String label;
  final Color color;
  const DifficultyBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm + 2, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm - 2),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(color: AppColors.white),
      ),
    );
  }
}
