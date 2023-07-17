ARG BASE_IMAGE=registry.access.redhat.com/ubi8/ubi-init:8.7-10
ARG USERNAME
ARG PASSWORD

FROM $BASE_IMAGE as base

# Generate os-release file
FROM quay.io/kairos/osbuilder-tools:latest as osbuilder
RUN zypper install -y gettext && zypper clean
RUN mkdir /workspace
COPY --from=base /etc/os-release /workspace/os-release
# You should change the following values according to your own versioning and other details
RUN OS_NAME=kairos-core-rhel-fips \
  OS_VERSION=v1.0.0 \
  OS_ID="kairos" \
  OS_NAME=kairos-fedora-fips \
  BUG_REPORT_URL="https://github.com/spectrocloud/pxke-samples/issues" \
  HOME_URL="https://github.com/spectrocloud/pxke-samples" \
  OS_REPO="quay.io/spectrocloud/fedora-fips" \
  OS_LABEL="latest" \
  GITHUB_REPO="spectrocloud/pxke-samples" \
  VARIANT="fips" \
  FLAVOR="rhel" \
  /update-os-release.sh

FROM base

RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
# Subscription manager in redhat does not run directly in containers unless you run on a redhat host, hence we remove the rhsm-host, login to the redhat subscription and add the repos
RUN rm /etc/rhsm-host && subscription-manager register --username ${USERNAME} --password ${PASSWORD} \
  && yum repolist \
  && subscription-manager attach --auto \
  && subscription-manager repos --enable rhel-8-for-x86_64-appstream-rpms \
  && yum repolist
RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf
# Generate machine-id because https://bugzilla.redhat.com/show_bug.cgi?id=1737355#c6
RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf

RUN uuidgen > /etc/machine-id && dnf install -y \
    audit \
    coreutils \
    curl \
    device-mapper \
    dosfstools \
    dracut \
    dracut-live \
    dracut-network \
    dracut-squash \
    e2fsprogs \
    efibootmgr \
    gawk \
    gdisk \
    grub2 \
    grub2-efi-x64 \
    grub2-efi-x64-modules \
    grub2-pc \
    haveged \
    kernel \
    kernel-modules \
    kernel-modules-extra \
    livecd-tools \
    lvm2 \
    nano \
    openssh-server \
    parted \
    polkit \
    qemu-guest-agent \
    rsync \
    shim-x64 \
    squashfs-tools \
    sudo \
    systemd \
    systemd-networkd \
    systemd-resolved \
    tar \
    which \
    && dnf clean all

RUN mkdir -p /run/lock && \
  touch /usr/libexec/.keep && \
  systemctl enable getty@tty1.service && \
  systemctl enable getty@tty2.service && \
  systemctl enable getty@tty3.service && \
  systemctl enable systemd-networkd && \
  systemctl enable systemd-resolved && \
  systemctl enable sshd

# Copy the os-release file to identify the OS
COPY --from=osbuilder /workspace/os-release /etc/os-release

COPY --from=quay.io/kairos/framework:master_fips-systemd / /

# Copy the custom dracut config file
COPY dracut.conf /etc/dracut.conf.d/kairos-fips.conf

# Activate Kairos services
RUN systemctl enable cos-setup-reconcile.timer && \
          systemctl enable cos-setup-fs.service && \
          systemctl enable cos-setup-boot.service && \
          systemctl enable cos-setup-network.service

## Generate initrd
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN kernel=$(ls /boot/vmlinuz-* | head -n1) && \
            ln -sf "${kernel#/boot/}" /boot/vmlinuz
RUN kernel=$(ls /lib/modules | head -n1) && \
            dracut -v -N -f "/boot/initrd-${kernel}" "${kernel}" && \
            ln -sf "initrd-${kernel}" /boot/initrd && depmod -a "${kernel}"

# Symlink kernel HMAC
RUN kernel=$(ls /boot/vmlinuz-* | head -n1) && ln -sf ."${kernel#/boot/}".hmac /boot/.vmlinuz.hmac

RUN rm -rf /boot/initramfs-*
