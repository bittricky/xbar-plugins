#!/usr/bin/env bash
# <xbar.title>Last Paycheck (date only)</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Mitul Patel</xbar.author>
# <xbar.desc>Shows how many days it has been since your last paycheck. The date is hard-coded inside the script.</xbar.desc>
# <xbar.dependencies>bash</xbar.dependencies>
# <xbar.refresh>3600</xbar.refresh>

# ─────────────── CONFIG ───────────────
LAST_DATE="<LAST_DATE>"   # ← update to YYYY-MM-DD of your most-recent paycheck
icon_b64="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA6UlEQVR4nK3RrUpEURTF8R8YLXaLiAarCPoGgmMTQTCZLXaTwa4gdpMwxTcYplmESYIvYFBQUGyDH2w4DmeOZ65X8A8r3L3W2ufce2lmLelPzOMSfXwm9dNsrs2C5axYKrxWbGK7UMxaMdWwILxGZtDLrvyB5+y5lzJVpjEo3vkae3jPZoOU/cFZpRynLeGw8CI7xiyGRegcK7jDVeENU2fEfuWX3afT1/FQ8aMz8fqhNzxiF1sVf+w1LiqBY3RwgI2KHx3fHFUCT9jBKm4rfnRGLOJ1wpKbyvwFC/mCID7YKbq/6CRl/4cvLcxyjubtkvwAAAAASUVORK5CYII="
# ──────────────────────────────────────

iso_to_epoch() { 
  date -j -f "%Y-%m-%d" "$1" +"%s" 2>/dev/null
}

epoch_last=$(iso_to_epoch "$LAST_DATE") || {
  echo "⚠️ Bad date"
  echo "---"
  echo "Check LAST_DATE in the script"
  exit 0
}

epoch_now=$(date +"%s")
days_ago=$(( (epoch_now - epoch_last) / 86400 ))

readable_diff() {
  local start="$1"
  local end="$2"
  local y1 m1 d1 y2 m2 d2
  IFS='-' read -r y1 m1 d1 <<< "$start"
  IFS='-' read -r y2 m2 d2 <<< "$end"

  local years months days
  years=$((y2 - y1))
  months=$((m2 - m1))
  days=$((d2 - d1))

  if ((days < 0)); then

    months=$((months - 1))
    prev_month=$((10#$m2 - 1))
    prev_year=$y2
    if ((prev_month == 0)); then
      prev_month=12
      prev_year=$((y2 - 1))
    fi
    days_in_prev_month=$(cal $prev_month $prev_year | awk 'NF {DAYS = $NF}; END {print DAYS}')
    days=$((days + days_in_prev_month))
  fi
  if ((months < 0)); then
    years=$((years - 1))
    months=$((months + 12))
  fi

  output=""
  if ((years > 0)); then
    output+="$years year"
    ((years > 1)) && output+="s"
  fi
  if ((months > 0)); then
    [[ -n "$output" ]] && output+=", "
    output+="$months month"
    ((months > 1)) && output+="s"
  fi
  if ((days > 0)); then
    [[ -n "$output" ]] && output+=", "
    output+="$days day"
    ((days > 1)) && output+="s"
  fi
  [[ -z "$output" ]] && output="today"
  echo "$output ago"
}

NOW_DATE="$(date -j -u -f "%s" "$epoch_now" +"%Y-%m-%d")"

# ───────────── xbar output ────────────
menubar_text="$(readable_diff "$LAST_DATE" "$NOW_DATE") | templateImage=$icon_b64"
echo "$menubar_text"
echo "---"
echo "Last paycheck : $LAST_DATE ($days_ago day$([ "$days_ago" -eq 1 ] || echo s) ago)"
echo "---"

SCRIPT_PATH="${BASH_SOURCE[0]}"
echo "Edit date → | bash='open -e \"$SCRIPT_PATH\"' terminal=false"
