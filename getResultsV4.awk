#!/bin/awk -f

#Luke De Vos
#Script extracts results from JGAAP experiment files. Only works when there are exactly two authors

#To use:
#	awk -f getResultsV4.awk [PATH TO RESULTS FILE]

BEGIN{counter=0;ties=0;a1=0;a2=0;a1Correct=0;a1Incorrect=0;a2Correct=0;a2Incorrect=0}
{

#when program passes title of experiment...
if ($2 ~ /by/) {
	counter++			#counter ensures the expected format of the results file is maintained
	currentFile = $1	#currentFile used to fill misidentified var when file is misidentified
	correctAuthor = $3

	#determine names of both authors
	if ((a1 == 0) || (a2 == 0)){
		if ((a1 == 0) && (a2 == 0)) {a1 = $3}
		else if ((a1 != $3)) {a2 = $3}
	}
} 

#when program passes rankings of guessed authors...
if ($1 ~ /^1\./){
	counter--
	if (correctAuthor == $2){		#$2 is the guessed author
		if (correctAuthor == a1) {a1Correct++}
		else if (correctAuthor == a2) {a2Correct++}
		else {print "author not recognized"}
	}
	else {
		misidentifieds = misidentifieds "\n  " currentFile
		if (correctAuthor == a1) {a1Incorrect++}
		else if (correctAuthor == a2) {a2Incorrect++}
		else {print "author not recognized"}
	}
}

#if counter is less than 0, then two lines beginning with "1." must have been passed without passing the word "by", indicating there was a tie
if ((counter < 0)) {
	ties++; 
	counter=0; 
}
}
END{
print a1 " vs " a2
if (ties > 0) {print "Ties: " ties}
print "True Author: " a1
print "    Correct: " a1Correct
print "  Incorrect: " a1Incorrect
print "True Author: " a2
print "    Correct: " a2Correct
print "  Incorrect: " a2Incorrect
print "Incorrectly Matched Files:" misidentifieds
if (ties > 0) {print "Ties Detected"}
}

