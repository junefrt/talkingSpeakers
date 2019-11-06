#!/bin/bash

##
##		Speech recognition for talking speakers
##		
##		Artwork : Justine Fortier
##		Technical support : Denez Thomas
##

# Takes the json credentials file as parameter (Required)
export GOOGLE_APPLICATION_CREDENTIALS=$1

echo 'Press ctrl-c to stop'

FIRSTPHRASE=$(cat ./data/firstPhrase.txt)
resultsWindow=("" "" "" "")
INDEX=0
num=0
MAX_CHAR=200

# First text to read (only in one of the two Raspberries)
node ./tts/tts.js "$FIRSTPHRASE"
echo ""
echo "Saying: $FIRSTPHRASE"
play -q ./tts.mp3 #pitch -120

while true; do 

	# Records mic and asks google for what you said
	echo ""
	echo 'Listening...'
	RESULTS=$(node ./speech2text/recognize.js listen | grep 'Transcription: ' | cut -d : -f 2)

	# If too short, find another phrase on google
	splitResults=($RESULTS)
	if [ ${#splitResults[@]} -eq 1 ]; then
		echo "" 
		echo "Too short! Finding another phrase in google search!"
		RESULTS=$(googler -n 1 --json $RESULTS | jq .[0].abstract)
	fi

	# If phrase isn't short enough, cut it 
	echo ""
	echo "The phrase is ${#RESULTS} characters long."
	if [ ${#RESULTS} -ge $MAX_CHAR ]; then 
		echo "Not short enough! ${#RESULTS} cut down to $MAX_CHAR."
		RESULTS=$(echo $RESULTS | cut -c 1-$MAX_CHAR)
	elif [ ${#splitResults[@]} -eq 0 ]; then
		echo "Oups! The phrase is null! Phrase is now a random google search querry!"

		SAVES=$(cat ./data/saves.txt)
		SAVES_ARRAY=($SAVES)
		let SA_INDEX=RANDOM%${#SAVES_ARRAY[@]}
		RANDOM_WORD=${SAVES_ARRAY[$SA_INDEX]}

		RESULTS=$RANDOM_WORD
		RESULTS=$(googler -n 1 --json $RESULTS | jq .[0].abstract)
		RESULTS=$(echo $RESULTS | cut -c 1-$MAX_CHAR)
	fi

	# Saves the three last results in a table 
	let INDEX=(num%${#resultsWindow[@]})
	resultsWindow[$INDEX]="$RESULTS"
	let num++

	# If the same result occures three times in a row, save it! 
	for i in "${resultsWindow[@]}"; do
		if [[ "${resultsWindow[0]}" != "$i" ]]; then
			same=false
			break
	fi
		same=true
	done
	if [[ $same == true ]]
	then
		echo ""
		echo "The same phrase happened three times in row! Storing it in ./saves.txt"
		echo $RESULTS >> ./data/saves.txt

		#RESULTS=$(googler -n 1 --json $RESULTS | jq .[0].abstract)
		#RESULTS=$(echo $RESULTS | cut -c 1-$MAX_CHAR)

		# RANDOM PHRASE FROM SAVES.TXT
		SAVES=$(cat ./data/saves.txt)
		SAVES_ARRAY=($SAVES)

		for words in {1..21}; do

			let RAND_INDEX=$RANDOM%${#SAVES_ARRAY[@]}
			RANDOM_PHRASE[$words]=${SAVES_ARRAY[$RAND_INDEX]}
			RESULTS="${RANDOM_PHRASE[@]}"
		done
	fi

	# Google Translate text to speech
	echo ""
	echo 'Saying:' $RESULTS
	node ./tts/tts.js "$RESULTS"

	# Outputs result through speakers with SoX
	sleep 2
	play -q ./tts.mp3 #pitch -120

done