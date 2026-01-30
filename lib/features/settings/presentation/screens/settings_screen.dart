import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../../tasks/presentation/providers/task_provider.dart';

/// Settings screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          _buildSectionHeader(
            context,
            'Appearance',
            Iconsax.paintbucket,
          ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          _buildThemeCard(context, ref, themeMode)
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
          const SizedBox(height: 24),

          // Account section
          _buildSectionHeader(context, 'Account', Iconsax.user)
              .animate()
              .fadeIn(delay: 200.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          _buildAccountCard(context, ref)
              .animate()
              .fadeIn(delay: 300.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
          const SizedBox(height: 24),

          // General section
          _buildSectionHeader(context, 'General', Iconsax.setting_2)
              .animate()
              .fadeIn(delay: 250.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          _buildGeneralCards(context)
              .animate()
              .fadeIn(delay: 350.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
          const SizedBox(height: 24),

          // Data section
          _buildSectionHeader(context, 'Data', Iconsax.data)
              .animate()
              .fadeIn(delay: 200.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          _buildDataCards(context, ref)
              .animate()
              .fadeIn(delay: 300.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
          const SizedBox(height: 24),

          // About section
          _buildSectionHeader(context, 'About', Iconsax.info_circle)
              .animate()
              .fadeIn(delay: 400.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          _buildAboutCard(context)
              .animate()
              .fadeIn(delay: 500.ms, duration: 300.ms)
              .slideX(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    return Card(
      child: Column(
        children: [
          _buildThemeOption(
            context,
            ref,
            title: 'System Default',
            subtitle: 'Follow system theme',
            icon: Iconsax.mobile,
            mode: ThemeMode.system,
            currentMode: currentMode,
          ),
          const Divider(height: 1, indent: 56),
          _buildThemeOption(
            context,
            ref,
            title: 'Light Mode',
            subtitle: 'Light background',
            icon: Iconsax.sun_1,
            mode: ThemeMode.light,
            currentMode: currentMode,
          ),
          const Divider(height: 1, indent: 56),
          _buildThemeOption(
            context,
            ref,
            title: 'Dark Mode',
            subtitle: 'Dark background',
            icon: Iconsax.moon,
            mode: ThemeMode.dark,
            currentMode: currentMode,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentMode == mode;

    return ListTile(
      leading: Icon(icon, color: isSelected ? theme.colorScheme.primary : null),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(Iconsax.tick_circle5, color: theme.colorScheme.primary)
          : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
      },
    );
  }

  Widget _buildGeneralCards(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Iconsax.category),
            title: const Text('Categories'),
            subtitle: const Text('Manage your task categories'),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () => context.push(AppRoutes.categories),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCards(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Iconsax.trash),
            title: const Text('Clear Completed Tasks'),
            subtitle: const Text('Remove all completed tasks'),
            onTap: () => _showClearCompletedDialog(context, ref),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: Icon(Iconsax.warning_2, color: theme.colorScheme.error),
            title: Text(
              'Reset All Data',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            subtitle: const Text('Delete all tasks and categories'),
            onTap: () => _showResetDataDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Iconsax.info_circle),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Iconsax.code),
            title: const Text('Built with'),
            subtitle: const Text('Flutter & Riverpod'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Iconsax.profile_circle),
            title: Text(
              authState.user?.email ?? 'Not Signed In',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(authState.user?.name ?? 'Guest'),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: Icon(Iconsax.logout, color: theme.colorScheme.error),
            title: Text(
              'Logout',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  void _showClearCompletedDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed Tasks'),
        content: const Text(
          'This will permanently delete all completed tasks. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(taskListProvider.notifier).deleteCompletedTasks();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Completed tasks cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showResetDataDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Iconsax.warning_2, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            const Text('Reset All Data'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your tasks and categories. '
          'This action cannot be undone.\n\n'
          'Are you absolutely sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(taskListProvider.notifier).deleteAllTasks();
              ref.read(categoryListProvider.notifier).resetCategories();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been reset'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }
}
