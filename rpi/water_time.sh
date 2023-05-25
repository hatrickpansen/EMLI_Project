#!/bin/bash

echo "It is time to water the plant my dudes"

# Configuration
#INFLUXDB_URL="http://localhost:8086"
#DATABASE="esp8266_count"
#MEASUREMENT="mqtt_consumer"

# Query to retrieve the last message
#watering_time=$(influx -database "esp8266_count" -execute "SELECT * FROM mqtt_consumer WHERE topic = 'pico/last_pump'")

# Get the current time in Unix timestamp format
#CURRENT_TIME=$(date +%s)

# Convert the last message time to Unix timestamp format
#LAST_MESSAGE_TIMESTAMP=$(date -d "$watering_time" +%s)

# Calculate the time difference in seconds
#TIME_DIFFERENCE=$((CURRENT_TIME - LAST_MESSAGE_TIMESTAMP))

# Convert the time difference to hours and minutes
#TIME_DIFFERENCE_HOURS=$((TIME_DIFFERENCE / 3600))
#TIME_DIFFERENCE_MINUTES=$(((TIME_DIFFERENCE % 3600) / 60))

# Output the time difference
#echo "Time difference: ${TIME_DIFFERENCE_HOURS}h ${TIME_DIFFERENCE_MINUTES}m"