#!/bin/bash
# This script hides autosaves from Steam Cloud to speed up sync.
# - Save it as '~/.factorio/autosave-segregator.sh'
# - Make it executable: `chmod +x ~/.factorio/autosave-segregator.sh`
# - Edit Factorio launch options in Steam to run "~/.factorio/autosave-segregator.sh %command%"

printf '\nFactorio autosave segregator\n\n'

savedir=saves
autodir=autosaves

workdir=$(cd "$(dirname "$0")"; pwd)
printf 'Working directory: %q\n' "$workdir"

(
	cd "$workdir"

	printf 'Save directory: %q\n' "$savedir"
	if [[ ! -d "$savedir" ]]; then
		printf '[Does not exist, creating.]\n'
		mkdir "$savedir"
	fi

	printf 'Autosave directory: %q\n' "$autodir"
	if [[ ! -d "$autodir" ]]; then
		printf '[Does not exist, creating.]\n'
		mkdir "$autodir"
	fi

	printf '\nRestoring autosaves...\n'
	mv -fv "$autodir"/* "$savedir"/
	printf 'Autosaves restored.\n'
)

printf '\nStarting Factorio...\n\n'
"$@" || printf '\n\nFactorio Exit Code: %d\n' $?
printf '\n\nFactorio terminated.\n'

(
	cd "$workdir"

	printf '\nStashing autosaves...\n'
	mv -fv "$savedir"/_autosave*.zip "$autodir"/
	printf 'Autosaves stashed.\n'
)

printf '\nFactorio autosave segregator Done.\n\n'
