#!/usr/bin/env bash

source /opt/jupyterhub/bin/activate

jupyterhub -f /home/jhrole/jupyterhub_config.py --JupyterHub.spawner_class=sudospawner.SudoSpawner
