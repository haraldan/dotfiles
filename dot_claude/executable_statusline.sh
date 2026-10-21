#!/usr/bin/env bash
# Claude Code status line: active model and reasoning effort.
# One jq call: this runs every second (refreshInterval) so resizes re-align.
# tr strips the CRs some Windows jq builds emit, which would skew the width math.
{ read -r model; read -r effort; read -r pct; } < <(jq -r '
  (.model.display_name // .model.id // "?"),
  (.effort.level // ""),
  (.rate_limits.five_hour.used_percentage // "")' | tr -d '\r')
if [ -n "$effort" ]; then
  left="$model · $effort"
else
  left="$model"
fi

# 5-hour session usage bar (right-aligned); absent for non-subscribers.
if [ -z "$pct" ]; then
  printf '%s' "$left"
  exit 0
fi

export LC_ALL=C.UTF-8
pct=$(printf '%.0f' "$pct")
[ "$pct" -lt 0 ] && pct=0
[ "$pct" -gt 100 ] && pct=100
filled=$(( (pct * 10 + 50) / 100 ))
bar=""
for ((i = 0; i < 10; i++)); do
  if [ "$i" -lt "$filled" ]; then bar+="█"; else bar+="░"; fi
done
right="$bar ${pct}%"

margin=4
cols=${COLUMNS:-0}
[[ "$cols" =~ ^[0-9]+$ ]] || cols=0
avail=$(( cols - margin ))
pad=$(( avail - ${#left} - ${#right} ))
# Color the bar Claude Code's lavender blue (#B1B9F9); escape codes are added
# after the width math.
colored=$'\e[38;2;177;185;249m'"$bar"$'\e[0m'" ${pct}%"

# Right-align when it fits; otherwise shed the bar, then the percentage, so
# the line never overflows (an overflowing line isn't shown at all).
if (( cols == 0 )); then
  printf '%s · %s' "$left" "$colored"
elif (( pad >= 2 )); then
  printf '%s%*s%s' "$left" "$pad" "" "$colored"
elif (( ${#left} + 3 + ${#right} <= avail )); then
  printf '%s · %s' "$left" "$colored"
elif (( ${#left} + 3 + ${#pct} + 1 <= avail )); then
  printf '%s · %s%%' "$left" "$pct"
else
  printf '%s' "$left"
fi
