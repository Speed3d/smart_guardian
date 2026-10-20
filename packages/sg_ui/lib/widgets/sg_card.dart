import 'package:flutter/material.dart';

/// ============================================================================
/// 📌 بطاقة العرض الموحدة (Smart Guardian Card)
/// ----------------------------------------------------------------------------
/// حاوية قياسية تعرض بطاقات الأطفال، الإحصائيات، وسجلات الأمان بانحناءات وظلال أنيقة.
/// ============================================================================

class SgCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const SgCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
