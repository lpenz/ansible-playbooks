#!/bin/bash

set -e -x

ansible-playbook -i localhost, -c local playbook-facts.yml
