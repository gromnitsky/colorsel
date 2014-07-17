#!/bin/sh

# Requires:
#
# * fedora/ubuntu packages: vorbis-tools, sound-theme-freedesktop
#
# * xtermcontrol - ubuntu has a package for it; in fedora google it,
# compile & put a binary in the PATH.

cfg_tty=""
cfg_dir=""

errx()
{
	echo "`basename $0` error: $1" 1>&2
	exit 1
}

warnx()
{
	echo "`basename $0` warning: $1" 1>&2
}

# Return >=1 on error.
prerequisites()
{
	local r=0
	for idx in "$@"
	do
		which $idx > /dev/null 2>&1 || {
			warnx "'$idx' not found in path"
			r=$((r+1))
		}
	done

	return $r
}

play()
{
	local times
	local sound

	times=1
	sound=message.oga

	[ "$1" = 'error' ] && {
		times=3
		sound=bell.oga
	}

	ogg123 -q $(for idx in `seq $times`; do
		echo /usr/share/sounds/freedesktop/stereo/$sound
		done)
}

usage()
{
	echo "usage: `basename $0` -t TTY"
	exit 1
}


# Main

while getopts d:t:h opt
do
	case $opt in
		t)
			cfg_tty=$OPTARG
			;;
		d)
			cfg_dir=$OPTARG
			;;
		*|h)
			usage
			;;
	esac
done
shift `expr $OPTIND - 1`

prerequisites seq make ogg123 xtermcontrol || exit 1
[ ! -d /usr/share/sounds/freedesktop/stereo ] && \
	errx "install sound-theme-freedesktop package"

[ -z "$cfg_tty" ] && usage
[ -z "$cfg_dir" ] || {
	cd "$cfg_dir" > $cfg_tty 2>&1 || exit 1
}

printf "\033c" > $cfg_tty		# clear xterm history
make > $cfg_tty 2>&1

if [ $? -eq 0 ]; then
	play ok
else
	xtermcontrol --raise --force > $cfg_tty
	play error
fi
