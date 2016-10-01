#!/bin/bash

./SimpleSorting.sh

indexarray=(One 2Man 3Man 4Man 5Man 6Man 7Man 8Man 9Man 10Man Tor 2Cen 3Cen 4Cen 5Cen 6Cen 7Cen 8Cen 9Cen 10Cen)
tLen=${#indexarray[@]}
#echo ${indexarray[2]}
lenght_number=21

for (( i=1; i<${lenght_number}; i++ ));
do
	work_dir=Dependable/Initial/L${i}
	for (( j=0; j<${tLen}; j++ ));
	do
		if [ -f ${work_dir}/g${indexarray[$j]}L${i}0. ];
		then
			echo "${work_dir}/g${indexarray[$j]}L${i}0. - exist"
		else
			if [ $j -eq 0 ]
			then 
				echo L${i} ${indexarray[$j]} missed
				./mathematica_scripts/OneIsland.m ${i}0
				echo L${i} ${indexarray[$j]} is ok now

			elif [ $j -lt 10 ]
			then 
				k=$(( j+1 ))
				echo L${i} ${indexarray[$j]} missed
				./mathematica_scripts/ManyIsland.m ${i}0 ${k}
				echo L${i} ${indexarray[$j]} is ok now
			elif [ $j -eq 10 ]
			then 
				echo L${i} ${indexarray[$j]} missed
				./mathematica_scripts/IslandTor.m ${i}0
				echo L${i} ${indexarray[$j]} is ok now
			else
				k=$(( j-9 ))
				echo L${i} ${indexarray[$j]} missed
				./mathematica_scripts/CenterIsland.m ${i}0 ${k}
				echo L${i} ${indexarray[$j]} is ok now
			fi
		fi
	done
done
