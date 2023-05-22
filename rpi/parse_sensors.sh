#!/bin/bash

PORT=/dev/ # something

fifo="/tmp/raw_sensors.fifo"
mkfifo "$fifo"

screen -L $PORT > "$fifo" &

cat "$fifo" | while IFS=, read -r plant_water_alarm pump_water_alarm moisture light; do
  mosquitto_pub -h localhost -t pico/plant_water_alarm -m "$plant_water_alarm"
  mosquitto_pub -h localhost -t pico/pump_water_alarm -m "$pump_water_alarm"
  mosquitto_pub -h localhost -t pico/moisture -m "$moisture"
  mosquitto_pub -h localhost -t pico/light -m "$light"
done

rm "$fifo"