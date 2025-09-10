#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change to the script directory
cd "$SCRIPT_DIR"

# Run the publish script
./publish.sh

# Keep terminal window open to show results
echo ""
echo "Press any key to close this window..."
read -n 1 -s