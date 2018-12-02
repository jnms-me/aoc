#!/bin/sh
SUM=0
for i in $(cat sum.txt); do
	cat sum.txt | grep -Fx -- $i | uniq -d;
done
