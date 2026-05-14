import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';

class PremiumButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? iconWidget;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final double? width;

  const PremiumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.iconWidget,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: onPressed != null ? AppTheme.buttonShadow : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppTheme.gold,
          foregroundColor: textColor ?? Colors.black,
          disabledBackgroundColor: (color ?? AppTheme.gold).withValues(alpha: 0.5),
          padding: EdgeInsets.symmetric(vertical: 18.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor ?? Colors.black,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconWidget != null) ...[
                    iconWidget!,
                    SizedBox(width: 12.w),
                  ] else if (icon != null) ...[
                    Icon(icon, size: 18.sp),
                    SizedBox(width: 12.w),
                  ],
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

