# dev-infra

This repository holds various patterns for deploying things on Condenser.

Generally, assuming you have your Kube config set up, and an SSH key in Rancher, you can do a deployment by editing `variables.tf` with appropriate settings for keys/namespaces/etc and doing:

```
terraform init
terraform apply
ansible-playbook -i generate_inventory.py full.yaml
```

The sole exception is the GPU stuff which doesn't have an automated terraform step and you need to generate a suitable inventory.