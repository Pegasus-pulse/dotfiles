#!/usr/bin/env bash

declare -A MOUNTS=(
  ["$HOME/Repos/Website/mycorner"]="$HOME/Sync/Acode/mycorner"
  ["$HOME/Repos/MBTesting"]="$HOME/Sync/Acode/MBTesting"
)

SUCCESS=()
FAILED=()

for SOURCE_DIR in "${!MOUNTS[@]}"; do
  TARGET_DIR="${MOUNTS[$SOURCE_DIR]}"
  NAME="$(basename "$TARGET_DIR")"

  if mountpoint -q "$TARGET_DIR"; then
    umount "$TARGET_DIR" &>/dev/null \
      && SUCCESS+=("❌ $NAME unmounted") \
      || FAILED+=("⚠️ $NAME failed to unmount")
  else
    bindfs -o --no-allow-other "$SOURCE_DIR" "$TARGET_DIR" &>/dev/null \
      && SUCCESS+=("✅ $NAME mounted") \
      || FAILED+=("⚠️ $NAME failed to mount")
  fi
done

MESSAGE="$(printf "%s\n" "${SUCCESS[@]}")"

if [ ${#FAILED[@]} -gt 0 ]; then
  MESSAGE+="\n\n$(printf "%s\n" "${FAILED[@]}")"
  notify-send -a "task" -u normal -r 9995 -i "error" "Mount Summary" "$MESSAGE"
else
  notify-send -a "task" -u low -r 9995 -i "success" "Mount Summary" "$MESSAGE"
fi
