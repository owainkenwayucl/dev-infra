# NetBSD on Condenser

So I did this a while back but have to re-do it due to losing the image in the events of Xmas 2025.

Version 1 will be replicating what I did before. Then I really want to fix the qemu-guest-agent/virtio-serial challenges.

## Process

1. Build VM on Condenser with QEMU installed so we can do the image dev work. I've create a role for this which is in the roles directory.

2. Pull NetBSD image.

3. Provision VM on VM.

4. Set up cloudinit as per existing shell script.

## 2nd of February, the year of our Lord 2026

Step 1 was easy.

Step 2+3 was a faff because of lost knowledge on how to fix the following issues with virt-install/the full NetBSD CD-ROM image.

a. `-c` results in no serial console.

b. `-l` doesn't recognise the image (recommended by warning when doing a).

The actual solution is to download and use the boot-com image and boot it with `-c`.

Doing the actual install I run into two minor issues one of which I remember (the net install pulls from http which feels less than good(tm)) and one I don't (what is the appopriate way to apportion swap if we intend to resize the volume with cloud-init). 

I put up with the risk (this is a test image anyway) of http and set swap to zero and successfully did a basic test install.

At this point the `virt-install` command looks like:

```
virt-install --connect qemu:///system -n netbsd \
        --ram 4096 --vcpus=2 \
        --cpu=host \
        -c /var/lib/libvirt/images/NetBSD-10.1-amd64-com.iso \
        --os-variant=netbsd10.0  \
        --disk path=/var/lib/libvirt/images/netbsd10_1.qcow2,format=qcow2,size=10       \
        -w network=default --nographics --serial pty --console pty,target_type=serial 
```

## 3rd of February 2026

The solution to fetching sets via http is to add a second disk that points to the "big" NetBSD installer and tell the installer that the install cdrom is "wd1a".

```
virt-install --connect qemu:///system -n netbsd \
        --ram 4096 --vcpus=2 \
        --cpu=host \
        -c /var/lib/libvirt/images/NetBSD-10.1-amd64-com.iso \
        --os-variant=netbsd10.0  \
        --disk path=/var/lib/libvirt/images/netbsd10_1.qcow2,format=qcow2,size=10 \
        --disk path=/var/lib/libvirt/images/NetBSD-10.1-amd64.iso \
        -w network=default --nographics --serial pty --console pty,target_type=serial 
```

