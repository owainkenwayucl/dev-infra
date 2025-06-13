#!/usr/bin/env bash

# Before running this you need to have wget and bash installed with pkgin

set -e

pyver=${PYTHONSVERSION:-312}
pymver=${PYTHONVERSION:-3.12.9}

pkgin install git python${pyver}-${pymver} dmidecode sudo

git clone https://github.com/canonical/cloud-init.git
git cd cloud-init
git checkout 25.1.2

pkgin install ${pyver}-configobj ${pyver}-jinja2 ${pyver}-oauthlib ${pyver}-requests ${pyver}-setuptools ${pyver}-yaml ${pyver}-jsonschema ${pyver}-pip

pkgin install qemu-guest-agent

python3.12 setup.py build
python3.12 setup.py install -O1 --distro netbsd --skip-build --init-system sysvinit_netbsd

sed -i.bak -e "/^cloud.*=.*/d" /etc/rc.conf
echo '
cloudinitlocal="YES"
cloudinit="YES"
cloudconfig="YES"
cloudfinal="YES"' >> /etc/rc.conf

