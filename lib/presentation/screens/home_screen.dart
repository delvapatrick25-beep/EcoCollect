import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/app_date_utils.dart';
import '../providers/collection_provider.dart';
import '../providers/service_providers.dart';
import '../providers/user_provider.dart';
import '../widgets/loading_widget.dart';
import 'authentification_screen.dart';
import 'collections_screen.dart';
import 'conseils_screen.dart';
import 'mes_signalements_screen.dart';
import 'nouveau_signalement_screen.dart';
import 'points_de_tri_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late int _selectedIndex = widget.initialIndex;

  void _onTabChanged(int index) => setState(() => _selectedIndex = index);

  void _openNouveauSignalement() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NouveauSignalementScreen()),
    );
  }

  Future<void> _logout() async {
    await ref.read(authServiceProvider).signOut();
    if (!mounted) return;
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AuthentificationScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _AccueilTab(
            onTabChanged: _onTabChanged,
            onLogout: _logout,
          ),
          const CollectionsScreen(),
          const PointsDeTriScreen(),
          const ConseilsScreen(),
          const MesSignalementsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabChanged,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event, color: AppColors.primary),
            label: 'Collectes',
          ),
          NavigationDestination(
            icon: Icon(Icons.recycling_outlined),
            selectedIcon: Icon(Icons.recycling, color: AppColors.primary),
            label: 'Tri',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb, color: AppColors.primary),
            label: 'Conseils',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment, color: AppColors.primary),
            label: 'Signalements',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNouveauSignalement,
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Signaler'),
      ),
    );
  }
}

class _AccueilTab extends ConsumerWidget {
  const _AccueilTab({
    required this.onTabChanged,
    required this.onLogout,
  });

  final void Function(int) onTabChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.recycling, color: Colors.white, size: 22),
            SizedBox(width: 6),
            Text(
              'EcoCollect',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Déconnexion',
            onPressed: onLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour ${user?.pseudo ?? ''} ! 👋',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Que souhaitez-vous faire ?',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              _buildNextCollectionCard(ref),
              const SizedBox(height: 20),
              _buildShortcutsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextCollectionCard(WidgetRef ref) {
    final nextAsync = ref.watch(nextCollectionProvider);

    return InkWell(
      onTap: () => onTabChanged(1),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PROCHAINE COLLECTE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  nextAsync.when(
                    loading: () => const SizedBox(
                      height: 20,
                      child: Center(child: LoadingWidget()),
                    ),
                    error: (e, _) => const Text(
                      'Impossible de charger',
                      style: TextStyle(color: AppColors.error),
                    ),
                    data: (collection) => collection == null
                        ? const Text(
                            'Aucune collecte à venir',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🗑️ ${collection.typeDechet}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${AppDateUtils.formatShortDate(collection.date)}'
                                ' · ${collection.heure}'
                                ' · ${collection.zone}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF558B2F),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.8,
      children: [
        _ShortcutTile(
          icon: Icons.event_outlined,
          label: 'Collectes',
          onTap: () => onTabChanged(1),
        ),
        _ShortcutTile(
          icon: Icons.recycling_outlined,
          label: 'Points de tri',
          onTap: () => onTabChanged(2),
        ),
        _ShortcutTile(
          icon: Icons.lightbulb_outline,
          label: 'Conseils',
          onTap: () => onTabChanged(3),
        ),
        _ShortcutTile(
          icon: Icons.assessment_outlined,
          label: 'Mes signalements',
          onTap: () => onTabChanged(4),
        ),
      ],
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}