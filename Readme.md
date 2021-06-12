# Spinnaker Halyard Container

You can start halyard container with bellow command.

```bash
docker run --name halyard --rm --network host  -v ~/.hal:/home/spinnaker/.hal \
-v ~/.kube/:/home/spinnaker/.kube -v ~/.kube/:/root/.kube -v ~/.minikube/:/root/.minikube -it ghcr.io/ahmetozer/halyard-container
```

If you want to use with minikube, you can visit [https://ahmetozer.org/Installing-Spinnaker-on-Minikube.html](https://ahmetozer.org/Installing-Spinnaker-on-Minikube.html) for installing guide.
