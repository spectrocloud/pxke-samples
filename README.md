# PXKE Samples 
A working repo providing examples on how to customize the PXK-E Installer.

1.  Clone this repo.

2.  Create a `user-data.yaml` file.
Example Content
```
#cloud-config
stylus:
  site:
    # Palette target default: api.spectrocloud.com
    # paletteEndpoint: api.spectrocloud.com
    
    # optional registration URL for QRCode Generation
    # registrationURL: https://app.vercel.app/
install:
  reboot: false
  poweroff: true
  device: /dev/sda
users:
- name: "kairos"
  passwd: "kairos"
```

3.  Run `,/build-installer.sh`

The output is an ISO you can mount to run the installer on the system of your choice.

