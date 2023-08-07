#!/bin/bash


function setup_centos_mirror() {
  cd /etc/yum.repos.d/
  sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
}

function dev_tools() {
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  yum install -y neovim python3-neovim
}

function main() {
  setup_centos_mirror
}

main
