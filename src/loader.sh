#!/usr/bin/env bash

function clearLastLine() {
        tput cuu 1 && tput el
}

arr=('-' '\' '|' '/')
while true; do
	for c in "${arr[@]}"; do
        clear

		echo -e "\r $c "
        echo -e "\r $c "
        echo -e "\r $c "
        echo -e "\r $c "
        
		sleep 1
	done
done
