#!/bin/sh
# Install cron scripts
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
LOC="$HOME/.dotfiles"

# Check install location
$(dirname $(readlink -f $0))/check.sh "none"
if [ $? -ne 0 ]; then
	exit 1
fi

if [ $# -eq 0 ]; then
	echo "Cron scripts required"
	exit
fi

for arg in $@; do
	if [ -z "$(find "$LOC/configs/cron" -name "$arg*")" ]; then
		echo "Could not find cron script '$arg'"
		exit 1
	elif [ "$(find "$LOC/configs/cron" -name "$arg*" | wc -l)" -gt 1 ]; then
		echo "Multiple cron scripts found for '$arg'"
		exit 1
	fi
	file="$(find "$LOC/configs/cron" -name "$arg*")"
	name="$(basename "$file" | sed -E 's/\.[a-z]+$//')"

	case "$file" in
		*.hourly) sudo cp "$file" /etc/cron.hourly/$name ;;
		*.daily) sudo cp "$file" /etc/cron.daily/$name ;;
		*.weekly) sudo cp "$file" /etc/cron.weekly/$name ;;
		*.monthly) sudo cp "$file" /etc/cron.monthly/$name ;;
		*.cron) sudo cp "$file" /etc/cron.d/$name ;;
		*) echo "Unknown cron script type for '$file'"; exit 1 ;;
	esac
	printf "\033[1;32m%s\033[0m\n" "[Cron] Installed script '$(basename $file)'"
done
