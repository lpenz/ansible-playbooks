[![Build Status](https://travis-ci.org/lpenz/ansible-playbooks.svg?branch=master)](https://travis-ci.org/lpenz/ansible-playbooks)

lpenz ansible provisioner
=============================

This repository store an ansible provisioner that configures my environments in
a given Linux system. It is based on ansible-pull operation.

- My user configuration, with everything that does not require X:

  ```shell
  ansible-playbook -i localhost, playbook-user-term.yml
  ```

  Or, remotely (no download required):

  ```shell
  ansible-pull -U https://github.com/lpenz/ansible-playbooks.git -i localhost, playbook-user-term.yml
  ```

- Configurations that require sudo, mostly installing packages and
  repositories - including
  my [apt repository](https://packagecloud.io/lpenz/lpenz)
  at [packagecloud.io](https://packagecloud.io):

  ```shell
  ansible-playbook -i localhost, playbook-sudo-term.yml
  ```

  Or, remotely (no download required):

  ```shell
  ansible-pull -U https://github.com/lpenz/ansible-playbooks.git -i localhost, playbook-sudo-term.yml
  ```



