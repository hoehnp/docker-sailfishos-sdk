FROM coderus/sailfishos-platform-sdk-base
MAINTAINER Andrey Kozhevnikov <coderusinbox@gmail.com>

# Add nemo in sudoers without password
RUN chmod +w /etc/sudoers && echo "nemo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && chmod -w /etc/sudoers

COPY mer-tooling-chroot /home/nemo/mer-tooling-chroot

USER nemo

RUN set -ex ;\
 sudo zypper ref ;\
 sudo zypper -qn in tar ;\
 sdk-assistant -y create SailfishOS-2.2.0.29 \
    https://releases.sailfishos.org/sdk/targets-1804/Jolla-2.2.0.29-Sailfish_SDK_Tooling-i486.tar.bz2 ;\
 sudo mv -f /home/nemo/mer-tooling-chroot /srv/mer/toolings/SailfishOS-2.2.0.29/mer-tooling-chroot ;\
 sdk-assistant -y create SailfishOS-2.2.0.29-armv7hl \
    https://releases.sailfishos.org/sdk/targets-1804/Jolla-2.2.0.29-Sailfish_SDK_Target-armv7hl.tar.bz2 ;\
 sdk-assistant -y create SailfishOS-2.2.0.29-i486 \
    https://releases.sailfishos.org/sdk/targets-1804/Jolla-2.2.0.29-Sailfish_SDK_Target-i486.tar.bz2
