# Application de Gestion des Absences Académiques

## 📱 Description

Cette application permet la gestion efficace des absences académiques pour les établissements d'enseignement. Développée avec Flutter pour le frontend et PHP pour le backend, elle offre une interface conviviale pour suivre, enregistrer et gérer les présences des étudiants.

## ✨ Fonctionnalités

- Enregistrement des présences et absences
- Consultation des statistiques d'assiduité
- Gestion des justificatifs d'absence
- Interface adaptative pour mobile et tablette
- Base de données sécurisée avec MySQL

## 📋 Prérequis

- [Flutter](https://flutter.dev/docs/get-started/install) (dernière version stable)
- [XAMPP](https://www.apachefriends.org/fr/index.html) (pour le serveur local et la base de données)
- Un éditeur de code comme [Visual Studio Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)

## 🚀 Installation et Configuration

### Configuration de la base de données

1. Installer XAMPP et démarrer les services Apache et MySQL
2. Accéder à phpMyAdmin via `http://localhost/phpmyadmin`
3. Créer une nouvelle base de données nommée `localconnect`
4. Importer le fichier `localconnect(1).sql` dans cette base de données

### Configuration du backend PHP

1. Placer le dossier `localconnectphp` dans le répertoire htdocs de XAMPP
   ```
   Exemple : C:\xampp\htdocs\localconnect
   ```

### Configuration de l'application Flutter

1. Créer un nouveau projet Flutter nommé `attendance_app`
   ```bash
   flutter create attendance_app
   ```
2. Remplacer le dossier `lib` du projet par celui fourni dans ce dépôt
3. Remplacer le fichier `pubspec.yaml` par celui fourni dans ce dépôt
4. Installer les dépendances
   ```bash
   flutter pub get
   ```

## 📝 Guide d'installation étape par étape

### Étape 1
Créer une base de données nommée `localconnect` dans MySQL via XAMPP.

### Étape 2
Importer le fichier `localconnect(1).sql` dans la base de données.

### Étape 3
Créer un nouveau projet Flutter nommé `attendance_app`.
```bash
flutter create attendance_app
```

### Étape 4
Remplacer le dossier `lib` de votre projet par notre dossier `lib`.

### Étape 5
Remplacer le fichier `pubspec.yaml` par le fichier fourni.

### Étape 6
Obtenir les dépendances en exécutant dans le terminal :
```bash
flutter pub get
```

### Étape 7
Placer le dossier `localconnectphp` dans le répertoire htdocs de XAMPP.
Exemple : `C:\xampp\htdocs\localconnect`

### Étape 8
Démarrer les services Apache et MySQL dans le panneau de contrôle XAMPP.

### Étape 9
Lancer votre projet Flutter :
```bash
flutter run
```

## 📊 Structure du projet

```
attendance_app/
├── lib/                    # Code source principal de l'application
│   ├── models/             # Modèles de données
│   ├── screens/            # Écrans de l'application
│   ├── services/           # Services (API, base de données)
│   ├── widgets/            # Widgets réutilisables
│   └── main.dart           # Point d'entrée de l'application
├── pubspec.yaml            # Configuration des dépendances
└── ...
```

## 🔍 Dépannage

- Vérifiez que les services XAMPP sont bien en cours d'exécution.
- Assurez-vous que l'adresse IP dans le code correspond à celle de votre ordinateur si vous utilisez un appareil physique pour tester.
- En cas de problème de connexion à la base de données, vérifiez les informations d'identification dans les fichiers de configuration PHP.

## 👥 Contributeurs

- [ZiadNajimDev](https://github.com/ZiadNajimDev)

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus d'informations.
