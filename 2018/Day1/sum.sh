#!/bin/sh
SUM=0
for i in {0..136}; do
    for j in $(cat file.txt); do
    	SUM=$(($SUM+$j));
        if [ "$i" -eq "136" ]; then
            echo $SUM;
        fi
    done
done
