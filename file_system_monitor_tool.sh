#program to display disk usage and manage files

#function to display all options available
options() {
	echo "This is the file system monitor tool!"
	echo "Type 1 or h to view the options."
	echo "Type 2 to view current disk usage."
	echo "Type 3 to list the top 15 largest files in specified directory."
	echo "Type 4 to show files modified within the last 24 hours in specified directory."
	echo "Type 5 to clean temporary files if they exceed 1 MB."
	echo "Type q to exit"
	echo "========================================================"
}

#function to view the current disk usage
view_disk() {
	df -h
	echo "========================================================"
}

#function to view the 15 largest files in user's Desktop
view_big_files_in_directory() {
	#read the literal directory from the user
	read -p "Directory literal path (/home/{User}/Desktop not ~/Desktop): " path
	#if the path doesn't exist report it back to the user
	if [ ! -d "$path" ]
	then
		echo "Directory does not exist!"
	else #otherwise get the files in the path, sort by size, and output the top 15
		du -h $path | sort -hr | head -15
	fi
	echo "========================================================"
}

#function to view files within Desktop that have been modified within the last 24 hours
view_modified_in_directory() {
	#read the literal path of the directory from the user
	read -p "Directory literal path (/home/{User}/Desktop not ~/Desktop): " path
	#if the path doesn't exist report it back to the user
	if [ ! -d "$path" ]
	then
		echo "Directory does not exist!"
	else #otherwise find all files in the path that's been moddified within the last 24 hours
		find $path -mtime -1 -printf '%a\t%p\n'
	fi
	echo "========================================================"
}

#function to clean temporary files above 1 MB
clean_files() {
	sudo find /tmp -size +1M -delete
	echo "========================================================"
}

#user choice variable
x=1

#while loop to continuously run program
while true
do
	#switch for user selection
	case "$x" in
		1 | h) #view option selection
			options
			;;
		q) #quit the program
			echo "Exiting Tool"
			exit
			;;
		2) #viewing disk usage
			echo "Viewing current disk usage"
			view_disk
			;;
		3) #viewing largest files
			echo "Viewing the 15 largest files in specified directory."
			view_big_files_in_directory
			;;
		4) #viewing files that have been modified
			echo "Viewing Files within specified directory that have been modified within the last 24 hours."
			view_modified_in_directory
			;;
		5) #cleaning temporary files
			echo "Cleaning Temporary Files over 1MB"
			clean_files
			;;
		*) #all other invalid options
			echo "That was invalid, please try again. To view all options type 1 or h."
			;;
	esac #end of case
	read -p "Enter 1-4 or q to exit: " x #reading using input
done #end of loop
