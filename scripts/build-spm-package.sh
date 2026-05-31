#!/usr/bin/env bash
# Build RIBsTreeViewerClient via Swift Package Manager (iOS Simulator).
# See https://github.com/srea/RIBsTreeViewerClient/issues/38
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

swift package resolve

SDK="$(xcrun --sdk iphonesimulator --show-sdk-path)"
swift build \
  --build-path .build/spm-check \
  -Xswiftc -sdk -Xswiftc "$SDK" \
  -Xswiftc -target -Xswiftc arm64-apple-ios15.0-simulator \
  -Xcc -isysroot -Xcc "$SDK" \
  -Xcc -target -Xcc arm64-apple-ios15.0-simulator

echo "SPM build succeeded (RIBsTreeViewerClient for iOS Simulator)"
