#!/bin/bash

indexarray=(G T L Phi Alpha )
tLen=${#indexarray[@]}

for (( j=0; j<${tLen}; j++ ));
do
	Post=Dependable/PostProcessed/${indexarray[$j]}

	touch ${Post}/ProbabilityDivided.dat
	touch ${Post}/MaxProbability.dat
	touch ${Post}/MaxProb.dat

	python MaxProbability.py ${Post}/Probability.dat ${Post}/ProbabilityDivided.dat ${Post}/MaxProbability.dat
	python Indexation.py ${Post}/index.dat ${Post}/MaxProbability.dat ${Post}/MaxProb.dat
done
