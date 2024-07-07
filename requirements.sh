#!/bin/bash

# Set default requirements file
requirements_file="./requirements.txt"

# Check if an argument is provided
if [ $# -eq 1 ]; then
    requirements_file="$1"
fi

# Check if the requirements file exists
if [ ! -f "$requirements_file" ]; then
    echo "Error: $requirements_file not found"
    exit 1
fi

# Read requirements file line by line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^#.*$ ]]; then
        continue
    fi

    # Check if the line matches the expected format (package==version)
    if ! [[ "$line" =~ ^[a-zA-Z0-9_-]+==.+$ ]]; then
        echo "Error: Invalid format in line: $line"
        echo "Expected format: package==version"
        exit 1
    fi

    # Extract package name and version
    package=$(echo "$line" | cut -d'=' -f1)
    version=$(echo "$line" | cut -d'=' -f2-)

    # Run rye add command
    echo "--- Adding $package==$version ---"
	echo ""
    if ! rye add "$package==$version"; then
        echo "Error: Failed to install $package==$version"
        exit 1
    fi
	echo ""
done < "$requirements_file"

# Run rye sync command
rye sync

echo "All packages have been successfully added using rye"