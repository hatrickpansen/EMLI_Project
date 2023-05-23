#!/bin/bash

#Det her script skal bare køre altid og lytte på button press.

# Function to stop the "parse_sensors.sh" script
stop_parse_sensors() {
    if [ -f "/tmp/parse_sensors.pid" ]; then
        pid=$(cat /tmp/parse_sensors.pid)
        kill "$pid"  # Send SIGTERM signal to the process
        rm /tmp/parse_sensors.pid
        echo "parse_sensors.sh stopped."
    else
        echo "parse_sensors.sh is not running."
    fi
}

# Function to start the "run_pump.sh" script
start_run_pump() {
    if [ -f "/tmp/run_pump.pid" ]; then
        echo "run_pump.sh is already running."
    else
        ./run_pump.sh &  # Start the "run_pump.sh" script
        echo $! > /tmp/run_pump.pid  # Save the PID to a file
        echo "run_pump.sh started."
    fi
}

# MQTT topic to subscribe to
mqtt_topic="remote/count"

# MQTT broker settings
mqtt_broker="localhost"
mqtt_port="1883" # måske behøves ikke?

# Function to check the MQTT result and take appropriate action
check_mqtt_result() {
    result=$(mosquitto_sub -h $mqtt_broker -p $mqtt_port -t $mqtt_topic -C 1)
    if ((result > 1)); then
        stop_parse_sensors
        start_run_pump
    fi
}

# Continuous loop to listen to the MQTT topic
while true; do
    check_mqtt_result
    sleep 1  # Skal nok være 2 da kravet er at den skal vande ved button press indenfor 2 sek
done
