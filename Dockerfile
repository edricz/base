#
# BRICKLY.IO CONFIDENTIAL
# ______________________________
#
#  [2015] - [2017] Brickly.io Incorporated
#  All Rights Reserved.
#
# NOTICE: All information contained herein is, and remains the property of Brickly.io Incorporated
# and its suppliers, if any.  The intellectual and technical concepts contained herein are
# proprietary to Brickly.io Incorporated and its suppliers and may be covered by U.S. and Foreign
# Patents, patents in process, and are protected by trade secret or copyright law. Dissemination of
# this information or reproduction of this material is strictly forbidden unless prior written
# permission is obtained from Brickly.io Incorporated.
#

FROM alpine:3.5
ENV ALPINE_VERSION=3.5

# Install needed packages. Notes:
#   * dumb-init: a proper init system for containers, to reap zombie children
#   * bash: so we can access /bin/bash
#   * ca-certificates: for SSL verification during Pip and easy_install
ENV PACKAGES="\
  dumb-init \
  bash \
  ca-certificates \
"

RUN echo \
  # replacing default repositories with edge ones
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \

  # Add the packages, with a CDN-breakage fallback if needed
  && apk add --no-cache $PACKAGES || \
    (sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add --no-cache $PACKAGES) \

  # turn back the clock -- so hacky!
  && echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main/" > /etc/apk/repositories
