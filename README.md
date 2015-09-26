

lpenz ansible provisioner
=============================

This repository store an ansible provisioner that configures my environments in
a given Linux system. It is based on ansible-pull operation.

My user configuration, no X:
```shell
ansible-playbook -i localhost, playbook-lpenz-nox.yml
```

Or, remotely (no download required):
```shell
ansible-pull -U https://github.com/lpenz/ansible-playbooks.git -i localhost, playbook-lpenz-nox.yml
```


