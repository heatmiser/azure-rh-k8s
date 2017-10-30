#!/bin/bash

echo $(date) " - Starting Script"

set -e

SUDOUSER=$1
PASSWORD="$2"
PRIVATEKEY=$3
MASTER=$4
MASTERPUBLICIPHOSTNAME=$5
MASTERPUBLICIPADDRESS=$6
NODE=$7
NODECOUNT=$8
MASTERCOUNT=$9
ROUTING=${10}
REGISTRYSA=${11}
ACCOUNTKEY="${12}"
METRICS=${13}
LOGGING=${14}
TENANTID=${15}
SUBSCRIPTIONID=${16}
AADCLIENTID=${17}
AADCLIENTSECRET="${18}"
RESOURCEGROUP=${19}
LOCATION=${20}
STORAGEACCOUNT1=${21}
STORAGEACCOUNT2=${22}
SAKEY1=${23}
SAKEY2=${24}
COCKPIT=${25}

BASTION=$(hostname)

MASTERLOOP=$((MASTERCOUNT - 1))
NODELOOP=$((NODECOUNT - 1))

# Create Container in PV Storage Accounts
echo $(date) " - Creating container in PV Storage Accounts"

azure telemetry --disable
azure login --service-principal -u $AADCLIENTID -p $AADCLIENTSECRET --tenant $TENANTID

azure storage container create -a $STORAGEACCOUNT1 -k $SAKEY1 --container vhds
azure storage container create -a $STORAGEACCOUNT2 -k $SAKEY2 --container vhds

# Generate private keys for use by Ansible
echo $(date) " - Generating Private keys for use by Ansible for Kubernetes Installation"

echo "Generating Private Keys"

runuser -l $SUDOUSER -c "echo \"$PRIVATEKEY\" > ~/.ssh/id_rsa"
runuser -l $SUDOUSER -c "chmod 600 ~/.ssh/id_rsa*"

echo "Configuring SSH ControlPath to use shorter path name"

sed -i -e "s/^# control_path = %(directory)s\/%%h-%%r/control_path = %(directory)s\/%%h-%%r/" /etc/ansible/ansible.cfg
sed -i -e "s/^#host_key_checking = False/host_key_checking = False/" /etc/ansible/ansible.cfg
sed -i -e "s/^#pty=False/pty=False/" /etc/ansible/ansible.cfg

# Create Ansible Playbooks for Post Installation tasks
echo $(date) " - Create Ansible Playbooks for Post Installation tasks"

echo $(date) " - Script complete"
