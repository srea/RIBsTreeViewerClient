#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -d Carthage/Build/RIBs.xcframework ]]; then
  echo "Run 'make setup' before generating XCFrameworks."
  exit 1
fi

rm -rf ./Products/RIBsTreeViewerClient.xcframework build

COMMON_FLAGS=(
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES
  SKIP_INSTALL=NO
  ENABLE_BITCODE=NO
)

xcodebuild \
  "${COMMON_FLAGS[@]}" \
  archive \
  -project RIBsTreeViewerClient.xcodeproj \
  -scheme RIBsTreeViewerClient \
  -destination 'generic/platform=iOS Simulator' \
  -configuration Release \
  -archivePath build/RIBsTreeViewerClient-iOS-Simulator.xcarchive

xcodebuild \
  "${COMMON_FLAGS[@]}" \
  archive \
  -project RIBsTreeViewerClient.xcodeproj \
  -scheme RIBsTreeViewerClient \
  -destination 'generic/platform=iOS' \
  -configuration Release \
  -archivePath build/RIBsTreeViewerClient-iOS.xcarchive

xcodebuild \
  -create-xcframework \
  -framework build/RIBsTreeViewerClient-iOS-Simulator.xcarchive/Products/Library/Frameworks/RIBsTreeViewerClient.framework \
  -framework build/RIBsTreeViewerClient-iOS.xcarchive/Products/Library/Frameworks/RIBsTreeViewerClient.framework \
  -output Products/RIBsTreeViewerClient.xcframework

echo "Created Products/RIBsTreeViewerClient.xcframework"
