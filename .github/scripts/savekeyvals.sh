#!/bin/bash

# Get the filename from the command-line argument
filename=$1

# Check if the filename is provided
if [ -z "$filename" ]; then
  echo "No filename provided."
  exit 1
fi

if [ -f "$filename" ]; then
  echo "File $filename already exists, removing it."
  rm "$filename"
fi

# Check if any arguments are provided (starting from the second argument)
if [ $# -lt 2 ]; then
  echo "No key-value arguments provided."
  exit 1
fi

# Shift the arguments to skip the filename
shift

# Loop through the provided key-value arguments
for arg in "$@"; do
  # Check if the argument is in the key=value format
  if [[ "$arg" != *=* ]]; then
    echo "Invalid argument format: $arg. Arguments must be in the key=value format."
    exit 1
  fi

  # Split the argument into key and value using the "=" delimiter
  IFS='=' read -ra kv <<< "$arg"
  key="${kv[0]}"
  value="${kv[1]}"

  # Append the key-value pair to the output file
  echo "$key=$value" >> "$filename"
done

# Print a success message
echo "Key-value pairs saved to $filename"