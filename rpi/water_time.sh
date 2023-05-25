#!/bin/bash

echo "It is time to water the plant my dudes"

# Configuration
INFLUXDB_URL="http://localhost:8086"
DATABASE="esp8266_count"
MEASUREMENT="mqtt_consumer"

# Query to retrieve the last message
QUERY="SELECT last("value") FROM \"$MEASUREMENT\" WHERE ("topic"::tag = 'pico/last_pump')"

# Perform the query
RESPONSE=$(curl -s -G "$INFLUXDB_URL/query" --data-urlencode "db=$DATABASE" --data-urlencode "q=$QUERY")

# Extract the last message from the response
LAST_MESSAGE=$(echo "$RESPONSE" | jq -r '.results[0].series[0].values[0]')

# Output the last message
echo "Last message: $LAST_MESSAGE"