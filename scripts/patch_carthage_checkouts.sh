#!/usr/bin/env bash
# Xcode 15+ removed libarclite; Carthage checkouts still target iOS 8–11.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHECKOUTS="$ROOT/Carthage/Checkouts"

if [[ ! -d "$CHECKOUTS" ]]; then
  echo "No Carthage/Checkouts directory. Run 'carthage update --no-build' first."
  exit 1
fi

find "$CHECKOUTS" -name project.pbxproj -print0 | while IFS= read -r -d '' file; do
  sed -i '' -E \
    -e 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9]+\.[0-9]+;/IPHONEOS_DEPLOYMENT_TARGET = 13.0;/g' \
    -e 's/TVOS_DEPLOYMENT_TARGET = [0-9]+\.[0-9]+;/TVOS_DEPLOYMENT_TARGET = 13.0;/g' \
    -e 's/MACOSX_DEPLOYMENT_TARGET = [0-9]+\.[0-9]+;/MACOSX_DEPLOYMENT_TARGET = 10.15;/g' \
    "$file"
done

RIBS_PBX="$CHECKOUTS/RIBs/ios/RIBs.xcodeproj/project.pbxproj"
if [[ -f "$RIBS_PBX" ]]; then
  sed -i '' \
    -e 's|path = ../Carthage/Build/iOS/RxSwift.framework|path = ../../../Build/RxSwift.xcframework|g' \
    -e 's|path = ../Carthage/Build/iOS/RxRelay.framework|path = ../../../Build/RxRelay.xcframework|g' \
    -e 's|name = RxSwift.framework; path = ../../../Build/RxSwift.xcframework|name = RxSwift.xcframework; path = ../../../Build/RxSwift.xcframework|g' \
    -e 's|name = RxRelay.framework; path = ../../../Build/RxRelay.xcframework|name = RxRelay.xcframework; path = ../../../Build/RxRelay.xcframework|g' \
    -e 's|lastKnownFileType = wrapper.framework; name = RxSwift.xcframework|lastKnownFileType = wrapper.xcframework; name = RxSwift.xcframework|g' \
    -e 's|lastKnownFileType = wrapper.framework; name = RxRelay.xcframework|lastKnownFileType = wrapper.xcframework; name = RxRelay.xcframework|g' \
    -e 's#$(PRODUCTS_DIR)../Carthage/Build/iOS/#$(SRCROOT)/../../../Build#g' \
    -e 's#$(SRCROOT)/../Carthage/Build/iOS/RxSwift.framework#$(SRCROOT)/../../../Build/RxSwift.xcframework#g' \
    -e 's#$(SRCROOT)/../Carthage/Build/iOS/RxRelay.framework#$(SRCROOT)/../../../Build/RxRelay.xcframework#g' \
    -e 's|/usr/local/bin/carthage copy-frameworks|: # carthage copy-frameworks disabled for xcframework|g' \
    "$RIBS_PBX"
fi

echo "Patched deployment targets under Carthage/Checkouts"
