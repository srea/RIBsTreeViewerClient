#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

rm -rf ./Products/RIBsTreeViewerClient.xcframework build

xcodebuild -resolvePackageDependencies \
  -project RIBsTreeViewerClient.xcodeproj \
  -scheme RIBsTreeViewerClient

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
