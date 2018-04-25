#!/bin/bash
#smoff 16/11/16
#PRNG based on capturing local sound samples and twice partial hashing via sha512

#Variables
COUNT=0 
TOTAL=5
SAMPLE_DURATION_SECONDS=2

clear
echo "SoundRandom sampler started..."
echo "------------------------------"

while [ $COUNT -lt $TOTAL ]; do
	
	#Captures 5 secs @ 48,000 sample rate
	arecord -q -vv -fdat -d$SAMPLE_DURATION_SECONDS sample.wav
	#Creates a double sha512, taking the middle third only to increase uniqueness, stripping out only digits	
	sha512sum sample.wav | cut -c32-97 | sha512sum | cut -c32-97 | grep [0-9] -o | awk '{print}' ORS='' >> myRandom
	rm -rf sample.wav
	COUNT=$(( $COUNT + 1 ))

done

echo ""
echo "SoundRandom sampler completed.  $TOTAL x $SAMPLE_DURATION_SECONDS second samples created, encoded and stored."
echo "----------------------------------------------------------------------------------"
