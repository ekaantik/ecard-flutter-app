#!/bin/bash

connected=false

while [ "$connected" = false ]; do
    adb connect "$PHONE_IP_ADDRESS":5555

    if adb devices | grep "$PHONE_IP_ADDRESS:5555" >/dev/null; then
        connected=true
        echo "Device connected successfully!"
        # Add your desired commands or script here
    else
        echo "Device connection failed. Retrying in 5 seconds..."
        sleep 5
    fi
done

cd /app
flutter run -d "$PHONE_IP_ADDRESS"
