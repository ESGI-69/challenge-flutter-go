# Golang Backend

Si vous souhaitez utiliser le backend sans passer par la version déployée sur https://jppduphp.uk/ ou sans utiliser k8s comme expliqué dans le README.md de la racine du projet, vous pouvez suivre les instructions suivantes.

## Lancer localement

Avant toute chose, il faut installer les dépendances du projet en utilisant la commande `go get .` dans le dossier `backend`.

L'application peut etre lancé en utilisant la commande `go run main.go` dans le dossier `backend` sans oublier de lancer le serveur de base de données.

Il faut également utiliser les variables d'environnement pour configurer l'applications. Elles peuvent etre simplement copiées depuis le fichier `.env.example` et modifiées si besoin. Elle sont les suivantes:

| Variable | Description | Valeur par défaut |
| --- | --- | --- |
| `DB_HOST` | Adresse du serveur de base de données | `localhost` |
| `DB_PORT` | Port du serveur de base de données | `5432` |
| `DB_USER` | Utilisateur de la base de données | `challenge_flutter_go` |
| `DB_PASSWORD` | Mot de passe de l'utilisateur de la base de données |  |
| `DB_NAME` | Nom de la base de données | `challenge_flutter_go` |
| `MODE` | Mode de l'application (`debug` ou `release`) | `debug` |
| `JWT_SECRET` | Clé secrète pour les tokens JWT |  |
| `FRONTEND_URL` | URL du frontend pour paramétrer les CORS si le `MODE` est `release` |  |
| `GOOGLE_API_KEY` | Clé d'API Google pour les services de géolocalisation |  |

Une fois l'application lancée localement, vous pouvez accéder à l'API à l'adresse `http://localhost:8080`.

## Swagger

Le swagger du serveur de production est accessible à l'adresse `https://jppduphp.uk/swagger/index.html`.

Pour générer la documentation Swagger, il suffit d'utiliser la commande `swag init` dans le dossier `backend`. La documentation est ensuite accessible à l'adresse `http://localhost:8080/swagger/index.html`.

## Tests

Pour lancer les tests, il suffit d'utiliser la commande `go test ./...` dans le dossier `backend`.
