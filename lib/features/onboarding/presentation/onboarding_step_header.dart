import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class OnboardingProgressAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const OnboardingProgressAppBar({
    required this.title,
    required this.subtitle,
    required this.progress,
    this.automaticallyImplyLeading = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final double progress;
  final bool automaticallyImplyLeading;
  static const _appBarHeight = 118.0;

  @override
  Size get preferredSize => const Size.fromHeight(_appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: _appBarHeight,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.forest,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedInk,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: progress.clamp(0, 1).toDouble(),
                backgroundColor: AppColors.line,
                color: AppColors.forest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
