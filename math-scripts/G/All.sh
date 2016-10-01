#!/bin/bash
n=5
nmax=10

#./OneIsland.m
echo "One Island - done!"
#./TorIsland.m
echo "Tor Island - done!"
while [ ${n} -le ${nmax} ]; do
	#./ManyIsland.m ${n}
	echo Many Island ${n} -"done"

	./CenterIsland.m ${n}
	echo Center Island ${n} -"done"
	let n=n+1	
done
