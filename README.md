# Flaked nix packaging for jenkinsfile-runner 

This repo contain nix backed packages useful for testing Jenkins
pipelines locally.

1. Install required plugins

```sh
$ mkdir plugins/
$ nix run ".#plugin-installation-manager" -L -- -d plugins -f examples/plugins.txt  
```

2 Run jenkins pipeline

```sh
$ nix run ".#" -- -p plugins -f examples
```

All commands should be runnable directly from GitHub (but you need have plugin.txt locally)

```sh
$ nix run "github:avnik/jenkinsfile-runner-nix" -- -p plugins -f examples
```

NOTE: this flake also testbed for self-runnable flakes, new CI options (cicero?), etc
