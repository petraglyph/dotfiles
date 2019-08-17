#!/bin/sh
# Dark Sky Weather API Call

#                   稜
icons="
:clear-day:
:clear-night:
:partly-cloudy-day:
:partly-cloudy-night:
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
        #Charlottesville, VA: 38.02981,-78.51977
        #Arlington, VA: 38.88756,-77.12322
		#Roseville, CA: 38.6916199,-121.2352681
        loc="38.6916199,-121.2352681"
        #https://api.darksky.net/forecast/[key]/[latitude],[longitude]?exclude=minutely,hourly,alerts&units=us
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
        echo "%{A:bash /home/penn/.bin/darksky-weather.sh notify noupdate:}%{F#2EB398}$icon%{F} $temp°F%{A}"
    elif [ $1 == "notify" ]; then 
        dunstify -u low -r 1 -t 10000 "This Week's Forecast" "$(jq .daily.summary $weather | cut -d'"' -f 2)"
        dunstify -u low -r 2 -t 10000 "Today's Forecast" "$(jq .daily.data[0].summary $weather | cut -d'"' -f 2) ($(printf '%.0f' $(jq .daily.data[0].temperatureHigh $weather))°F/$(printf '%.0f' $(jq .daily.data[0].temperatureLow $weather))°F)"
        dunstify -u low -r 3 -t 10000 "$(date --date="+1 days" +%A)'s Forecast" "$(jq .daily.data[1].summary $weather | cut -d'"' -f 2) ($(printf '%.0f' $(jq .daily.data[1].temperatureHigh $weather))°F/$(printf '%.0f' $(jq .daily.data[0].temperatureLow $weather))°F)"
    fi
fi 
