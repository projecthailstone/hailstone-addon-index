#!/bin/sh
# Signs hailstone-addon-index.txt with the Hailstone release key and checks the result against the public key.
#   HAILSTONE_SIGN  the hailstone_sign tool (default: ../hailstone-client/build/hailstone_sign)
#   RELEASE_KEY     the secret key file (default: ~/.config/hailstone-release/release-key.secret)
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
sign=${HAILSTONE_SIGN:-$here/../hailstone-client/build/hailstone_sign}
key=${RELEASE_KEY:-$HOME/.config/hailstone-release/release-key.secret}
public=af51cb7050125d396bbd4e007e029a58ba8fd78cf0bc0274c5016fe67084f515
"$sign" sign "$key" "$here/hailstone-addon-index.txt"
"$sign" verify "$public" "$here/hailstone-addon-index.txt"
