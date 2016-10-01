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

	python AllPlots.py ${Post}/One${lenght}.dat 1 ${Plot}/

	for f in ${Post}/*Man${lenght}.dat
	do
		python AllPlots.py $f 2 ${Plot}/
	done

	for d in ${Post}/*Cen${lenght}.dat
	do
		python AllPlots.py $d 3 ${Plot}/
	done
done
