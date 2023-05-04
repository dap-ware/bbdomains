#!/usr/bin/env bash

# Usage: ./extract_domains.sh [-bounty] [output.txt]

# URL to download the JSON content
url="https://raw.githubusercontent.com/projectdiscovery/public-bugbounty-programs/main/chaos-bugbounty-list.json"

# Check for the -bounty flag
bounty_flag=false
if [[ "$1" == "-bounty" ]]; then
  bounty_flag=true
  shift
fi

# Check for output file argument (optional)
output_file="$1"

# Function to extract domains based on the bounty flag
extract_domains() {
  if $bounty_flag; then
    # Extract only domains with bounty: true, and ensure that each element has the "bounty" key
    jq -r '.programs[] | select(.bounty? == true) | .domains[]'
  else
    # Extract all domains, and ensure that each element has the "domains" key
    jq -r '.programs[] | select(has("domains")) | .domains[]'
  fi
}

# Download the JSON content and pass it to the extract_domains function for processing
if [[ -n "$output_file" ]]; then
  # If an output file is provided, write the results to the file
  curl -s "$url" | extract_domains > "$output_file"
  echo "Domains extracted to $output_file"
else
  # If no output file is provided, display the results on STDOUT
  curl -s "$url" | extract_domains
fi
