# infraops-cli-tools
Collection of infrastructure CLI based tools, with environmental variable based version controls. Along with automated cross platform support.

This generally works by detecting the system at runtime, and downloading any needed binary in the process. This project does not depend (and intentionally avoids) any existing system installed binaries.

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
