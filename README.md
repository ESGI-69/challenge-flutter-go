# Challenge Flutter Go

## Deployment

> All the following commands are executed in the `/k8s` directory.

- Create the namespace
  ```bash
  kubectl apply -f namespace.yaml
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
  kubectl get svc -n flutter-go
  ```
  You can also retrive it via k9s

**You can now connect the database to an database client and view its contents.**
