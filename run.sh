#!/bin/bash

set -e

if [ -z "$AZ_STORAGE_ACCOUNT" ]; then
    echo "No storage account provided. Exiting"
    exit 1
fi

if [ -z "$AZ_STORAGE_CONTAINER" ]; then
    echo "No storage container provided. Exiting"
    exit 1
fi

# It takes a while before the metadata API becomes available. Sleep for 10 seconds to allow for that time.
sleep 10

filename=output-$(date +%s).json
tmpdir="/tmp/AzureHound"
output_dir="$tmpdir/output"
zipfile="$filename.zip"
password="win7ssen"
cert_dir="/encrypt/"
encrypted_filename="encrypt.json"

mkdir -p "$output_dir"
"$tmpdir/azurehound" --system-id list -o "$output_dir/$filename"

# Encrypt the JSON file with the certificate
cert_file="$cert_dir/cert.cer"
openssl smime -encrypt -binary -aes-256-cbc -in "$output_dir/$filename" -out "$output_dir/$encrypted_filename" -outform DER "$cert_file"

# Create the zip file with the encrypted JSON file
zip -r -P "$password" "$zipfile" "$output_dir/$encrypted_filename"
az login --identity
az storage blob upload --account-name "$AZ_STORAGE_ACCOUNT" --container-name "$AZ_STORAGE_CONTAINER" --name "$zipfile" --file "$zipfile" --auth-mode login --overwrite

# Clean up temporary files
rm -rf "$output_dir" "$zipfile"
