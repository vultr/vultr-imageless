#cloud-config
users:
- name: myapp

write_files:
- encoding: b64
  content: Q29uZmlncyBvciBhbnl0aGluZyBjYW4gZ28gaGVyZQ==
  owner: root:root
  path: /etc/myapp/myconfig.conf
  permissions: '0644'
- encoding: b64
  content: WW91IGNhbiBkbyBiaW5hcmllcywgYnV0IHlvdSB3aWxsIG5lZWQgdG8gbWFyayB0aGVtIHdpdGggY2htb2QgK3ggYmVmb3JlIHRoZXkgY2FuIGJlIGV4ZWN1dGVkIGFzIHRoZSBiaW5hcnkKZ2VuZXJhdG9yIHdpbGwgb25seSBtYWtlIGZpbGVzIGV4ZWN1dGFibGUgaWYgdGhleSBzdGFydCB3aXRoICMh
  owner: root:root
  path: /opt/myapp/myapp
  permissions: '0644'
- encoding: b64
  content: IyEvYmluL2Jhc2gKCmVjaG8gIkFueSBmaWxlIHN0YXJ0aW5nIHdpdGggIyEgd2lsbCBiZSBtYWRlIGV4ZWN1dGFibGUgYnkgdGhlIGJpbmFyeSBnZW5lcmF0b3IiCg==
  owner: root:root
  path: /opt/myapp/run_myapp.sh
  permissions: '0744'
- encoding: b64
  content: IyEvYmluL2Jhc2gKCnNldCAteAoKZWNobyAiWW91IGNhbiBkbyBhbnl0aGluZyB5b3UgbGlrZSBpbiB0aGlzIGJhc2ggc2NyaXB0LCBvciBhbnkgb3RoZXIiCmVjaG8gIlRoZXJlIGlzIG5vIGxpbWl0IHRvIHRoZSBmaWxlIGRpcmVjdG9yeSBzdHJ1Y3R1cmUgb2Ygcm9vdGZzIGVpdGhlciIK
  owner: root:root
  path: /root/app_binaries/install.sh
  permissions: '0744'
- encoding: b64
  content: IyEvYmluL2Jhc2gKCmVjaG8gIllvdSBjYW4gZXZlbiBwbGFjZSBiaW5hcmllcyBkaXJlY3RseSBpbnRvIHBhdGhzIgo=
  owner: root:root
  path: /usr/sbin/a-command-binary
  permissions: '0744'

#!vultr-vendor-part
#!/bin/bash

# Lets execute the real install script in a way that creates
# logs for the process so failures can be diagnosed
/root/app_binaries/install.sh > /var/log/app_install.log 2>&1
