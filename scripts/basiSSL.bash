#!/bin/bash

echo "Enter the website (without https://, just domain like www.example.com):"
read website

echo "Choose an option:"
echo "1) Get website cert fingerprint (SHA256, lowercase, no colons)"
echo "2) Get detailed server certificate info"
echo "3) Save certificate chain to file"
read -p "Enter option number: " option

case $option in
  1)
    echo "Fetching fingerprint..."
    echo | openssl s_client -connect ${website}:443 2>/dev/null | \
      openssl x509 -noout -fingerprint -sha256 | \
      sed 's/://g' | tr '[:upper:]' '[:lower:]' | \
      sed 's/sha256 fingerprint=//g'
    ;;
  2)
    echo "Fetching detailed certificate info..."
    echo | openssl s_client -connect ${website}:443 2>/dev/null | \
      openssl x509 -noout -text -fingerprint -sha256
    ;;
  3)
    output_file=$(echo $website | sed 's/www\.//' | sed 's/\./_/g').chain
    echo "Saving cert chain to $output_file ..."
    echo | openssl s_client -showcerts -connect ${website}:443 2>/dev/null | \
      sed --quiet '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "$output_file"
    echo "Saved to $output_file"
    ;;
  *)
    echo "Invalid option."
    ;;
esac
