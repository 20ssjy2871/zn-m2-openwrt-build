#!/bin/bash
set -euo pipefail

# 直接设为 true，跳过检测强制触发编译
SHOULD_BUILD=true

# 获取 Passwall Release Tag（保留日志输出与信息记录）
LATEST_PW=$(gh release list -R Openwrt-Passwall/openwrt-passwall -L 1 --json tagName -q '.[0].tagName' || echo "unknown")
LATEST_TAG=$(gh release list -R "$GITHUB_REPOSITORY" -L 1 --json tagName -q '.[0].tagName' || echo "")
echo "Passwall release: ${LATEST_TAG:-none} -> $LATEST_PW (Forced build)"

# 获取 Packages 最新 Commit Hash（保留日志输出与信息记录）
LATEST_SHA=$(gh api repos/Openwrt-Passwall/openwrt-passwall-packages/commits/main --jq .sha || echo "unknown")
STORED_SHA=$(cat /tmp/passwall-cache/packages-sha 2>/dev/null || echo "")
echo "Packages: ${STORED_SHA:-none} -> $LATEST_SHA (Forced build)"

# 输出到 GitHub Actions 环境变量
echo "should_build=$SHOULD_BUILD" >> "$GITHUB_OUTPUT"
echo "latest_pkg_sha=$LATEST_SHA" >> "$GITHUB_OUTPUT"
