FROM hoehnp/sailfishos-platform-sdk-base:2.2.1.18
MAINTAINER Patrick Hoehn <hoehnp@gmx.de>

ARG SDK_VERSION
ARG TARGET_VERSION

COPY mer-tooling-chroot /home/nemo/mer-tooling-chroot

# Add nemo in sudoers without password
RUN set -ex;\
 chmod +w /etc/sudoers ;\
 echo "nemo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers ;\
 chmod -w /etc/sudoers 

# change uid and guid to run image on circleci 
RUN export olduid=$(id -u nemo) ;\
  export oldgid=$(id -g nemo) ;\
 usermod -u 1000 nemo; groupmod -g 1000 nemo ;\
 find / -user $olduid -exec chown -h 1000 {} \; ;\ 
 find / -group $oldgid -exec chgrp -h 1000 {} \; ;\
 usermod -g 1000 nemo

USER nemo

RUN set -ex ;\
 sudo zypper ref ;\
 sudo zypper -qn in tar ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION \
    https://releases.sailfishos.org/sdk/targets-$SDK_VERSION/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.bz2 ;\
 sudo mv -f /home/nemo/mer-tooling-chroot /srv/mer/toolings/SailfishOS-$TARGET_VERSION/mer-tooling-chroot ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-armv7hl \
    https://releases.sailfishos.org/sdk/targets-$SDK_VERSION/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-armv7hl.tar.bz2 ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-i486 \
    https://releases.sailfishos.org/sdk/targets-$SDK_VERSION/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-i486.tar.bz2 ;\
 sudo rm -rf /var/cache/zypp/* ;\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-armv7hl/var/cache/zypp/* ;\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-i486/var/cache/zypp/*
