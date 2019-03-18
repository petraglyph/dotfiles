#!/bin/sh
# Dark Sky Weather API Call

#                   稜
icons="
:clear-day:
:clear-night:
:partly-cloudy-day:
:partly-cloudy-night:
:cloudy:
:rain:
:snow:
:sleet:
:wind:
:fog:
:unknown:稜
"

if [ $# == 0 ]; then 
    echo "ERROR: requires parameters"
else 
    weather="$HOME/.bin/weather.json"
    if [[ $2 != "noupdate" ]]; then 
        #Charlottesville: 38.02981,-78.51977
        #Arlington: 38.88756,-77.12322
        loc="38.029812,-78.519775"
        #https://api.darksky.net/forecast/[key]/[latitude],[longitude]
        apikey=$(cat $HOME/.api/darksky)
        curl "https://api.darksky.net/forecast/$apikey/$loc?exclude=minutely,hourly,alerts&units=us" -o $weather 2> /dev/null
        
    fi

    if [ $1 == "bar" ]; then
        temp=$(printf '%.0f' $(jq .currently.temperature $weather))
        condition=$(jq .currently.icon $weather | cut -d'"' -f 2)
        if [ $(echo "$icons" | grep ":$condition:" | wc -l) == 1 ]; then 
            icon=$(echo "$icons" | grep ":$condition:" | cut -d":" -f 3)
        else
            icon=$(echo "$icons" | grep ":unknown:" | cut -d":" -f 3)
        fi
        echo "%{F#2EB398}$icon%{F} $temp°F"
    fi
fi 