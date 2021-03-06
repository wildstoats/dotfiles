#!/usr/bin/env bash
# 
# I think it's time we blow this scene
# Get everybody and the stuff together
# Ok, three, two, one, let's jam!
# 
set -e

DEBIAN_FRONTEND=noninteractive
BASHRC_D=~/.bashrc.d
ASDF_VERSION=v0.8.1

# 
# Configure ~/.bashrc to source additional files
# 
grep -qxF "for f in $BASHRC_D/*.sh; do source \$f; done" ~/.bashrc || printf "for f in $BASHRC_D/*.sh; do source \$f; done\n\n" >> ~/.bashrc
mkdir -p "$BASHRC_D"
# Add a no-op script in case we end up not including any.  Without this sourcing ~/.bashrc.d from .bashrc breaks down
touch "$BASHRC_D/fnord.sh"

# Update aptitude packages
sudo apt-get update

#
# asdf - https://asdf-vm.com
# 
# Install asdf dependencies
sudo apt-get install -y \
  curl \
  git
# Install asdf
if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "$ASDF_VERSION"
fi
# Source asdf and asdf completions
cp bootstrap/00-asdf.sh "$BASHRC_D/00-asdf.sh"
# Source 00-asdf.sh
source "$BASHRC_D/00-asdf.sh"

# 
# Setup python via asdf
# 
# Install python dependencies
sudo apt-get install -y build-essential \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libssl-dev \
  libsqlite3-dev \
  libffi-dev
# Install python via asdf
if ! $(asdf plugin-list | grep -q "python"); then
  asdf plugin-add python
fi
asdf install python 3.8.6
asdf shell python 3.8.6
asdf reshim python

# 
# Setup python venv for Ansible
# 
rm -rf venv
python -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install wheel
pip install ansible
ansible --version

# 
# Install Ansible roles from Galaxy
# 
ansible-galaxy install markosamuli.asdf

# 
# Run Ansible provisioning
# 
ansible-playbook \
  --ask-become-pass \
  --connection=local \
  --inventory=ansible/inventory/$(hostname).yml \
  ansible/playbook.yml
