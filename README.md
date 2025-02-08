# k9s image

This project started as an attempt to create a `k9s` container that runs as a
non-root user. The one provided by the k9s project
(https://hub.docker.com/r/derailed/k9s) runs as root. A few additional features
have since been added.

## Editor

When editing resources in `k9s` the default editor is `vi`. This container
has `vim` installed and uses that instead.

## Plugins

The following plugins have been added to `k9s`.

* Local Shell: `Ctrl-L` will open a shell in the docker container. The
  `$KUBECONFIG` environment variable is set to the same value used by `k9s`.
  This is useful for ad-hoc kubectl commands and is available in all views.
* JLV: `Ctrl-J` will download the log of the currently selected container and
  open it in [jvl](http://github.com/mrxk/jvl).
  
## Run

```bash
docker run --rm -it -v ${path_to_kubeconfig}:/home/k9s/.kube/config ghcr.io/mrxk/k9s-non-root:main
```
