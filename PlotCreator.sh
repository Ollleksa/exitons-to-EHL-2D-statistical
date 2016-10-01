#!/bin/bash

if [ ! -d Dependable/Plots ];
then
	mkdir Dependable/Plots
fi

indexarray=(G T L Phi Alpha )
tLen=${#indexarray[@]}

for (( j=0; j<${tLen}; j++ ));
do
	if [ ! -d Dependable/Plots/${indexarray[$j]} ];
	then
		mkdir Dependable/Plots/${indexarray[$j]}
	fi
done

for (( j=0; j<${tLen}; j++ ));
do
	lenght="${indexarray[$j]}"

	Post=Dependable/PostProcessed/${lenght}
	Plot=Dependable/Plots/${lenght}

	python NumberofIsland.py ${Post}/MaxProb.dat ${Plot}/NumberofIslands.png
done
