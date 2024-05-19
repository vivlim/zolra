#!/bin/sh -l

echo "Building site in working directory"
cd /github/workspace

/bin/zolra build

# need to fix permissions after building, or it'll be owned by root
chown $(stat -c %u:%g .) -R public -c