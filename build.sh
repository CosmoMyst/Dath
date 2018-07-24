#!/bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

BOLD=$(tput bold)
NW=$(tput sgr0)

printf "\nBuilding...\n\n"

dub build --arch=x86_64 --compiler=ldc2

rc=$?;

printf "\n"
now=$(date +"%c")

if [ $rc != 0 ]
then
    printf "Build ${RED}${BOLD}failed${NW}${NC} in ${SECONDS} seconds at $now"
else 
    printf "Build ${GREEN}${BOLD}succeeded${NW}${NC} in ${SECONDS} seconds at $now"
fi

printf "\n"
