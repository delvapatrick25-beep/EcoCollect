import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/app_date_utils.dart';
import '../providers/collection_provider.dart';
import '../providers/tip_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_avatar.dart';
import 'collections_screen.dart';
import 'conseils_screen.dart';
import 'mes_signalements_screen.dart';
import 'nouveau_signalement_screen.dart';
import 'points_de_tri_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late int _selectedIndex = widget.initialIndex;
  late final PageController _pageController = PageController(initialPage: _selectedIndex);

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openNouveauSignalement() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NouveauSignalementScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _AccueilTab(
            onTabChanged: _onTabChanged,
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
  });

  final void Function(int) onTabChanged;

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: AppColors.textPrimary,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 20,
        title: InkWell(
          onTap: () => _openProfile(context),
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: UserAvatar(pseudo: user?.pseudo, radius: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user?.pseudo ?? 'Utilisateur',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 20,
                  color: AppColors.primary.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Votre impact commence ici.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 24),
            _buildNextCollectionCard(context, ref),
            const SizedBox(height: 16),
            _buildTipOfTheDayCard(context, ref),
            const SizedBox(height: 24),
            Text(
              'Raccourcis',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildShortcutsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextCollectionCard(BuildContext context, WidgetRef ref) {
    final nextAsync = ref.watch(nextCollectionProvider);

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      child: InkWell(
        onTap: () => onTabChanged(1),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.restore_from_trash,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROCHAINE COLLECTE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    nextAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => const Text('Erreur de chargement'),
                      data: (collection) => collection == null
                          ? const Text('Aucune collecte prévue')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  collection.typeDechet,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                ),
                                Text(
                                  '${AppDateUtils.formatShortDate(collection.date)} • ${collection.heure}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.primaryDark.withOpacity(0.7),
                                      ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipOfTheDayCard(BuildContext context, WidgetRef ref) {
    final tipAsync = ref.watch(tipOfTheDayProvider);

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      elevation: 0,
      child: InkWell(
        onTap: () => onTabChanged(3),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: AppColors.accent,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONSEIL DU JOUR',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.secondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    tipAsync.when(
                      loading: () => const SizedBox(height: 20),
                      error: (e, _) => const Text('Astuce écologique'),
                      data: (tip) => Text(
                        tip?.titre ?? 'Adoptez les bons gestes !',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.secondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _ShortcutTile(
          icon: Icons.event,
          label: 'Collectes',
          color: AppColors.primaryLight,
          onTap: () => onTabChanged(1),
        ),
        _ShortcutTile(
          icon: Icons.recycling,
          label: 'Points de tri',
          color: const Color(0xFFF1F8E9),
          onTap: () => onTabChanged(2),
        ),
        _ShortcutTile(
          icon: Icons.lightbulb,
          label: 'Conseils',
          color: const Color(0xFFFFF3E0),
          onTap: () => onTabChanged(3),
        ),
        _ShortcutTile(
          icon: Icons.assessment,
          label: 'Mes signalements',
          color: const Color(0xFFE3F2FD),
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
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
