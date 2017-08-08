## Setup Kubernetes in Ubuntu 16.04 on Joyent Triton

This will setup Kubernetes using `kubeadm` on a single node. See [this link](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) for more details.

## Prereqs
1. Terraform: [Setup instructions](https://www.terraform.io/intro/getting-started/install.html)


## Required variables for deploying in Triton

Create a file called `secret.tfvars` and specify the following

```
# Your account in Triton
account = "myaccount"

# Path to your SSH key
key_file = "/home/myaccount/.ssh/id_rsa"

# SSH Key hash
key_hash = "b0:d6:6c:f7:d4:8c:dc:d8:64:aa:aa:aa:aa:aa:aa:aa"

# Your Triton API endpoint
endpoint_url = "https://cloudapi.triton.eu"

# If TLS should be skipped
skip_tls_verify = "true"

# Image for Ubuntu 16.04
image = "554abb2e-a957-aaaa-aaaa-97c934eadf33"

# Package to use, should have at least 16 GB RAM
package = "balanced.huge"
```

To get your ssh key md5 hash, use the following:
```
ssh-keygen  -l -E md5 -f /home/my-account/.ssh/id_rsa.pub
2048 MD5:b0:d6:6c:f7:d4:8c:dc:d8:64:aa:aa:aa:aa:aa:aa:aa no comment (RSA)
```