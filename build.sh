#!/bin/bash

# Define board and port
BOARD="esp32:esp32:nodemcu-32s"
PORT="/dev/cu.usbserial-0001"

# Check if the --verbose flag is passed as an argument
if [[ "$1" == "--verbose" ]]; then
    VERBOSE_FLAG="--verbose"
    echo "Verbose logging enabled"
else
    VERBOSE_FLAG=""
fi

# Compile the code with or without verbose output
echo "Compiling for board: $BOARD"
arduino-cli compile --fqbn $BOARD $VERBOSE_FLAG

# Check if the compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful, uploading to $PORT..."
    
    # Upload the code with or without verbose output
    arduino-cli upload -p $PORT --fqbn $BOARD $VERBOSE_FLAG
    
    if [ $? -eq 0 ]; then
        echo "Upload successful!"
        
        # Start the serial monitor after a successful upload
        echo "Starting serial monitor on $PORT at 115200 baud..."
        arduino-cli monitor -p $PORT --config baudrate=115200
    else
        echo "Upload failed!"
    fi
else
    echo "Compilation failed, skipping upload and monitor."
fi
