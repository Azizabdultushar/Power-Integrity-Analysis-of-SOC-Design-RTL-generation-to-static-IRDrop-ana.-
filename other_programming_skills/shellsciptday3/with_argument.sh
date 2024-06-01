#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <name>"
    exit 1
fi

# Print a greeting message using the provided argument
echo "Hello, $1!"
