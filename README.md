# dotfiles

Deploy dotfiles and configure development environs using Ansible.

## Usage

3 ... 2 ... 1 ... `lets-jam.sh`

## Bootstrap

### ~/.bashrc.d/

All scripts in `~/.bashrc.d/` are sourced from `~/.bashrc`.  Put any scripts
you would like sourced in this directory.

### asdf

asdf is installed to manage the initial python install without relying on OS
packages.  It's also generally useful.

## Ansible

Inventory files correspond to the development environment being provisioned.
`hostname` is used to determine the inventory passed to ansible-playbook.

### apt_packages

Installs aptitude packages.

### asdf

Installs asdf plugins.

### keeagent

Sets up communication between WSL2 and KeeAgent using socat.
