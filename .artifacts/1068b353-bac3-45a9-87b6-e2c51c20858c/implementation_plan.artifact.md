# Plan d'Amélioration UI/UX EcoCollect - Phase 1 : Infrastructure Essentielle

Ce plan vise à transformer l'interface fonctionnelle d'EcoCollect en une expérience moderne et professionnelle en s'appuyant sur Material 3, tout en conservant l'identité visuelle existante.

## User Review Required

> [!IMPORTANT]
> Les modifications de la Phase 1 impactent l'apparence globale de l'application (boutons, champs, cartes). Bien que le branding soit conservé, le ressenti visuel sera plus "doux" et moderne (coins arrondis plus marqués, surfaces tonales).

## Proposed Changes

### [Core] Design System & Thème

#### [MODIFY] [app_theme.dart](file:///C:/Users/guers/Desktop/D-CLIC%20(DEVMOBILE@2026)/JUILLET-AOUT%202026/SESSION%206/PROJET%20FINALE/ecocollect/lib/core/theme/app_theme.dart)
- Mise à jour du `ThemeData` pour inclure des thèmes de composants détaillés :
    - `CardTheme` : Coins arrondis à 24dp, élévation subtile.
    - `FilledButtonTheme` : Coins arrondis à 12-16dp, padding généreux.
    - `InputDecorationTheme` : Style "Filled" avec fond très léger pour une meilleure affordance.
    - `TextTheme` : Configuration des styles Material 3 (Headline, Title, Body).

#### [MODIFY] [app_colors.dart](file:///C:/Users/guers/Desktop/D-CLIC%20(DEVMOBILE@2026)/JUILLET-AOUT%202026/SESSION%206/PROJET%20FINALE/ecocollect/lib/core/theme/app_colors.dart)
- Ajout de variantes tonales pour mieux supporter les surfaces Material 3 sans changer les couleurs de base.

---

### [Screens] Refonte de l'Accueil (E03)

#### [MODIFY] [home_screen.dart](file:///C:/Users/guers/Desktop/D-CLIC%20(DEVMOBILE@2026)/JUILLET-AOUT%202026/SESSION%206/PROJET%20FINALE/ecocollect/lib/presentation/screens/home_screen.dart)
- Refonte de la hiérarchie de l'onglet Accueil :
    - Carte "Prochaine Collecte" : Transformation en composant "Hero" plus visuel.
    - Grille de raccourcis : Remplacement des bordures par des surfaces tonales et icônes plus grandes.
    - Amélioration des espacements et des typographies.

---

### [Layout] Standardisation et Cohérence

#### [MODIFY] [authentification_screen.dart](file:///C:/Users/guers/Desktop/D-CLIC%20(DEVMOBILE@2026)/JUILLET-AOUT%202026/SESSION%206/PROJET%20FINALE/ecocollect/lib/presentation/screens/authentification_screen.dart)
- Application du nouveau `InputDecorationTheme`.
- Amélioration du sélecteur de mode (SignIn/SignUp) pour être plus fluide.

#### [MODIFY] [nouveau_signalement_screen.dart](file:///C:/Users/guers/Desktop/D-CLIC%20(DEVMOBILE@2026)/JUILLET-AOUT%202026/SESSION%206/PROJET%20FINALE/ecocollect/lib/presentation/screens/nouveau_signalement_screen.dart)
- Mise en page plus aérée utilisant les nouvelles `Card`.

---

## Verification Plan

### Automated Tests
- Vérification du rendu visuel via `flutter run` (Manuel).

### Manual Verification
- Vérifier la cohérence des rayons de courbure sur tous les boutons.
- Tester la lisibilité des textes sur les nouveaux fonds de cartes.
- Valider que le passage entre les modes de connexion reste intuitif.
