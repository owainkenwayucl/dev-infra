#!/usr/bin/env python3

import json
import subprocess
import argparse

def run(command):
    return subprocess.run(command, capture_output=True, encoding='UTF-8')

def generate_inventory():
    host_vars = {}
    
    command = "terraform output --json mgmt_vm_ips".split()
    ip_data = json.loads(run(command).stdout)

    mgmt_nodes = []
    counter = 0
    for a in ip_data:
        name = a
        host_vars[name] = { "ip": [a] }
        mgmt_nodes.append(name)
        counter += 1


    command = "terraform output --json service_vm_ips".split()
    ip_data = json.loads(run(command).stdout)
    service_node = ip_data.pop()
    host_vars[service_node] = { "ip": [service_node] }

    counter = 0
    workers = []

    command = "terraform output --json worker_vm_ips".split()
    ip_data = json.loads(run(command).stdout)

    for a in ip_data:
        name = a
        host_vars[name] = { "ip": [a] }
        workers.append(name)
        counter += 1

    _meta = {}
    _meta["hostvars"] = host_vars
    _all = { "children": ["mgmtnodes", "servicenode", "workers"] }

    _workers = { "hosts": workers }
    _servicenode = { "hosts": [service_node] }
    _mgmtnodes = { "hosts" : mgmt_nodes }

    _jd = {}
    _jd["_meta"] = _meta
    _jd["all"] = _all
    _jd["workers"] = _workers
    _jd["mgmtnodes"] = _mgmtnodes
    _jd["servicenode"] = _servicenode

    jd = json.dumps(_jd, indent=4)
    return jd


if __name__ == "__main__":

    ap = argparse.ArgumentParser(
        description = "Generate a cluster inventory from Terraform.",
        prog = __file__
    )

    mo = ap.add_mutually_exclusive_group()
    mo.add_argument("--list",action="store", nargs="*", default="dummy", help="Show JSON of all managed hosts")
    mo.add_argument("--host",action="store", help="Display vars related to the host")

    args = ap.parse_args()

    if args.host:
        print(json.dumps({}))
    elif len(args.list) >= 0:
        jd = generate_inventory()
        print(jd)
    else:
        raise ValueError("Expecting either --host $HOSTNAME or --list")

    
