#!/bin/bash

shopt -s nullglob dotglob     # To include hidden files

parameterarray=(G T L Phi Alpha)
tLen=${#parameterarray[@]}

for (( j=0; j<${tLen}; j++ ));
do
	Initial=Dependable/Initial/${parameterarray[$j]}
	Post=Dependable/PostProcessed/${parameterarray[$j]}

	files=(Dependable/PostProcessed/${parameterarray[$j]}/*)
	if [ ${#files[@]} -eq 0 ]; 
	then 
		echo "no postprocessing information here"
	else 
		rm -rfv Dependable/PostProcessed/${parameterarray[$j]}/*
		echo "no postprocessing information here now"	
	fi

	array=(${Initial}/g*)
	tlen2=${#array[@]}

	MaxLines=0
	for (( i=0; i<${tlen2}; i++ ));
	do
		NumofLines=$(wc -l < "${array[$i]}")
		if [[ $NumofLines>$MaxLines ]]; then
			MaxLines=$NumofLines
			MaxFile=${array[$i]}
		fi
	done
	echo $MaxFile
	cp $MaxFile ${Post}/Probability.dat

	for (( i=0; i<${tlen2}; i++ ));
	do
		filename=$(basename "${array[$i]}")
		probname=${filename:1}

		indexname=${filename:1:3}	
		echo $indexname >> ${Post}/index.dat
	
		indexarray=(${Initial}/*${probname})

		inlen=${#indexarray[@]}
		cp ${indexarray[0]} ${Post}/${probname}.dat
		for (( k=1; k<${inlen}; k++ ));
		do
			paste --delimiters='\t' ${Post}/${probname}.dat ${indexarray[$k]} >> ${Post}/${probname}.tmp
			cp ${Post}/${probname}.tmp ${Post}/${probname}.dat
			rm ${Post}/${probname}.tmp
		done

		paste --delimiters='\t' ${Post}/Probability.dat ${Initial}/Prob${probname} >> ${Post}/Probability.tmp
		cp ${Post}/Probability.tmp ${Post}/Probability.dat
		rm ${Post}/Probability.tmp

		echo $indexname
	done
done
