#!/bin/bash
set -euo pipefail

if [ "$(uname)" == "Darwin" ]; then
    cat $1 |grep -v "\-----" | sed -e :loop -e 'N; $!b loop' -e 's/\n//g'
else
    cat $1 |grep -v "\-----" | sed -e ':loop; N; $!b loop; s/\n//g'
fi
