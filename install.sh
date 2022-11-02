#!/bin/bash

set -e

function have {
  command -v "$1" &> /dev/null
}

# Install ansible & plugins
have ansible || pip install --user ansible

[ -d ~/.ansible/collections/ansible_collections/community ] || \
  ansible-galaxy collection install community.general

# Run Ansible
ansible-playbook -i ./ansible/hosts ./ansible/linux.yml --ask-become-pass
