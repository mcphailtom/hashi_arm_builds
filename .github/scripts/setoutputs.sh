#!/bin/bash

# Define the default value for missing keys
default_value="0.0.0"

# Get the filename from the command-line argument
filename=$1

# Check if the filename is provided
if [ -z "$filename" ]; then
  echo "No filename provided."
  exit 0
fi

# Check if the file exists
if [ ! -f "$filename" ]; then
  echo "File $filename does not exist, creating it."
    touch "$filename"
fi

# Remove the first argument (filename) from the arguments list
shift

# Read the key-value pairs from the file if it exists
if [ -f "$filename" ]; then
  # Create a regular array to track outputted keys
  outputted_keys=()

  while IFS='=' read -r key value; do
    # Skip empty lines or lines starting with #
    if [[ -z $key || $key == '#'* ]]; then
      continue
    fi

    # Check if the key is provided as an argument
    if [[ "$@" =~ (^| )"$key"($| ) ]]; then
      # Append the key-value pair to the GITHUB_OUTPUT file
      echo "$key=$value" >> "$GITHUB_OUTPUT"
      # Add the key to the outputted_keys array
      outputted_keys+=("$key")
    fi
  done < "$filename"
fi

# Handle missing keys
for key in "$@"; do
  # Check if the key has been outputted
  if ! [[ " ${outputted_keys[*]} " =~ " $key " ]]; then
    # Append the key with the default value to the GITHUB_OUTPUT file
    echo "$key=$default_value" >> "$GITHUB_OUTPUT"
  fi
done
