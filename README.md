[![CI](https://github.com/lpenz/ansible-playbooks/actions/workflows/ci.yml/badge.svg)](https://github.com/lpenz/ansible-playbooks/actions/workflows/ci.yml)

# lpenz ansible provisioner

This repository store an ansible provisioner that configures my environments in
a given Linux system. It is based on ansible-pull operation.

- My user configuration, with everything that does not require X:

  ```shell
  ansible-playbook -i localhost, -c local -u "$USER" playbook-user-term.yml
  ```

  Or, remotely (no download required):

  ```shell
  ansible-pull -U https://github.com/lpenz/ansible-playbooks.git -i localhost, -c local -u "$USER" playbook-user-term.yml
  ```

- Configurations that require sudo, mostly installing packages and
  repositories - including
  my [apt repository](https://packagecloud.io/lpenz/lpenz)
  at [packagecloud.io](https://packagecloud.io):

  ```shell
  ansible-playbook -i localhost, -c local playbook-sudo-term.yml -K
  ```

  Or, remotely (no download required):

  ```shell
  ansible-pull -U https://github.com/lpenz/ansible-playbooks.git -i localhost, -c local playbook-sudo-term.yml -K
  ```

- Configurations that require X, in the same order:
  ```shell
  ansible-playbook -i localhost, -c local playbook-user-x.yml -K
  ansible-pull -U https://github.com/lpenz/ansible-playbooks.git -i localhost, -c local -u "$USER" playbook-user-x.yml -K
  ansible-playbook -i localhost, -c local playbook-sudo-x.yml -K
  ansible-pull -U https://github.com/lpenz/ansible-playbooks.git -i localhost, -c local playbook-sudo-x.yml -K
  ```

