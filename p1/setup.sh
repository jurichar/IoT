#!/bin/bash


function setup_centos_mirror() {
  cd /etc/yum.repos.d/
  sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
  sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
}

function main() {
  setup_centos_mirror
}

main
