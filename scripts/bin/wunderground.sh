#!/bin/sh
# Wunderground format

icons="
sunny:
clear:
mostlysunny:
partlycloudy:
partlysunny:
mostlycloudy:
cloudy:

flurries:
fog:
hazy:
rain:
sleet:
snow:
tstorms:
unknown:稜
"

zip="22904"
apikey=$(cat $HOME/.api/wunderground)
curl "http://api.wunderground.com/api/$apikey/conditions/q/$zip.json" -o $HOME/.bin/weather.json 2> /dev/null
weather="$HOME/.bin/weather.json"

temp=$(jq .current_observation.temp_f $weather)
condition=$(jq .current_observation.icon $weather | cut -d'"' -f 2)
icon=$(echo "$icons" | grep "$condition" | cut -d":" -f 2)
echo "%{F#2EB398}$icon%{F} $temp°F"



iconsDetailed="
sunny:
0/8 cloud cover
clear:
0/8 cloud cover

mostlysunny:
1-2/8 cloud cover, day

partlycloudy:
3-5/8 cloud cover
partlysunny:
3-5/8 cloud cover, day

mostlycloudy:
6-7/8 cloud cover
cloudy:
7-8/8 cloud cover

chanceflurries:
chancerain:
chancesleet:
chancesnow:
chancetstorms:

flurries:
fog:
hazy:
rain:
sleet:
snow:
tstorms:
unknown:稜
        
"