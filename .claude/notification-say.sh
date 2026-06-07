#!/bin/bash
cache=~/.claude/builtin-speaker
if [ ! -f "$cache" ]; then
  system_profiler SPAudioDataType -json 2>/dev/null \
    | jq -r '.SPAudioDataType[0]._items[] | select(.coreaudio_device_transport == "coreaudio_device_type_builtin" and .coreaudio_device_output != null) | ._name' \
    | head -1 > "$cache"
fi
jq -r '.message // "Claude needs attention"' | say -a "$(cat "$cache")"
