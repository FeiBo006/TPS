#!/usr/bin/env bash
# 脚本说明：低占用 Android 模拟器启动脚本，避免每次手动输入 emulator 参数。

set -euo pipefail

AVD_NAME="${AVD_NAME:-tps-lite}"
ANDROID_HOME="${ANDROID_HOME:-/opt/android-sdk}"
ANDROID_AVD_HOME="${ANDROID_AVD_HOME:-/tmp/android-avd}"
EMULATOR_BIN="${ANDROID_HOME}/emulator/emulator"
AVDMANAGER_BIN="${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager"
SYSTEM_IMAGE="${SYSTEM_IMAGE:-system-images;android-35;google_apis;x86_64}"
DEVICE_ID="${DEVICE_ID:-pixel_2}"
RAM_MB="${RAM_MB:-1536}"
CORES="${CORES:-2}"
GPU_MODE="${GPU_MODE:-swiftshader_indirect}"
QT_PLATFORM="${QT_PLATFORM:-xcb}"

if [[ ! -x "$EMULATOR_BIN" ]]; then
  echo "emulator not found: $EMULATOR_BIN" >&2
  echo "Set ANDROID_HOME or install Android emulator." >&2
  exit 1
fi

mkdir -p "$ANDROID_AVD_HOME"

if [[ ! -d "$ANDROID_AVD_HOME/${AVD_NAME}.avd" ]]; then
  if [[ ! -x "$AVDMANAGER_BIN" ]]; then
    echo "avdmanager not found: $AVDMANAGER_BIN" >&2
    exit 1
  fi

  echo "Creating AVD: $AVD_NAME"
  ANDROID_AVD_HOME="$ANDROID_AVD_HOME" "$AVDMANAGER_BIN" create avd \
    -n "$AVD_NAME" \
    -k "$SYSTEM_IMAGE" \
    -d "$DEVICE_ID"
fi

if [[ ! -e /dev/kvm ]]; then
  cat >&2 <<'EOF'
Warning: /dev/kvm does not exist. x86_64 Android emulator needs KVM.
Run once if needed:
  sudo mknod /dev/kvm c 10 232
  sudo chgrp kvm /dev/kvm
  sudo chmod 660 /dev/kvm
  sudo usermod -aG kvm "$USER"
  newgrp kvm
EOF
else
  if [[ ! -r /dev/kvm || ! -w /dev/kvm ]]; then
    echo "Warning: /dev/kvm exists but is not writable by current user." >&2
    echo "Run: sudo usermod -aG kvm $USER && newgrp kvm" >&2
  fi
fi

echo "Starting Android emulator"
echo "AVD_HOME: $ANDROID_AVD_HOME"
echo "AVD: $AVD_NAME"
echo "RAM: ${RAM_MB} MB, cores: $CORES, gpu: $GPU_MODE"
echo "Qt platform: $QT_PLATFORM"
echo

ANDROID_AVD_HOME="$ANDROID_AVD_HOME" \
QT_QPA_PLATFORM="$QT_PLATFORM" \
QT_QUICK_BACKEND=software \
QT_OPENGL=software \
"$EMULATOR_BIN" \
  -avd "$AVD_NAME" \
  -memory "$RAM_MB" \
  -cores "$CORES" \
  -no-boot-anim \
  -no-snapshot-save \
  -gpu "$GPU_MODE" \
  -feature -Vulkan
