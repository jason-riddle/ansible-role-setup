# Ansible Role: Setup

[![CI](https://github.com/jason-riddle/ansible-role-setup/workflows/CI/badge.svg?event=push)](https://github.com/jason-riddle/ansible-role-setup/actions?query=workflow%3ACI)

Basic system setup role for Debian-based systems.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    packages_to_install:
      - vim

List of packages to install on the system.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all

  roles:
    - jason_riddle.setup
```

## License

MIT
