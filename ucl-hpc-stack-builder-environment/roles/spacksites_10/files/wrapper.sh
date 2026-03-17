#!/bin/bash

cd /home/ccspapp/Scratch/spack/0.23/hpc-spack
source spacksites/myriad-utilities/init-spacksites-rhel9.sh

eval $(spacksites/spacksites --config-file spacksites/settings/deploy_sites.ini spack-setup-env 2025-09)

"$@"
