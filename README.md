# PXK-E Samples 
A working repo providing examples on how to customize the PXK-E Installer.

1.  Clone this repo.

2.  Create a `user-data.yaml` file.
Example Content

```yaml
#cloud-config
stages:
  boot:
    - users:
        kairos:
          groups:
            - sudo
          passwd: kairos
stylus:
  site:
    # host for hubble api to register device.
    paletteEndpoint: api.spectrocloud.com
    
    # name of the device, this may also be referred to as the edge id or edge host id.  If no edge host name is specified
    # one will be generated from the device serial number.  If stylus cannot the device serial number a random id will
    # be used instead. In the case of hardware that does not have a serial number is highly recommended to specify the
    # device name as a random name is not deterministic and may lead to a device being registered twice under different 
    # names.
    name: edge-randomid
    # An optional url which will be used to combine with the edge name from above to generate a QR code on the screen  for
    # ease of creation of devices and cluster on PaletteUI via an application e.g vercel.app .
    # QR code will appear only of the device is not registered on Palette
    registrationURL: https://edge-registration-app.vercel.app/
    # The id of the project that is in scope for the device.
    projectUid: ""
    # The Palette tenant registration token value. This is an optional value and only used for automated registration.
    edgeHostToken: ""
    
    # Optional 
    network:
      # configures http_proxy
      httpProxy: http://proxy.example.com
      # configures https_proxy
      httpsProxy: https://proxy.example.com
      # configures no_proxy
      noProxy: 10.10.128.10,10.0.0.0/8    

      # Optional: configures the global  nameserver for the system.
      nameserver: 1.1.1.1
      # configure interface specific info. If omitted all interfaces will default to dhcp
      interfaces:
           enp0s3:
               # type of network dhcp or static
               type: static
               # Ip address including the mask bits
               ipAddress: 10.0.10.25/24
               # Gateway for the static ip.
               gateway: 10.0.10.1
               # interface specific nameserver
               nameserver: 10.10.128.8
           enp0s4:
               type: dhcp 
    caCerts:
      - |
        ------BEGIN CERTIFICATE------
        *****************************
        *****************************
        ------END CERTIFICATE------
      - |
        ------BEGIN CERTIFICATE------
        *****************************
        *****************************
        ------END CERTIFICATE------
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

An example user-data file might be as follows:




3.  Run `./build-installer.sh`

The output is an ISO you can mount to run the installer on the system of your choice.

