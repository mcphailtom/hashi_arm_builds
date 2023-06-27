#!/bin/bash

# Function to compare two server-spec semver strings
is_later_version() {
    local current_version="$1"
    local new_version="$2"

    # Remove leading "v" if present
    current_version="${current_version#v}"
    new_version="${new_version#v}"

    # Extract semver and trailing information
    current_semver="${current_version%%[+-]*}"
    new_semver="${new_version%%[+-]*}"

    # Split semver parts into array elements using '.' as the delimiter
    IFS='.' read -ra current_parts <<< "$current_semver"
    IFS='.' read -ra new_parts <<< "$new_semver"

    # Iterate through each semver part
    for ((i=0; i<${#current_parts[@]}; i++)); do
        current_part="${current_parts[i]}"
        new_part="${new_parts[i]}"

        # Remove leading zeros for numeric comparison
        current_part="${current_part#"${current_part%%[!0]*}"}"
        new_part="${new_part#"${new_part%%[!0]*}"}"

        # Convert to numeric values (treat non-numeric parts as zero)
        current_part_value=$(echo "$current_part" | bc)
        new_part_value=$(echo "$new_part" | bc)

        # Compare the semver parts
        if ((new_part_value > current_part_value)); then
            return 0  # New version is later
        elif ((new_part_value < current_part_value)); then
            return 1  # New version is not later
        fi
    done

    # Compare the remaining parts after the common semver parts
    if [[ "${new_version#"$new_semver"}" != "${current_version#"$current_semver"}" ]]; then
        return 0  # New version has remaining parts, consider it later
    fi

    # The new version is not later
    return 1
}

# Get the current and new versions from command-line arguments
current_version="$1"
new_version="$2"

# Check if the current and new versions are provided
if [ -z "$current_version" ] || [ -z "$new_version" ]; then
    echo "Usage: bash compare_versions.sh <current_version> <new_version>"
    exit 1
fi

if is_later_version "$current_version" "$new_version"; then
    echo "The new version is later."
    exit 0  # Exit with 0 to indicate success
else
    echo "The new version is not later."
    exit 2  # Exit with a non-zero code to indicate failure
fi
