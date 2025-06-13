#!/usr/bin/env bash

# Before running this you need to have wget and bash installed with pkgin

set -e

pyver=${PYTHONSVERSION:-312}
pymver=${PYTHONVERSION:-3.12.9}

pkgin install git python${pyver}-${pymver} dmidecode sudo

git clone https://github.com/canonical/cloud-init.git
cd cloud-init
git checkout 25.1.2

pkgin install py${pyver}-configobj py${pyver}-jinja2 py${pyver}-oauthlib py${pyver}-requests py${pyver}-setuptools py${pyver}-yaml py${pyver}-jsonschema py${pyver}-pip

pkgin install qemu-guest-agent

python3.12 setup.py build
python3.12 setup.py install -O1 --distro netbsd --skip-build --init-system sysvinit_netbsd

sed -i.bak -e "/^cloud.*=.*/d" /etc/rc.conf
echo '
cloudinitlocal="YES"
cloudinit="YES"
cloudconfig="YES"
cloudfinal="YES"' >> /etc/rc.conf

# lock root account
usermod -C yes root