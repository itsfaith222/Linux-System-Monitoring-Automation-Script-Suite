#function to display options
options() {
	echo "This is the memory manager tool!"
	echo "Type 1 to see the current memory usage"
	echo "Type 2 to list the processes consuming over 200 mb"
	echo "Type 3 to clear the cache and buffer (Warning: This command will use root privileges)"
	echo "Type 4 or h to see options again"
	echo "Type q to quit"
}

#function to view current memory statistics
view_memory() {
	free -m
}

#function to view processes consuming over 200MB of memory
view_processes_over_200() {
	#To determine if a process is using over 200 mb of memory, we needed to do some arithmetic to convert that into a percentage 
	total_mem=$(free -m | awk '/^Mem:/{print $2}')
	thres=`echo "scale=4; (200 / $total_mem) *100" | bc -l`
	#we use that value to provide a condition for awk
	ps aux --sort=-%mem | awk -v threshold=$thres '{ if ($4 > threshold) {print} }'
}

#function to clear buffer and cache
clear_cache_and_buffer() {
	sync
	#"echo 3 > /proc/sys/vm/drop_caches" must be run with root privileges so we added "sudo sh -c"
	sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
}

#function to check if there is under 500 MB of memory available
check_low_memory() {
	#this function checks if there is less than 500 mb of memory free and reports it to the user
	available=$(free -m | awk '/^Mem:/{print $4}')
	if [[ $available -lt 500 ]]
	then
		echo "There is less than 500 MB of memory available for the system!"
	fi
}

#variable to keep track of user choice
x=4

#to run until told to quit
while true
do
	#cases represent the options that could be selected
	case "$x" in
		4 | h) #the introduction list of options
			options
			;;
		1) #viewing current memory usage
			echo "Viewing current memory usage"
			view_memory
			;;
		2) #Listing process concuming over 200 mb of memory
			echo "Listing processes consuming over 200 mb of memory"
			view_processes_over_200
			;;
		3) #clearing cache and buffer
			echo "Attempting to clear cache and buffer"
			clear_cache_and_buffer
			;;
		q) #exiting the program
			echo "Exiting Tool"
			break
			;;
		*) #any other option is invalid and will ask you to try again
			echo "That was invalid, please try again. To view all options type 4 or h."
			;;
	esac #end of case statement
	check_low_memory #checking for low memory everytime there is an input
	read -p "Enter 1-4 or q to exit: " x
done
