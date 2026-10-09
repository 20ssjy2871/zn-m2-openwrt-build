#!/bin/bash
set -euo pipefail

cd openwrt/bin/targets/*/*
rm -rf packages
echo "FIRMWARE=$PWD" >> "$GITHUB_ENV"

mkdir -p /tmp/release-firmware

copy_with_suffix() {
  local src="$1" suffix="$2"
  local fn
  fn=$(basename "$src")
  if [[ "$fn" == *.* ]]; then
    local name="${fn%.*}" ext="${fn##*.}"
    cp "$src" "/tmp/release-firmware/${name}-${suffix}.${ext}"
  else
    cp "$src" "/tmp/release-firmware/${fn}-${suffix}"
  fi
}

for f in /tmp/firmware-basic/*; do
  copy_with_suffix "$f" "basic"
done

echo "Release firmware files:"
ls -la /tmp/release-firmware/
