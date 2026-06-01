#!/usr/bin/env bash
# 脚本说明：Android 模拟器构建安装脚本，主地址使用模拟器访问宿主机的 10.0.2.2。

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EMU_API_BASE_URL="${EMU_API_BASE_URL:-http://10.0.2.2:8080/}"
EMU_WS_URL="${EMU_WS_URL:-ws://10.0.2.2:8080/ws/websocket}"
LOCAL_API_BASE_URL="${LOCAL_API_BASE_URL:-http://127.0.0.1:8080/}"
LOCAL_WS_URL="${LOCAL_WS_URL:-ws://127.0.0.1:8080/ws/websocket}"

API_FALLBACKS="${EMU_API_BASE_URL},${LOCAL_API_BASE_URL}"
WS_FALLBACKS="${EMU_WS_URL},${LOCAL_WS_URL}"
APK_PATH="$ROOT_DIR/app/build/outputs/apk/debug/app-debug.apk"

echo "Building Android debug APK for emulator"
echo "API: $EMU_API_BASE_URL"
echo "WebSocket: $EMU_WS_URL"
echo "Fallback APIs: $API_FALLBACKS"
echo "Fallback WebSockets: $WS_FALLBACKS"
echo

cd "$ROOT_DIR"
./gradlew :app:assembleDebug \
  -PTPS_API_BASE_URL="$EMU_API_BASE_URL" \
  -PTPS_API_FALLBACK_BASE_URLS="$API_FALLBACKS" \
  -PTPS_WS_URL="$EMU_WS_URL" \
  -PTPS_WS_FALLBACK_URLS="$WS_FALLBACKS"

echo
echo "APK ready:"
echo "$APK_PATH"

if adb devices | awk 'NR > 1 && $2 == "device" {found=1} END {exit found ? 0 : 1}'; then
  echo
  echo "Installing APK to connected emulator/device"
  adb install -r "$APK_PATH"
  echo
  echo "Launching app"
  adb shell monkey -p com.tps 1
else
  echo
  echo "No adb device is ready. Start the emulator, then run:"
  echo "  adb install -r \"$APK_PATH\""
  echo "  adb shell monkey -p com.tps 1"
fi
