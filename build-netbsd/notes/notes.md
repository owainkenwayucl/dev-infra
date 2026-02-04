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

1. `-c` results in no serial console.

2. `-l` doesn't recognise the image (recommended by warning when doing 1).

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

## 3rd of February, the year of our Lord 2026

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

## 3rd of February, the year of our Lord 2026

Note that after install we want to:

1. Set a root password
2. Enable SSH
3. Enable binary packages
4. Enable PKGSRC

First "real" test build leaves as follows:

```
Filesystem     Size   Used  Avail %Cap Mounted on
/dev/dk0       8.7G   1.6G   6.7G  18% /
tmpfs          1.0G     0B   1.0G   0% /tmp
kernfs         1.0K   1.0K     0B 100% /kern
ptyfs          1.0K   1.0K     0B 100% /dev/pts
procfs         4.0K   4.0K     0B 100% /proc
tmpfs          1.0G     0B   1.0G   0% /var/shm
```

Given this doesn't seem to be sparse allocating I think it's sensible to go for a 3G image with 1G swap?

That ran hilariously out of space when setting up PKGSRC. I think I'll go for no swap as the Internet is unclear on whether you can expand into non-contiguous space.

OK somehow changes didn't persist through reboot?

Ah - maybe it died....

```
calculating dependencies...-python312-3.12.9 is not available in the repository
calculating dependencies...done.
nothing to do.
```

Ok - we need to move to 3.12.12

Now the problem is that "something has changed" and so we can't find the jsonpatch dependency. Worse, it's not in pkgsrc...

But we are installing the same versions of things as before. Frustrating.


OK - I have an image that boots but there's no such concept as growfs. I'm completely baffled. Also I've ended up with MBR instead of GPT????

Looking at the docs I may need `gpart`? https://cloudinit.readthedocs.io/en/latest/reference/modules.html

I so confused. How did I have this working!?!

