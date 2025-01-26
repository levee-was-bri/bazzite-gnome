#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf install -y tmux tlp qemu qemu-kvm virt-manager fish neovim python3-neovim swappy breeze-icon-theme breeze-gtk plasma-breeze

dnf remove -y tuned tuned-ppd

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable libvirtd
systemctl enable tlp.service
systemctl mask systemd-rfkill.service systemd-rfkill.socket

# Signing
mkdir -p /etc/containers
mkdir -p /etc/pki/containers
mkdir -p /etc/containers/registries.d/

cp /tmp/policy.json /etc/containers/policy.json
cp /tmp/cosign.pub /etc/pki/containers/bazzite-gnome.pub
tee /etc/containers/registries.d/bazzite-gnome.yaml <<EOF
docker:
  ghcr.io/levee-was-bri/bazzite-gnome:
    use-sigstore-attachments: true
EOF

# mkdir -p /usr/etc/containers/
# cp /etc/containers/policy.json /usr/etc/containers/policy.json
