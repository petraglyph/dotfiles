#/bin/sh

# Bar
#bar {
#    status_command bash $loc/scripts/conky-wrap.sh
#    i3bar_command i3bar
#    font pango:Material Design Icons 12
#    strip_workspace_numbers yes
#    position top
#    output eDP1
#    
#	colors {
#		background	$c-backgnd
#	    separator	$c-backgnd
#		#                    border		 background   text
#		focused_workspace    $c-backgnd  $c-backgnd   $c-high-n
#        inactive_workspace   $c-backgnd  $c-backgnd   $c-text
#        urgent_workspace     $c-backgnd  $c-backgnd   $c-high-b
#	}
#}

# Send the header so that i3bar knows we want to use JSON:
echo '{"version":1}'

# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[],'

# Now send blocks with information forever:
exec conky -c $HOME/.conky/i3bar-json
