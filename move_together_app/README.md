# move_together_app

## APK Link
[Releases Link](https://github.com/ESGI-69/challenge-flutter-go/releases)

## Run the project
Copy the `.env.example` file to `.env` and fill the variables with your own values.

To use the google maps api and show the map, please add your api key in `move_together_app/android/app/src/main/AndroidManifest.xml`

Or run the app with your favorite IDE with this argument
```
--dart-define GOOGLE_MAPS_API_KEY=<THEGOOGLEAPIKEY>
```
or run the command (flutter run or build)
```
flutter run --dart-define GOOGLE_MAPS_API_KEY=<THEGOOGLEAPIKEY>
```

In some cases, the map might still show a blank map with no terrain textures, if so, use the following command before running the flutter app 
```
flutter clean
```

Command to update the app icon :
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