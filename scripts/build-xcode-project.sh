#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

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
  "$@"
