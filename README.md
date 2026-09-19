# ♻️ EcoCollect

Application mobile **Flutter** de gestion des déchets : collectes, points de tri, conseils éco-responsables et signalement d'incidents (dépôts sauvages, poubelles débordées, collectes non effectuées).

> **Formation** : D-CLIC Niveau Approfondi Développeur Mobile Flutter
> **Version** : 2.0

---

## 🎯 Objectif

EcoCollect vise à **centraliser la gestion des déchets au niveau d'une commune** :
- informer les citoyens des **prochaines collectes** et des **points de tri** disponibles,
- proposer des **conseils éco-responsables**,
- permettre de **signaler un incident** (dépôt sauvage, poubelle débordée…) avec photo, description et localisation GPS,
- suivre le **statut des signalements** et leurs détails.

## ✨ Fonctionnalités

- 🔐 **Authentification** par e-mail + mot de passe (se connecter / créer un compte) via **Firebase Authentication**
- 🏠 **Accueil** avec profil, prochaine collecte et raccourcis
- 🗓️ **Collectes** : liste des prochaines collectes avec zone, date et heure
- ♻️ **Points de tri** : liste des points de collecte avec adresses et types acceptés (recherche)
- 💡 **Conseils** éco-responsables classés par catégorie (tri, eau, énergie) avec recherche
- 📍 **Localisation GPS** et adresse lisible (reverse geocoding) via **Google Maps**
- 📋 **Signalements** : création (type + photo + description + GPS), liste, détails et suppression
- 🌙 **Mode sombre / clair**
- 🔄 **Données temps réel** synchronisées sur **Cloud Firestore**
- 📷 **Photos** des signalements hébergées sur **Firebase Storage**

## 🧱 Technologie et packages utilisés

| Domaine | Package | Version |
|---------|---------|---------|
| Framework | Flutter (Material 3) | SDK Dart `^3.13` |
| Gestion d'état | flutter_riverpod | `^3.4.3` |
| Base Firebase | firebase_core | `^4.15.0` |
| Authentification | firebase_auth | `^6.7.0` |
| Base de données | cloud_firestore | `^6.10.0` |
| Stockage photos | firebase_storage | `^13.6.0` |
| Carte | google_maps_flutter | `^2.18.1` |
| Localisation | geolocator | `^14.0.3` |
| Reverse geocoding | geocoding | `^5.0.0` |
| Images | image_picker | `^1.2.3` |
| Préférences locales | shared_preferences | `^2.5.5` |
| Dates | intl | `^0.20.3` |
| Identifiants | uuid | `^4.6.0` |
| Tests | flutter_test + mocktail | mocktail `^1.0.5` |
| Icône | flutter_launcher_icons | `^0.14.4` |

## 🗂️ Architecture

L'application suit une **architecture en couches** inspirée de Clean Architecture, adaptée à un projet d'1 semaine :

```
lib/
├── main.dart                  # Firebase.initializeApp + ProviderScope
├── app.dart                   # MaterialApp, thème, navigation
├── firebase_options.dart      # configuration Firebase générée
├── core/                      # constants, theme, utils (validators, errors)
├── data/
│   ├── models/                # entités (Collection, Report, Tip, User…)
│   ├── mappers/               # conversion Firestore ⇄ modèles
│   ├── services/              # implémentations Firebase (auth, firestore, storage…)
│   └── repositories/          # contrats + implémentations (User, Report, Collection…)
├── domain/
│   └── services/              # contrats métier (auth, location, image, geocoding)
└── presentation/
    ├── providers/             # Riverpod (état de l'application)
    ├── screens/               # écrans (E01–E10)
    └── widgets/               # widgets réutilisables
```

Flux : `UI → Provider Riverpod → Repository → Mappers → Firestore ↔ Cloud`.

## 📦 Installation

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installé et dans le `PATH`
- Android Studio + un **émulateur Android** ou un **appareil Android** avec le débogage USB activé
- Un projet **Firebase** créé (voir « Configuration Firebase » ci-dessous)

### Étapes

1. Cloner le dépôt :
   ```bash
   git clone https://github.com/delvapatrick25-beep/EcoCollect.git
   cd EcoCollect
   ```
2. Installer les dépendances :
   ```bash
   flutter pub get
   ```
3. Configurer Firebase :
   - Créer un projet dans la [console Firebase](https://console.firebase.google.com) (plan Spark, gratuit)
   - Ajouter l'application **Android** (package `com.ecocollect.app`)
   - Activer **Authentication → E-mail / Mot de passe**
   - Créer **Cloud Firestore** (mode production) et le bucket **Cloud Storage**
   - Placer les fichiers :
     - `android/app/google-services.json`
   - Générer `lib/firebase_options.dart` :
     ```bash
     dart run flutterfire configure
     ```

## ▶️ Lancement de l'application

1. Lister les appareils disponibles :
   ```bash
   flutter devices
   ```
2. Lancer l'application sur un appareil précis :
   ```bash
   flutter run -d <id_de_l_appareil>
   ```
   Ou simplement :
   ```bash
   flutter run
   ```
3. Une fois lancée, raccourcis utiles :
   - `r` → **hot reload** (recharge l'UI)
   - `R` → **hot restart**
   - `q` → quitter

Pour générer un **APK de production** :
```bash
flutter build apk --release
```

## 🧪 Tests réalisés

**28 tests** — tous au vert (`flutter analyze` : 0 erreur / 0 warning).

| Suite | Fichier | Nombre | Couverture |
|-------|---------|--------|-----------|
| Tests unitaires | `test/unit/authentification_test.dart` | 19 | Validators (email, mot de passe, pseudo, description) + mappage des erreurs Firebase (`mapAuthError`) |
| Tests widget | `test/widget/authentification_screen_test.dart` | 6 | Écran d'authentification E02 (mode Connexion/Inscription, validations, erreur serveur) |
| Tests widget | `test/widget_test.dart` | 2 | Splash E01 et accueil E03 |
| Test d'intégration | `test/test_integrations/parcours_signalement_test.dart` | 1 | Parcours complet : inscription → accueil → création d'un signalement → détails → suppression |

Les fakes partagés sont dans `test/helpers/fakes.dart` (basés sur **mocktail**).

Pour relancer les tests :
```bash
flutter test
```
Pour l'analyse statique :
```bash
flutter analyze
```

## 📸 Captures d'écran

Les captures d'écran de l'application sont incluses dans **le document final de présentation et mode d'utilisation du projet**.

## ⚠️ Difficultés rencontrées

Les difficultés rencontrées et les solutions apportées sont détaillées dans **le document final de présentation et mode d'utilisation du projet**.

## 👤 Auteur

- **DELVA Patrick** — Développeur mobile **Flutter**
- Formation : **D-CLIC Niveau Approfondi Développeur Mobile Flutter**
- Dépôt : [github.com/delvapatrick25-beep/EcoCollect](https://github.com/delvapatrick25-beep/EcoCollect)