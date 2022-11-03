# PXK-E Samples 
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

4.  run `cp .installer.env.template .installer.env`

Modify the file you copied to reflect your options
Example:
```
### Name of the ISO image to be generated.Optional - defaults to p6os-custom if not specified

ISO_IMAGE="prod-2.0.4"

### Version of the stylus installer to customize .Optional- Defaults to whatver is current latest release  - https://github.com/spectrocloud/stylus/releases.  For using latest builds, use "latest"

INSTALLER_VERSION="v2.0.4"

### Target Docker image for the installer to generate.Optional - Defaults to gcr.io/spectro-dev-public/stylus-custom

#IMAGE_NAME="gcr.io/customer-registry/p6os"

### Path to user data file. Optional - Defaults to "user-data" in the current directory.Change the value below and uncomment the line if the file is different

USER_DATA_FILE="user-data.yaml"
```

3.  Run `,/build-installer.sh`

The output is an ISO you can mount to run the installer on the system of your choice.

