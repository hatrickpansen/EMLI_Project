#!/bin/bash

#Det her script skal bare køre altid og lytte på button press.

# Function to start the "parse_sensors.sh" script
start_parse_sensors() {
    echo "Start Parse Sensors"
    if [ -f "/tmp/parse_sensors.pid" ]; then
        echo "parse_sensors.sh is already running."
    else
        ./parse_sensors.sh &  # Start the "parse_sensors.sh" script
        echo $! > /tmp/parse_sensors.pid  # Save the PID to a file
        echo "parse_sensors.sh started."
    fi
}

# Function to stop the "parse_sensors.sh" script
stop_parse_sensors() {
    echo "Stop Parse Sensors"
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
    echo "Start run pump"
    if [ -f "/tmp/run_pump.pid" ]; then
        echo "run_pump.sh is already running."
    else
        ./run_pump.sh &  # Start the "run_pump.sh" script
        echo $! > /tmp/run_pump.pid  # Save the PID to a file
        echo "run_pump.sh started."
        sleep 5  # Wait for 5 seconds before restarting "parse_sensors.sh"
        start_parse_sensors
    fi
}

# MQTT topic to subscribe to
mqtt_topic="remote/count"

# MQTT broker settings
mqtt_broker="localhost"
mqtt_port="1883" # måske behøves ikke?

# Function to check the MQTT result and take appropriate action
check_mqtt_result() {
    echo "Checking MQTT result"
    result=$(mosquitto_sub -h $mqtt_broker -p $mqtt_port -t $mqtt_topic -C 1)
    if [[ $result -gt 0 ]]; then
        stop_parse_sensors
        start_run_pump
    fi
}

# Continuous loop to listen to the MQTT topic
while true; do
    check_mqtt_result
    sleep 1  # Skal nok være 2 da kravet er at den skal vande ved button press indenfor 2 sek
done
