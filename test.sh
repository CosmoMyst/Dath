./build.sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

BOLD=$(tput bold)
NW=$(tput sgr0)

printf "\nRunning unit tests...\n\n"

dub test --arch=x86_64 --compiler=ldc2

rc=$?;

printf "\n"
now=$(date +"%c")

if [ $rc != 0 ]
then
    printf "Tests ${RED}${BOLD}failed${NW}${NC} in ${SECONDS} seconds at $now"
else 
    printf "Tests ${GREEN}${BOLD}passed${NW}${NC} in ${SECONDS} seconds at $now"
fi

printf "\n"