#!/bin/bash
#
#####     build_a_bible script
####
###
##
#  __  __                  _         ____           _
# |  \/  |   __ _   _ __  | | __    / ___|   __ _  (_)  _ __
# | |\/| |  / _` | | '__| | |/ /   | |      / _` | | | | '_ \
# | |  | | | (_| | | |    |   <    | |___  | (_| | | | | | | |
# |_|  |_|  \__,_| |_|    |_|\_\    \____|  \__,_| |_| |_| |_|
#
##
###
####
#####
# This script converts the text of the Bible from an xml format to markdown and
# orginaizes the folders, files, headers, verses, and footers suitable to use in
# an Obisdian vault
#
# Project Started: February 23, 2021
# Project last edit: February 24, 2021
# Mark Cain

############################
# How to use this script:
#        # download a bible version of your choice in xml format from https://www.ph4.org/b4_mobi.php?q=zefania
#        # put this bash script and the resulting .zip file in the same folder
#        # cd to the directory where the two files are located
#        # run the script with: ./build_a_bible.sh
#        # sit back and watch the magic
#
#####
#
############################
# Check to see if there are zip files in this folder.  If not, abort
if ls ./*zip 1> /dev/null 2>&1; then
    echo "Found a *.zip file.  That's good."
else
		echo "Didn't find any xml versions in zip format.  Please download your choice from https://www.ph4.org/b4_mobi.php?q=zefania"
		echo "and place the zip file in the same folder as this script.  Then, run the script again"
		exit
fi
#####
#
############################
# Since there must be zip files to get this far, check that there is only one.  If more than one, abort
for f in *.zip; do
	counter=$((counter+1))
	if [ $counter -gt 1 ]; then
  	echo "There are too many zip files in the folder.  Only one zip file can be in the same folder as the script."
	  echo "Remove all but one zip file and run the script again."
		exit
	fi
done
#####
#
############################
# Since there is the necessary zip file in the folder, unzip it
echo "Found $f.  Starting the process of converting that file"
unzip $f
#####
#
############################
# Create the master folder based on the Bible version name
bible_version=$(echo $f | sed 's/\(.*\)\.zip/\1/')
echo "main_folder = $bible_version"
mkdir ./$bible_version
#
#######################################
# Array of short book names of the Bible

declare -A short_book_name=( [Genesis]="Gen" [Exodus]="Exo" [Leviticus]="Lev" [Numbers]="Num" [Deuteronomy]="Deu" [Joshua]="Jos" [Judges]="Jdg" [Ruth]="Rut" [1 Samuel]="1Sa" [2 Samuel]="2Sa" [1 Kings]="1Ki" [2 Kings]="2Ki" [1 Chronicles]="1Ch" [2 Chronicles]="2Ch" [Ezra]="Ezr" [Nehemiah]="Neh" [Esther]="Est" [Job]="Job" [Psalms]="Psa" [Psalm]="Psa" [Proverbs]="Pro" [Ecclesiastes]="Ecc" [Song of Solomon]="Sol" [Isaiah]="Isa" [Jeremiah]="Jer" [Lamentations]="Lam" [Ezekiel]="Eze" [Daniel]="Dan" [Hosea]="Hos" [Joel]="Joe" [Amos]="Amo" [Obadiah]="Oba" [Jonah]="Jon" [Micah]="Mic" [Nahum]="Nah" [Habakkuk]="Hab" [Zephaniah]="Zep" [Haggai]="Hag" [Zechariah]="Zec" [Malachi]="Mal" [Matthew]="Mat" [Mark]="Mar" [Luke]="Luk" [John]="Joh" [Acts]="Act" [Romans]="Rom" [1 Corinthians]="1Co" [2 Corinthians]="2Co" [Galatians]="Gal" [Ephesians]="Eph" [Philippians]="Phi" [Colossians]="Col" [1 Thessalonians]="1Th" [2 Thessalonians]="2Th" [1 Timothy]="1Ti" [2 Timothy]="2Ti" [Titus]="Tit" [Philemon]="Phm" [Hebrews]="Heb" [James]="Jam" [1 Peter]="1Pe" [2 Peter]="2Pe" [1 John]="1Jo" [2 John]="2Jo" [3 John]="3Jo" [Jude]="Jud" [Revelation]="Rev" )

#######################################
# Array of the last chapter number for each book

declare -A last_chapter_number=( [Gen]="50" [Exo]="40" [Lev]="27" [Num]="36" [Deu]="34" [Jos]="24" [Jdg]="21" [Rut]="4" [1Sa]="31" [2Sa]="24" [1Ki]="22" [2Ki]="25" [1Ch]="29" [2Ch]="36" [Ezr]="10" [Neh]="13" [Est]="10" [Job]="42" [Psa]="150" [Pro]="31" [Ecc]="12" [Sol]="8" [Isa]="66" [Jer]="52" [Lam]="5" [Eze]="48" [Dan]="12" [Hos]="14" [Joe]="3" [Amo]="9" [Oba]="1" [Jon]="4" [Mic]="7" [Nah]="3" [Hab]="3" [Zep]="3" [Hag]="2" [Zec]="14" [Mal]="4" [Mat]="28" [Mar]="16" [Luk]="24" [Joh]="21" [Act]="28" [Rom]="16" [1Co]="16" [2Co]="13" [Gal]="6" [Eph]="6" [Phi]="4" [Col]="4" [1Th]="5" [2Th]="3" [1Ti]="6" [2Ti]="4" [Tit]="3" [Phm]="1" [Heb]="13" [Jam]="5" [1Pe]="5" [2Pe]="3" [1Jo]="5" [2Jo]="1" [3Jo]="1" [Jud]="1" [Rev]="22" )

#######################################
# functions

function start_a_new_book () {

	# Get the Book Number
	current_book_number_padded=$(echo $one_line | awk -F'"' '{printf "%02d", $2}')

	# Get the Book Name
	current_book_name_full=$(echo $one_line | awk -F'"' '{print $4}')

	# Get the Book Name in a short format
	current_book_name_short=${short_book_name[$current_book_name_full]}

	echo "Making the Folder for the Book of $current_book_name_full"

	# Make a folder for the New Book
	mkdir ./"${current_book_number_padded} - ${current_book_name_full}"
}


function start_a_new_chapter () {

	# A zero padded chapter is needed to keep things in order for the file names
	current_chapter_number=$(echo $one_line | awk -F'"' '{print $2}')
	current_chapter_number_padded=$(echo $one_line | awk -F'"' '{printf "%02d", $2}')

	echo "Making a file for $current_book_name_full $current_chapter_number"

	# print the first line of the file
	echo "# ${current_book_name_full} $current_chapter_number" > ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md

	# print a blank line
	echo "" >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md

	# let's look at the current chapter number and determine which linking header to print
	#  There are 4 possible conditions:
	#	1) It's the first chapter of the book
	#	2) It's the last chapter of the book
	#	3) It's neither the first nor the last chapter
	#	3) It's both the first and the last chapter

	if [ "$current_chapter_number" == 1 ]; then

		if [ "$current_chapter_number" == ${last_chapter_number[$current_book_name_short]} ]; then

			echo "This is the first and last chapter"
			print_heading_first_and_last_chapter


		else

			echo "This is the first chapter of the book"
			print_heading_first_chapter

		fi
	else

		if [ "$current_chapter_number" == ${last_chapter_number[$current_book_name_short]} ]; then

			echo "This is the last chapter of the book"
			print_heading_last_chapter

		else

			print_heading_middle_chapter
		fi
	fi

	# print a horizontal rule separating the header from the the text
	echo "***" >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md

	# Separate the header from the text with a blank line
	echo "" >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md

}

function print_heading_first_chapter () {

	next_chapter_number=$(echo $((current_chapter_number+1)) | awk '{print $1}')
	next_chapter_number_padded=$(echo $((current_chapter_number+1)) | awk '{printf "%02d", $1}')
	header="[[${current_book_name_full}]] | [[$current_book_name_short-$next_chapter_number_padded|$current_book_name_full - Chapter $next_chapter_number ]]"
	footer=$header
	echo $header >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md
}

function print_heading_middle_chapter () {
	next_chapter_number_padded=$(echo $((current_chapter_number+1)) | awk '{printf "%02d", $1}')
	next_chapter_number=$(echo $((current_chapter_number+1)) | awk '{print $1}')
	last_chapter_number_padded=$(echo $((current_chapter_number-1)) | awk '{printf "%02d", $1}')
	last_chapter_number=$(echo $((current_chapter_number-1)) | awk '{print $1}')
	header="[[$current_book_name_short-$last_chapter_number_padded|$current_book_name_full - Chapter $last_chapter_number ]]  | [[$current_book_name_full]] |  [[$current_book_name_short-$next_chapter_number_padded|$current_book_name_full - Chapter $next_chapter_number ]]"
	footer=$header
	echo $header >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md
}

function print_heading_last_chapter () {
	last_chapter_number_padded=$(echo $((current_chapter_number-1)) | awk '{printf "%02d", $1}')
	last_chapter_number=$(echo $((current_chapter_number-1)) | awk '{print $1}')
	header="[[$current_book_name_short-$last_chapter_number_padded|$current_book_name_full - Chapter $last_chapter_number]]  | [[$current_book_name_full]]"
	footer=$header
	echo $header >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md
}

function print_heading_first_and_last_chapter () {
	header="[[$current_book_name_full]]"
	footer=$header
	echo $header >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md
}

function print_current_footer () {

	# print a blank line; then a horizontal rule; than another blank line
	echo "" >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md
	echo "***" >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md
	echo "" >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md

	# print the footer for the current chapter
	echo $footer >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md
}

function print_current_verse () {
	current_verse_number=$(echo $one_line | awk -F'"' '{print $2}')
	current_text=$(echo $one_line | sed 's/.*>\(.*\)<\/VERS>.*$/\1/' | sed 's/^ //' | sed 's/`/'\''/g')

  echo "###### v$current_verse_number" >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md
	echo $current_text >> ./"${current_book_number_padded} - ${current_book_name_full}"/"${current_book_name_short}-$current_chapter_number_padded".md

}


# let's read the biblical text in one line at a time and process it
while read one_line
do
	if [[ $one_line =~ "<BIBLEBOOK" ]]; then

		start_a_new_book

	elif [[ $one_line =~ "<CHAPTER" ]]; then

		start_a_new_chapter

	elif [[ $one_line =~ "<VERS" ]]; then

		print_current_verse

	elif [[ $one_line =~ "</CHAPTER" ]]; then

		print_current_footer

	else
		echo ""
	fi

done < "$bible_version".xml

