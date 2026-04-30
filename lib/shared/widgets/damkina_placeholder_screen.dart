import 'package:damkina_app/core/theme/app_tokens.dart';
import 'package:damkina_app/shared/widgets/design_title_app_bar.dart';
import 'package:flutter/material.dart';

class DamkinaPlaceholderScreen extends StatelessWidget {
  const DamkinaPlaceholderScreen({
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
    this.useDesignTitleAppBar = false,
    super.key,
  });

  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool useDesignTitleAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: useDesignTitleAppBar
          ? DesignTitleAppBar(
              title: title,
              automaticallyImplyLeading: false,
            )
          : AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (actionLabel != null && onActionPressed != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: onActionPressed,
                      child: Text(actionLabel!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
