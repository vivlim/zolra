#!/bin/sh -l

echo "Building site in working directory"
cd /github/workspace
/bin/zolra build && chown --reference=content public