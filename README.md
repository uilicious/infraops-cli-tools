# infraops-cli-tools
Collection of infrastructure CLI based tools, with environmental variable based version controls. Along with automated cross platform support.

This generally works by detecting the system at runtime, and downloading any needed binary in the process. This project does not depend (and intentionally avoids) any existing system installed binaries.

# Why use this?

When you need to constantly switch between different tool versions to support multiple infrastructure (eg. one in US, one in UK), that are NOT compatible with one another. 
In built binaries installed via the package manager starts to slowly break apart, and you may end up creating a complex mess of binaries that needs to be tracked and managed.

In overally this simplifies deployments, as you can easily spin up version specific binaries in a single line

```
KUBECTL_VERSION="v1.15.7" kubectl/kubectl.sh
```

# Tool Support Matrix

| Tool Name                                        | Version Environment Variable | Default Version | Script Path        |
|--------------------------------------------------|------------------------------|-----------------|--------------------|
| [kubectl](https://github.com/kubernetes/kubectl) | KUBECTL_VERSION              | v1.15.6         | kubectl/kubectl.sh |
| [rancher](https://github.com/rancher/cli)        | RANCHER_CLI_VERSION          | v2.3.1          | rancher/rancher.sh |

# Requirements

- linux bash 

# Notes

In general each tool is downloaded only on demand, this greatly reduce this overall project size to only the minimal bash glue script required.

# TODO

- [ ] Test and rollout alpine support
- [ ] Figure out a plan / schedule for updating the default versions to "stable" or "n-1" on a scheduled basis
- [ ] Ensure all scripts are resistent to extra (or lack of) `v` in `vX.Y.Z` prefix
- [ ] Add configami build support
