#!/bin/bash
set -euo pipefail

MANIFEST=$(ls "$FIRMWARE"/*.manifest | head -1)

PASSWALL_VER=$(grep luci-app-passwall "$MANIFEST" | awk -F" - " '{print $2}')
if [ -z "$PASSWALL_VER" ]; then
  echo "ERROR: could not extract Passwall version from manifest"
  exit 1
fi
echo "Passwall version: $PASSWALL_VER"
echo "PASSWALL_VER=$PASSWALL_VER" >> "$GITHUB_ENV"
echo "release_tag=${PASSWALL_VER}" >> "$GITHUB_OUTPUT"

touch release.txt
echo "## ZN-M2 固件" >> release.txt
echo "" >> release.txt
echo "**Passwall 版本:** \`$PASSWALL_VER\`" >> release.txt
echo "" >> release.txt
grep xray-core   "$MANIFEST" | awk -F" - " '{print $2}' | awk -F"-" '{print "**Xray:** `"$1"`"}'        >> release.txt || true
grep sing-box    "$MANIFEST" | awk -F" - " '{print $2}' | awk -F"-" '{print "**Sing-Box:** `"$1"`"}'    >> release.txt || true
grep hysteria    "$MANIFEST" | awk -F" - " '{print $2}' | awk -F"-" '{print "**Hysteria:** `"$1"`"}'    >> release.txt || true
grep chinadns-ng "$MANIFEST" | awk -F" - " '{print $2}' | awk -F"-" '{print "**ChinaDNS-NG:** `"$1"`"}' >> release.txt || true
echo "" >> release.txt
echo "### 变体说明" >> release.txt
echo "- **basic**: 纯净版，不含集客AC控制器" >> release.txt
echo "详细包信息请查看 manifest 文件" >> release.txt

echo "release_name=ZN-M2 Passwall ${PASSWALL_VER}" >> "$GITHUB_OUTPUT"
