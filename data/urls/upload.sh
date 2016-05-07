split -l 1000 $1 rspider-
ls rspider* | xargs -I FILE curl -X POST -T FILE "http://rspider.mapclipper.com/pages/upload"
rm rspider*
