#!/bin/bash

PORT="/dev/ttyACM0"
BAUDRATE=115200

# Function to write 'p' to the serial port
write_to_serial() {
    echo -n 'p' > "$PORT"
}

# Main script logic
write_to_serial