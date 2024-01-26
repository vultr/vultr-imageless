# vultr-imageless
An imageless app template for making imageless Marketplace app for Vultr.

### create_app.sh
This will create the script to use on https://my.vultr.com to make an imageless app.

### VULTR_APP
This file specifies the app name and info.

### ./image/rootfs
This root directory is copied over on boot.

### ./image/rootfs/app_binaries/install.sh
This file is run on boot to install your app.

### Output

The output sh file can be opened in a text editor and copied and pasted into the imageless
text field on your Marketplace app's builds page. Remember to be careful and use appropriate
text editors as carriage returns may cause issues on linux systems if you are building from
Windows.
