#!/bin/bash

# Wait for internet connection
for i in {1..30}; do
    if ping -c 1 8.8.8.8 &> /dev/null; then
        break
    fi
    sleep 2
done

source "$(dirname "$0")/../sketchybar_env"
read LAT LON <<< "$(corelocationcli -once -format '%latitude %longitude')"
URL="https://api.openweathermap.org/data/2.5/weather?lat=${LAT}&lon=${LON}&appid=${API_KEY}&units=imperial"

DATA=$(curl -sf "$URL")
if [ -z "$DATA" ]; then
  sketchybar --set weather label="􁜏 "
  exit 1
fi

TEMP=$(echo "$DATA" | jq '.main.temp' | cut -d "." -f 1)
CONDITION=$(echo "$DATA" | jq -r '.weather[0].main')
CONDITION_DESC=$(echo "$DATA" | jq -r '.weather[0].description')
SUNSET=$(echo "$DATA" | jq -r '.sys.sunset // 0')

case "$CONDITION_DESC" in
  "few clouds") ICON="􀇕" ;;
  *)
    case "$CONDITION" in
      Thunderstorm) ICON="􀇟" ;;
      Drizzle)      ICON="􀇅" ;;
      Rain)         ICON="􀇇" ;;
      Snow)         ICON="􀇏" ;;
      Clear)
        ICON="􀆮"
        if [ "$SUNSET" -gt 0 ] && [ "$(date +%s)" -gt "$SUNSET" ]; then
          ICON="􀆺"
        fi
        ;;
      Clouds)       ICON="􀇃" ;;
      Mist|Fog|Haze|Smoke|Dust|Ash|Sand) ICON="􀇣" ;;
      *)            ICON="􀁝" ;;
    esac
    ;;
esac

sketchybar --animate tanh 10 --set weather label="$ICON  ${TEMP}°F"
