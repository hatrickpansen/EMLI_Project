#!/bin/bash

PORT=/dev/ttyACM0 # something
BAUDRATE=115200

parse_sensors() {
    timeout 3s cat "$PORT" | while IFS=, read -r plant_water_alarm pump_water_alarm moisture light; do
    if [ ! -z "$plant_water_alarm" ]; then
        mosquitto_pub -h localhost -t pico/plant_water_alarm -m "$plant_water_alarm"
        mosquitto_pub -h localhost -t pico/pump_water_alarm -m "$pump_water_alarm"
        mosquitto_pub -h localhost -t pico/moisture -m "$moisture"
        mosquitto_pub -h localhost -t pico/light -m "$light"
        if [ "$moisture" -lt 50 ] && [ "$pump_water_alarm" -eq 0 ] && [ "$plant_water_alarm" -eq 1 ]; then
            echo "Moisture is below 50"
            curl -X GET http://192.168.10.222/led/red/off
            curl -X GET http://192.168.10.222/led/green/off
            curl -X GET http://192.168.10.222/led/yellow/on
            # Additional actions or commands to be performed when moisture is below 50
        elif [ "$pump_water_alarm" -eq 1 ] || [ "$plant_water_alarm" -eq 0 ]; then
            echo "pump_water_alarm is 0 or plant_water_alarm i 1"
            curl -X GET http://192.168.10.222/led/green/off
            curl -X GET http://192.168.10.222/led/yellow/off
            curl -X GET http://192.168.10.222/led/red/on
            # Perform actions specific to this condition
        else
            echo "Evrything good"
            curl -X GET http://192.168.10.222/led/red/off
            curl -X GET http://192.168.10.222/led/yellow/off
            curl -X GET http://192.168.10.222/led/green/on
        fi
    fi
    done
}

while true; do
    parse_sensors
    sleep 1
done;