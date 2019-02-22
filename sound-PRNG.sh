#!/bin/bash
#smoff 16/11/16
#PRNG based on capturing local sound samples and twice partial hashing via sha512

#Variables
COUNT=0 
TOTAL=5
SAMPLE_DURATION_SECONDS=2
OUTPUT=my.random
clear
echo "SoundRandom sampler started..."
echo "------------------------------"

while [ $COUNT -lt $TOTAL ]; do
	
	#Captures 5 secs @ 48,000 sample rate
	arecord -q -vv -fdat -d$SAMPLE_DURATION_SECONDS sample.wav
	#SHA512 hashes the sample file, splits into 4 pieces and uses that to generate a new SHA512 hash that is stored in the output file
	sha512sum sample.wav | cut -c1-32 | sha512sum | grep [0-9] -o | awk '{print}' ORS='' >> $OUTPUT
	sha512sum sample.wav | cut -c33-64 | sha512sum | grep [0-9] -o | awk '{print}' ORS='' >> $OUTPUT
	sha512sum sample.wav | cut -c65-96 | sha512sum | grep [0-9] -o | awk '{print}' ORS='' >> $OUTPUT
	sha512sum sample.wav | cut -c97-128 | sha512sum | grep [0-9] -o | awk '{print}' ORS='' >> $OUTPUT
	rm -rf sample.wav
	COUNT=$(( $COUNT + 1 ))

done

echo ""
echo "SoundRandom sampler completed.  $TOTAL x $SAMPLE_DURATION_SECONDS second samples created, encoded and stored in $OUTPUT."
echo "-----------------------------------------------------------------------------------------------------------------------------"
