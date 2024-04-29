# Challenge Flutter Go

## Development

### Backend

Launch with VS Code debugger with /go folder openned

Copy `.env.example` to `.env.` & set the database IP for development. See **Deployment** for more info.

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
