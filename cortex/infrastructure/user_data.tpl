#cloud-config

users:
- name: ubuntu
  shell: /bin/bash
  sudo:  ALL=(ALL) NOPASSWD:ALL
  ssh_authorized_keys:
  - ${ssh_keys}