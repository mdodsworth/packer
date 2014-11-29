#!/bin/bash

# Imports a key across all regions
regions=$(aws ec2 describe-regions --output text | cut -f 2 | cut -d . -f 2)
OPTIND=1

usage() {
  cat << EOF >&2
usage: $0 -k <key name> -f <public key>
EOF
}

while getopts "k:f:" arg; do
  case $arg in
    k)
      keyname=$OPTARG
      ;;
    f)
      filename=$OPTARG
      ;;
    \?)
      usage
      exit 1
      ;;
  esac
done

if [[ -z $keyname ]] || [[ -z $filename ]]; then
  usage
  exit 1
fi

for region in $regions; do
  aws ec2 import-key-pair --key-name $keyname --public-key-material file://$filename --region $region
done
shift $((OPTIND-1))

