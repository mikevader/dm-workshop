#!/usr/bin/env bash

set -e

# Check if files is part of a chart and returns the root folder
# Usage ./find-chart-dirs.sh path

current_dir="$1"
while [ "$current_dir" != "/" ]; do
    if [ -e "$current_dir/Chart.yaml" ]; then
        result+=("$current_dir")
        break
    fi
    current_dir=$(dirname "$current_dir")
done

if [ "$current_dir" == "/" ]; then
  printf >&2 "Provided path (%s) is not part of a Helm chart" "$1"
  exit 1
fi

printf "%s\n" "$current_dir"
