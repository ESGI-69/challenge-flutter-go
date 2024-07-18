# move_together_app

## APK Link
[Releases Link](https://github.com/ESGI-69/challenge-flutter-go/releases)

## Run the project
Copier le fichier `.env.example` en `.env` et remplissez les variables avec vos propres valeurs.
| Variable | Description | Valeur par défaut |
| --- | --- | --- |
| `API_ADDRESS` | Adresse du backend pour l'api | `localhost` |
| `WEBSOCKET_ADDRESS` | Adresse du backend pour les websockets  | `5432` |

Pour utiliser l'api google maps et afficher la carte, veuillez ajouter votre clé d'api dans `move_together_app/android/app/src/main/AndroidManifest.xml`


Ou run l'application avec votre IDE préféré avec cet argument : 
```
--dart-define GOOGLE_MAPS_API_KEY=<THEGOOGLEAPIKEY>
```
ou exécutez la commande (flutter run ou build) :
```
flutter run --dart-define GOOGLE_MAPS_API_KEY=<THEGOOGLEAPIKEY>
```
 
Dans certains cas, la carte peut toujours afficher une carte vide sans textures de terrain, si c'est le cas, utilisez la commande suivante avant d'exécuter l'application flutter
```
flutter clean
```

Commande pour mettre à jour l'icône de l'application :
```
flutter pub pub run flutter_launcher_icons:main
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Troubleshooting