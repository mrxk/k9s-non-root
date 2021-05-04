# k9s image

This project exists to create a k9s container that runs as a non-root user. The
one provided by the k9s project (https://hub.docker.com/r/derailed/k9s) runs as
the root user.

## Build

```bash
docker pull derailed/k9s
docker build . -t k9s
```

## Run

```bash
run --rm -it -v ${path_to_kubeconfig}:/home/k9s/.kube/config k9s
```

