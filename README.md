# Challenge Flutter Go

## Team
Gatien ANIZAN (@mrpinkcat)
Quentin PELTIER (@Timdev0)
Samuel GUENIER (@sguenier)
Yohan CENTANNI (@ycenta)

## Features
Back-end Notes (Quentin PELTIER)
Swagger auto generation for GO API (Quentin PELTIER)
Chat per Trip with socket.io (Quentin PELTIER)
Documents upload and download (Quentin PELTIER)
Profile Picture upload (Quentin PELTIER)
Feature Flipping Client Side (Quentin PELTIER)
Handle Back Office on Web (Quentin PELTIER)
Promote & Demote user in Back Office (Quentin PELTIER)

## Development

### Backend

Launch with VS Code debugger with /go folder openned

Copy `.env.example` to `.env.` & set the database IP for development. See **Deployment** for more info.

Install swag with this command
```bash
go install github.com/swaggo/swag/cmd/swag@latest
```

You may need to add the path to your .bashrc/.zshrc file
```bash
export PATH=$PATH:$(go env GOPATH)/bin
```

If you want to generate Swagger doc do this command in the go directory:
```bash
swag init -o ./api/docs
```

## Deployment

> All the following commands are executed in the `/k8s` directory.

- Create the namespace
  ```bash
  kubectl apply -f namespace.yaml
  ```

- Create the config map
  ```bash
  kubectl apply -f config-map.yaml
  ```

- Create secrets
  ```bash
  kubectl apply -f secrets.yaml
  ```

- Create the database service, deployment, persistent volume and persistent volume claim
  ```bash
  kubectl apply -f database-all.yaml
  ```

- Retrive the service IP
  ```bash
  kubectl get svc -n challenge-flutter-go
  ```
  You can also retrive it via k9s

> **You can now connect the database to an database client and view its contents.**

- Create the backend service & deployment
  
  > Internally, the backend service will connect to the database service using the service name `challenge-flutter-go-database` and the database port `5432`.

  ```bash
  kubectl apply -f backend-all.yaml
  ```

- Retrive the service IP
  ```bash
  kubectl get svc -n challenge-flutter-go
  ```

> **You can now use the cluster-ip to connect the backend service to an API client for testing the endpoints.**

## flutter 
To use the google maps api and show the map, please add the api key in `move_together_app/android/app/src/main/AndroidManifest.xml`
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