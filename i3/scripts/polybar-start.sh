#/bin/sh
# Start polybar

for n in $(pgrep polybar); do
	kill $n
done

# Launch bar1 and bar2
for bar in "$@"; do
	polybar $bar &
done
