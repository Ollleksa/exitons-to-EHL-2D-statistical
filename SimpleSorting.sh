#!/bin/bash

if [ ! -d Dependable/Initial ];
then
	mkdir Dependable/Initial
	mkdir Dependable/PostProcessed
fi

indexarray=(G T L Phi Alpha )
tLen=${#indexarray[@]}

for (( j=0; j<${tLen}; j++ ));
do
	if [ ! -d Dependable/Initial/${indexarray[$j]} ];
	then
		mkdir Dependable/Initial/${indexarray[$j]}
	fi
	
	if [ ! -d Dependable/PostProcessed/${indexarray[$j]} ];
	then
		mkdir Dependable/PostProcessed/${indexarray[$j]}
	fi
	
	#if [ -f Dependable/*L${i}0* ];
	#then
	mv Dependable/*${indexarray[$j]} Dependable/Initial/${indexarray[$j]}
	#else
	#	echo "No data/unsorted data for L =" ${i}
	#fi

done
