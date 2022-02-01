#!/bin/bash

## NOTE: This Script is made for RHEL based VMs Only

## array of packages
declare -a pkgs=("iproute-tc" "stress-ng")

## Verifying & loading sch_netem package
if [[ ! -z $(lsmod | grep "sch_netem") ]]
then
    echo -e "\n[Info]: sch_netem module is already loaded\n"
else
    echo -e "\n[Info]: sch_netem module not loaded, checking if kernel-modules-extra package is installed...\n"
    if [[ ! -z $(rpm -aq kernel-modules-extra-$(uname -r)) ]]
    then
        echo -e "\n[Info]: kernel-modules-extra package is already installed\n"
    else
        echo -e "\n[Info]: kernel-modules-extra package NOT installed, Installing now..."
        sudo dnf install kernel-modules-extra-$(uname -r)
    fi
    echo -e "\n[Info]: Loading sch_netem kernel module..."
    sudo modprobe sch_netem
fi

## verifying & installing all required packages
for pkg in "${pkgs[@]}"
do
    if [[ ! -z $(rpm -aq $pkg) ]]
    then
        echo -e "\n[Info]: $pkg is already installed\n"
    else
        echo -e "\n[Info]: $pkg NOT installed, Installing now...\n"
        sudo dnf install -y $pkg
    fi
done