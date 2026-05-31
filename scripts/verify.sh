#!/usr/bin/env bash
# Verify RIBsTreeViewerClient is in a usable state.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Swift Package Manager library build"
./scripts/build-spm-package.sh

echo "==> Xcode project (SPM dependencies, iOS Simulator)"
xcodebuild -resolvePackageDependencies \
  -project RIBsTreeViewerClient.xcodeproj \
  -scheme RIBsTreeViewerClient
xcodebuild build \
  -project RIBsTreeViewerClient.xcodeproj \
  -scheme RIBsTreeViewerClient \
  -destination 'generic/platform=iOS Simulator' \
  -configuration Release \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGNING_ALLOWED=NO \
  -derivedDataPath .build/DerivedData-verify

echo "==> Prebuilt XCFramework"
test -f Products/RIBsTreeViewerClient.xcframework/Info.plist

echo "==> WebSocket relay"
(cd WebSocketServer && npm ci)

echo "==> Browser viewer"
(cd Browser && yarn install --frozen-lockfile && yarn build)

echo ""
echo "All checks passed. Usable workflow:"
echo "  1. cd WebSocketServer && npm start"
echo "  2. cd Browser && yarn build && open ./public/index.html"
echo "  3. Link Products/RIBsTreeViewerClient.xcframework or add SPM package in your app (# DEBUG)"
