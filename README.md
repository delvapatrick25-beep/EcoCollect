# ♻️ EcoCollect

Application mobile **Flutter** de gestion des déchets : collectes, points de tri, conseils éco-responsables et signalement d'incidents (dépôts sauvages, poubelles débordées, collectes non effectuées).

> **Formation** : D-CLIC Niveau Approfondi Développeur Mobile Flutter
> **Version** : 2.0
> **Auteur** : DELVA Patrick

---

## 🚀 Fonctionnalités

- 🔐 **Authentification** par e-mail + mot de passe (se connecter / créer un compte) via **Firebase Authentication**
- 🏠 **Accueil** avec salutation, prochaine collecte et raccourcis
- 🗓️ **Collectes** : calendrier / liste des prochaines collectes
- ♻️ **Points de tri** : liste des points de collecte avec adresses
- 💡 **Conseils** eco-responsables classés par catégorie (tri, eau, énergie)
- 📋 **Signalements** : création d'un signalement (type + photo + description + GPS), suivi du statut et suppression
- 🔄 **Données temps réel** synchronisées sur **Cloud Firestore**
- 📷 **Photos** des signalements hébergées sur **Firebase Storage**

## 🧱 Stack technique

| Domaine | Choix |
|---------|-------|
| Framework | Flutter 3.47+ (Material 3) |
| Gestion d'état | flutter_riverpod (StreamProvider + StateNotifier) |
| Base de données | cloud_firestore |
| Authentification | firebase_auth (email + mot de passe) |
| Stockage photos | firebase_storage |
| Localisation | geolocator |
| Images | image_picker |
| Dates | intl |
| Identifiants | uuid |
| Tests | flutter_test + mocktail |
| Icône | flutter_launcher_icons |

## 🗂️ Architecture

L'application suit une **architecture en couches** inspirée de Clean Architecture, adaptée à un projet d'1 semaine :

```
lib/
├── main.dart                  # Firebase.initializeApp + ProviderScope
├── app.dart
├── core/                      # thème, constantes, utilitaires
├── data/                      # modèles, mappers Firestore, services, repositories
├── domain/                    # services métier (auth, location, image)
└── presentation/              # screens (E01–E09), widgets, providers Riverpod
```

Flux : `UI → Provider Riverpod → Repository → Mappers → Firestore ↔ Cloud`.

> 📄 Conception complète : racine du dépôt, dossier `conception/` (docs 01 → 16).

## 🔥 Configuration Firebase (à faire manuellement)

1. Créer un projet dans la [console Firebase](https://console.firebase.google.com) (plan Spark, gratuit).
2. Ajouter l'application **Android** (package `com.ecocollect.app`) puis **iOS**.
3. Activer **Authentication → E-mail / Mot de passe**.
4. Créer **Cloud Firestore** (mode production) et le bucket **Cloud Storage**.
5. Déployer les **règles de sécurité** des sections 07/15/09 de la conception.
6. Enraciner les fichiers :
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
7. Générer `firebase_options.dart` :
   ```bash
   dart run flutterfire configure
   ```
8. Démarrage du contenu : les données de démonstration ne sont pas encore chargées (phase suivante).

## 📦 Installation

```bash
flutter pub get
flutter run
```

## 🧪 Tests

```bash
flutter test
```

## 📖 Parcours utilisateur (résumé)

```
E01 Splash (2 s) → session ? → E02 Authentification ou E03 Accueil
E03 Accueil (shell 5 onglets) → E04/E05/E06/E08 → FAB → E07 Signalement → Confirmation → E08
E09 Détails d'un signalement (statut, suppression)
```

