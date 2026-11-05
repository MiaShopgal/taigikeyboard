#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
APK_DIR="$REPO_ROOT/android/app/build/outputs/apk/debug"

make -C "$REPO_ROOT" android-libs
"$REPO_ROOT/android/gradlew" -p "$REPO_ROOT/android" :app:assembleDebug --no-daemon

APK_FILE=""
for apk in "$APK_DIR"/*.apk; do
    [[ -f "$apk" ]] || continue
    if [[ -n "$APK_FILE" ]]; then
        echo "error: expected exactly one debug APK in $APK_DIR; found more than one" >&2
        exit 1
    fi
    APK_FILE="$apk"
done

if [[ -z "$APK_FILE" ]]; then
    echo "error: no debug APK found in $APK_DIR" >&2
    exit 1
fi

printf 'Debug APK: %s\n' "$APK_FILE"
