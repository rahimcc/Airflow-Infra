#!/bin/bash

mkdir -p ./dags ./logs ./plugins ./config
#echo -e "AIRFLOW_UID=$(id -u)" > .env

VALID_PROFILES=("dev" "production")

PROFILE=${1}

if [[ ! " ${VALID_PROFILES[@]} " =~ " ${PROFILE} " ]]; then
  echo "Error: '$PROFILE' is not a valid profile. Choose from: ${VALID_PROFILES[*]}"
  echo "================================"
  echo "USAGE: ./deploy.sh  <profile>"
  exit 1
fi

mkdir -p ./dags ./logs ./plugins ./config
#echo -e "\nAIRFLOW_UID=$(id -u)" >> .env

echo "Deploying with ${PROFILE} profile"
if [[  $1 == "dev " ]]; then
    docker compose down -v
    docker compose up --env-file .env.prod -d --build
else
    docker compose --profile $PROFILE down 
    docker compose --env-file .env.dev --profile $PROFILE up -d --build 
fi