#!/usr/bin/env sh

cd /
apt update && apt install -y git curl subversion
curl -o release.sh https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh

cd /MountJournalEnhanced

bash /release.sh -d -c -l -o -u -z -r /

rm CHANGELOG.md
