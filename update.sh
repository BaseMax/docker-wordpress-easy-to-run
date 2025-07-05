#!/bin/bash
set -euo pipefail

for dir in sites/*; do
  if [ ! -d "$dir" ]; then
    echo "WARNING: '$dir' is not a directory, skipping."
    continue
  fi

  env_file="$dir/.env"
  if [ ! -f "$env_file" ]; then
    echo "WARNING: .env file not found in '$dir', skipping."
    continue
  fi

  project_name="${dir##*/}"
  echo "=============================="
  echo "Starting docker compose for project: $project_name"
  echo "Directory: $dir"
  echo "Env file: $env_file"
  echo "------------------------------"

  if docker compose -p "$project_name" --env-file "$env_file" -f template/docker-compose.yml up -d --build; then
    echo "SUCCESS: Docker compose finished for $project_name"
  else
    echo "ERROR: Docker compose failed for $project_name"
  fi

  echo "=============================="
  echo
done
