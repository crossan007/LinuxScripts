#!/bin/bash
shopt -s nullglob
for i in *.AVI; do
  newName="${i%.*}-2.mp4"
  echo "Converting $i to $newName"
  avconv -i "$i" -c:v libx264 -strict -2 "$newName"
done
sudo -u www-data php /var/www/owncloud/occ files:scan
