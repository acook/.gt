function gt_get_weather {
	curl --silent "http://xml.weather.yahoo.com/forecastrss?p=60651&u=c"
}

function gt_grep_current_conditions_line {
	grep -E '(Current Conditions:|C<BR)'
}

function gt_sed_current_conditions {
	sed -e 's/Current Conditions://' -e 's/<br \/>//' -e 's/<b>//' -e 's/<\/b>//' -e 's/<BR \/>//' -e 's/<description>//' -e 's/<\/description>//'
}

gt_get_weather
| gt_grep_current_conditions_line | get_sed_current_conditions

echo \!\!\!
