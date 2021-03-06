FROM debian:testing

# install debian packages:
ENV DEBIAN_FRONTEND=noninteractive
RUN set -e -x; \
    apt-get update; \
    apt-get install -y --no-install-recommends locales \
        openssh-client \
        python3-pip python3-setuptools python3-wheel \
        flake8 python3-nosexcover \
        ansible \
        shellcheck \
        gnupg \
        git tmux \
        sudo

# setup su and locale
RUN set -e -x; \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen; locale-gen; \
    sed -i '/pam_rootok.so$/aauth sufficient pam_permit.so' /etc/pam.d/su
ENV LC_ALL=en_US.UTF-8

CMD ["./test"]
