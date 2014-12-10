#!/bin/bash
#This script will focus on letting a user go through a menu while using a loop and functions.

current_users=$(who -aH | less)    # This is showing who is logged in with option of showing headings for columns
current_directory=$(pwd)
current_time=$(date +"%r %Z")	# This will show the current time with timezone
current_date=$(date +"%A %B %d, %Y")	# This will show the date as full weekday name, full month name, day of month, and year in 4 digit format.
current_month=$(cal -1)	    # This will show one month


function press_enter
{
	echo ""
	echo "Press RETURN for menu"
	read -s -n 1 key  # -s: do not echo input character. -n 1: read only 1 character (separate with space)
# double brackets to test, single equals sign, empty string for just 'enter' in this case...
# if [[ ... ]] is followed by semicolon and 'then' keyword
	if [[ $key = "" ]]; 
then 
	clear
else
	echo ""
    	echo "You pressed '$key', we said press RETURN"
	echo ""
	press_enter     # This will run the open_enter function again
fi

}


function option_1
{
	clear
	echo "The following will show users currently logged in."
	echo
	echo "$current_users"
	echo
}

function option_2
{

	echo -n "Select whay year you wish to see: (1800 - 2100): "
	read Y1
	if [ $Y1 -gt 1799 -a $Y1 -lt 2101 ];   # This will check the input against a range.  -gt is greater than and -lt is less than.
then
	echo "Great year!"    # I would love to expand this to show a custom message for certain years.
else
	echo "Year is out of range we asked for.  Please try again. "
	option_2
fi

	clear
	echo "Good year."
	echo "Select what month you wish to see: (1-12) "
	echo -n "EXAMPLE: 12 for Dec or 3 for Mar:   "
	read M1

	if [ $M1 -gt 0 -a $M1 -lt 13 ];   # This will check the input against a range.  -gt is greater than and -lt is less than.
then
	echo "Great month!"
else
	echo "Month is out of the range.  Please try again."
	option_2
fi
	clear
	echo "Selected month and year: "
	echo ""
	cal $M1 $Y1
}

function option_3
{
	clear
	echo "The following will show the current directory path."
	echo
	echo "$current_directory"
	echo
}

function option_4  # This is the function I had trouble with.  Too many issues.
{
	clear
	echo "YOUR CURRENT DIRECTORY:"
	echo
	echo "$current_directory"
	echo ""
	echo "What directory would you like to go to?"
	read LINK_OR_DIR
	echo  ""

if [ -d "$LINK_OR_DIR" ]; then 
  if [ -L "$LINK_OR_DIR" ]; then
    # It is a symlink!
    # Symbolic link specific commands go here.
    rm "$LINK_OR_DIR"
  else
    # It's a directory!
    # Directory command goes here.
    rmdir "$LINK_OR_DIR"
  fi
fi

}

function option_5
{
	clear
#	echo "This should be displaying the files in the current director."
# 	echo "spacebar or pagedown - to scroll down one screen"
#	echo "pageup - to scroll up one screen"
#	echo "arrow keys - to move up and down the screen"
	ls -C | less

}


function option_6
{
	clear
	echo "The following will show the the current time, date, and calendar."
	echo 
	echo "Current time: $current_time  Current date: $current_date "
	echo
	echo "$current_month"
	echo
}


function option_7
{
	clear
	echo "Here are some .txt files in your current directory."
	echo ""
	ls *.txt | head -5   #  This will show the first 5 files in the current directory with a .txt extension.
	echo ""
	echo ""
	echo -n "Which file would you like to edit?   "
	read get_file
	echo ""

if  [[ -f $get_file ]];  # The checks if the file exists.

then
	echo "$get_file is a file!"
	find -name $get_file -exec  vi {} \;  #  If the file is there, then the file is opened in VI.
else
	echo "$get_file is not a file, but we can create it!"
	touch $get_file	
	find -name $get_file -exec vi {} \;  # If the file does not exists, then the file is created and then opened in VI.  Could just open in VI and avoid creating the file.
fi




}


function option_8
{
	clear
	echo "EMAIL A FILE TO A USER"
	echo -n "Who would you like to send the email to? "
	read email_address
	grep $email_address /etc/passwd 2>&1 >/dev/null  # This is checking to see is the requested user is placed in the passed file
	if [ $? -eq 0 ];
	then
	echo "$email_address available on this system"
	else
	echo “That user is not available.  Please try again.”
	echo “”
	option_8
	fi

	clear
	echo "Good.  Now with the user set, what file would you like to send? "
	echo "A couple of file from your directory:"
	ls *.txt | head -10   #  This will show the first 10 files in the current directory with a .txt format.
	echo ""
	echo -n "Only text files will be attached.  If you try to attach anything else this will reset. "
	read email_attachment
	if [[ -f $email_attachment ]];
	then
	echo "Great!"
	else
	option_8
	fi

	clear
	echo -n "What would you like the subject to be? "
	read email_subject

	clear
	echo "I would really contact the user or use Gmail. Good luck!"
	echo "Here is what is being sent:"
	echo "To: $email_address"
	echo "Subject: $email_subject"	
	echo "Attachment: $email_attachment"
	mail -s $email_subject $email_address < $email_attachment
}

function option_9
{
	clear
	echo "Thank you for trying my Menu Program."
	echo "Here is a little something just for you."
	echo
	fortune   # When the user exits, a fortune is called
	echo
	echo
	break
}


clear
selection=
until [ "$selection" = "0" ]; do
	echo "Welcome to David's Main Menu"
	echo ""
	echo "1 -- Display users currently logged in"
	echo "2 -- Display a calendar for a specific month and year"
	echo "3 -- Display the current directory path"
	echo "4 -- Change directory"
	echo "5 -- Long listing of visible files in the current directory"
	echo "6 -- Display current time and date and calendar"
	echo "7 -- Start the vi editor"
	echo "8 -- Email a file to a user"
	echo "9 -- Quit"
	echo ""
	echo -n "Enter selection: "
	read selection
	echo ""
	case $selection in

# All the following options will call for a function followed by the press_enter function

        1 ) option_1 ; press_enter ;;
        2 ) option_2 ; press_enter ;;
	3 ) option_3 ; press_enter ;;
	4 ) option_4 ; press_enter ;;
	5 ) option_5 ; press_enter ;;
	6 ) option_6 ; press_enter ;;
	7 ) option_7 ; press_enter ;;
	8 ) option_8 ; press_enter ;;
        9 ) option_9 ;;
        * ) echo "Please enter a number from 1-9"; press_enter
    esac
done
