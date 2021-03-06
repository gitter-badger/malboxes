#!/bin/bash
#
# Olivier Bilodeau <obilodeau@gosecure.ca>
# Copyright (C) 2018 GoSecure Inc.
# All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

export PATH=$PATH:$HOME/.local/bin
pip3 install --upgrade git+https://github.com/GoSecure/malboxes.git#egg=malboxes

echo "Fetching all profiles..."
PROFILES=`malboxes list | head -n-1 | tail -n+3`

# build all profiles
declare -A RESULTS
WORST_EXIT_STATUS=0
for _P in $PROFILES; do
        echo "Building profile $_P"
        malboxes build --force --skip-vagrant-box-add --config config.js $_P
	EXIT_VAL=$?
	if (( $EXIT_VAL > $WORST_EXIT_STATUS )); then
		WORST_EXIT_STATUS=$EXIT_VAL
	fi
        RESULTS[$_P]=$EXIT_VAL
done

echo Finished building all profiles. Results:
for _P in "${!RESULTS[@]}"; do
  echo "$_P: ${RESULTS[$_P]}"
done

# Not necessarily worse but at least non-zero
exit $WORST_EXIT_STATUS
