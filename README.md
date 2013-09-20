gwms-vagrant
============

Various things to run gWMS as a multi-VM vagrant deployment.

To use:

```
% ./do-certs.sh (you only need to do this once)
% vagrant up
% vagrant ssh osgce (or factory or frontend)
```

If your hypervisor is in a non-Linux environment, you can execute do-certs.sh in a minimal VM.
If you don't know how to do that, you could do the following to generate the certificates:

```
% vagrant factory up
(factory will complain about some missing files, but you can ignore it)
% vagrant factory ssh
[vagrant@vagrant-factory ~]$ cd /vagrant && ./do-certs.sh
[vagrant@vagrant-factory ~]$ logout
% vagrant destroy -f factory
```

and then

```
% vagrant up
% vagrant ssh osgce (or factory or frontend)
```