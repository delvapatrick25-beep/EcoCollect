import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../data/models/user_account.dart';
import '../providers/collection_provider.dart';
import '../providers/recycling_point_provider.dart';
import '../providers/report_provider.dart';
import '../providers/service_providers.dart';
import '../providers/tip_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_avatar.dart';
import 'authentification_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _logout() async {
    await ref.read(authServiceProvider).signOut();
    if (!mounted) return;
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AuthentificationScreen()),
      (route) => false,
    );
  }

  Future<void> _editPseudo() async {
    final user = ref.read(userProvider).value;
    if (user == null) return;

    final controller = TextEditingController(text: user.pseudo);
    final newPseudo = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Modifier le pseudo'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Pseudo',
              hintText: 'Votre pseudo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (newPseudo == null || newPseudo.isEmpty || newPseudo == user.pseudo) {
      return;
    }

    try {
      await ref
          .read(userRepositoryProvider)
          .save(user.copyWith(pseudo: newPseudo));
      if (!mounted) return;
      SnackBarUtils.showSuccess(context, 'Pseudo mis à jour !');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showError(context, 'Erreur lors de la mise à jour');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value;
    final themeAsync = ref.watch(themeModeProvider);
    final isDark = themeAsync.value == ThemeMode.dark;
    final reportCount = ref.watch(reportProvider).value?.length ?? 0;
    final pointCount = ref.watch(recyclingPointProvider).value?.length ?? 0;
    final tipCount = ref.watch(tipProvider).value?.length ?? 0;
    final collectionCount = ref.watch(collectionProvider).value?.length ?? 0;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          _buildHeader(context, user, colorScheme),
          const SizedBox(height: 24),
          _sectionTitle(context, 'Compte', colorScheme),
          _buildAccountCard(user, colorScheme),
          const SizedBox(height: 24),
          _sectionTitle(context, 'Apparence', colorScheme),
          _buildAppearanceCard(isDark, themeAsync.isLoading, colorScheme),
          const SizedBox(height: 24),
          _sectionTitle(context, 'Mes activités', colorScheme),
          _buildStatsRow(
            colorScheme: colorScheme,
            reportCount: reportCount,
            pointCount: pointCount,
            tipCount: tipCount,
            collectionCount: collectionCount,
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'À propos', colorScheme),
          _buildAboutCard(colorScheme),
          const SizedBox(height: 32),
          _buildLogoutButton(colorScheme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserAccount? user, ColorScheme colorScheme) {
    final pseudo = user?.pseudo ?? '';
    final email = user?.email ?? '';

    return Row(
      children: [
        UserAvatar(pseudo: pseudo, radius: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pseudo.isEmpty ? 'Utilisateur' : pseudo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                email.isEmpty ? '—' : email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: colorScheme.secondary,
            ),
      ),
    );
  }

  Widget _buildAccountCard(UserAccount? user, ColorScheme colorScheme) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.badge_outlined, color: colorScheme.primary),
            title: const Text('Pseudo'),
            subtitle: Text(user?.pseudo ?? '—'),
            trailing: Icon(Icons.edit_outlined, color: colorScheme.primary),
            onTap: _editPseudo,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: Icon(Icons.email_outlined, color: colorScheme.primary),
            title: const Text('Adresse e-mail'),
            subtitle: Text(user?.email ?? '—'),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: Icon(
              Icons.calendar_today_outlined,
              color: colorScheme.primary,
            ),
            title: const Text('Membre depuis'),
            subtitle: Text(
              user == null
                  ? '—'
                  : AppDateUtils.formatLongDate(user.createdAt.toLocal()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(bool isDark, bool loading, ColorScheme colorScheme) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          color: colorScheme.tertiary,
        ),
        title: const Text('Mode sombre'),
        subtitle: const Text('Basculez entre clair et sombre'),
        value: isDark,
        onChanged: loading
            ? null
            : (value) => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
      ),
    );
  }

  Widget _buildStatsRow({
    required ColorScheme colorScheme,
    required int reportCount,
    required int pointCount,
    required int tipCount,
    required int collectionCount,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: [
            _Stat(colorScheme: colorScheme, icon: Icons.assessment, count: reportCount, label: 'Signalements'),
            _Stat(colorScheme: colorScheme, icon: Icons.recycling, count: pointCount, label: 'Points de tri'),
            _Stat(colorScheme: colorScheme, icon: Icons.lightbulb, count: tipCount, label: 'Conseils'),
            _Stat(colorScheme: colorScheme, icon: Icons.event, count: collectionCount, label: 'Collectes'),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(ColorScheme colorScheme) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.eco, color: colorScheme.primary),
        title: Text(AppConstants.appName),
        subtitle: const Text('Version 1.0.0 • Votre assistant éco-responsable'),
      ),
    );
  }

  Widget _buildLogoutButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout),
        label: const Text('Se déconnecter'),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,
          side: BorderSide(color: colorScheme.error),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.colorScheme,
    required this.icon,
    required this.count,
    required this.label,
  });

  final ColorScheme colorScheme;
  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary, size: 22),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}