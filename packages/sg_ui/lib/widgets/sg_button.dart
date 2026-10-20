import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ============================================================================
/// 📌 زر الإجراءات الموحد (Smart Guardian Button)
/// ----------------------------------------------------------------------------
/// ويدجت زر مخصص يعبر عن نمط الواجهات الأمني الحديث ويدعم مؤشر التحميل وحالات التعطيل.
/// ============================================================================

enum SgButtonType {
  primary,   // زر الإجراء الرئيسي (أزرق)
  danger,    // زر الإجراءات الخطرة أو القفل (أحمر)
  secondary, // زر ثانوي أو تمديد (رمادي أو شفاف)
}

class SgButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final SgButtonType type;
  final IconData? icon;

  const SgButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.type = SgButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (type) {
      SgButtonType.primary => AppColors.primary,
      SgButtonType.danger => AppColors.danger,
      SgButtonType.secondary => AppColors.secondary,
    };

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
