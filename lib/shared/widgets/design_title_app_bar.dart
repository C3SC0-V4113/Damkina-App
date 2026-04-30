import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class DesignTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DesignTitleAppBar({
    required this.title,
    this.automaticallyImplyLeading = true,
    super.key,
  });

  final String title;
  final bool automaticallyImplyLeading;

  static const _appBarHeight = kToolbarHeight;

  @override
  Size get preferredSize => const Size.fromHeight(_appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.forest,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.line),
      ),
    );
  }
}
