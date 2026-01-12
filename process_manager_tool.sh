#! /bin/bash

#-------------------------------------------lsiting all processes-------------------------------------------------
#listing all the process with PID, USER, CPU and memory usage and the command
echo "listing all the processes" 
ps aux

#--------------------------------------------creating logfile --------------------------------------------------------
LOGFILE="process_manager.log"
#created file if not created
touch process_manager.log

#-------------------------------------------option 1-------------------------------------------------
#option 1 function for killing a process 
kill_a_process() {
	echo
	read -p "Enter the PID of process you would like the terminate: " pid #getting the PID form user
	
	#Check if the process exists
    	if ! ps -p "$pid" > /dev/null; then
        	echo "Error: Process $pid does not exist."
        	return 1
    	fi
    	
	#use user input to kill the process using kill command
	kill $pid
	
	#display to temrinal
	echo "Process $pid has been terminated!"
	
	#write to log file
	timestamp=$(date +"%Y-%m-%d %H:%M:%S")
	echo "$timestamp -- Process $pid has been terminated!" >> "$LOGFILE"
}

#-------------------------------------------option 2-------------------------------------------------
#option 2 function for displaying running processes for user
display_by_user() {
	echo
	read -p "Enter username: " usern
	#sorts the list of processes and shows the processes ran by the user recieved in user input. 
	ps -u "$usern" -o pid,user,%cpu,%mem,command 2>/dev/null
	
	#if no processes for user display message
	if [[ $? -ne 0 ]]; then
        	echo "Could not find processes for $usern. Make sure username is correct."
        	#write to logfile 
        	timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        	echo "$timestamp -- Could not find processes for $usern." >>"$LOGFILE"
 
    	fi
	
}

#-------------------------------------------option 3-------------------------------------------------
#option 3 fucntion to show top processes cunsuming most cpu and memory 
top_cpu_mem(){
	echo
	echo "Top 5 CPU-consuming processes: "
    	top -b -n 1 | sed -n '8,12p' #top sorts by cpu usage by default 
    	echo
    	echo "Top 5 Memory-consuming processes: "
    	top -b -n 1 -o %MEM | sed -n '8,12p' #filter to show top 5 memory usgae
 }	
 
 #-------------------------------------------option 4-------------------------------------------------
 #option 4 to allow the sceduling of process status check every minute and save to log. 

 process_status_check(){
	echo
	echo "Logs will be saved to $LOGFILE, Type q to exit back to main menu after waiting for last interval."
   	echo "(Process monitoring started. Logging every 60 seconds)"
    	
    	echo
	while true; do 
    		timestamp=$(date +"%Y-%m-%d %H:%M:%S") 
     
    		#get the processes status and logging to file
    		echo "-------------------------$timestamp------------------------" >> "$LOGFILE"
    		echo "$(ps aux --sort=-%cpu | head -n 5)" >> "$LOGFILE" 
 		
    		# show in terminal each time info is logged to file
    		echo "$timestamp -- Process info has been loged" 
 
    		#wait for 60 seconds, but allow user to exit by typing 'q' 
    		read -t 1 key 
    		if [[ "$key" == "q" ]]; then 
        		echo "Logging stopped." 
        		break 
    		fi 
 
    		sleep 60
	done 

 }

#-------------------------------------------main menu-------------------------------------------------
#while loop with if else satement so user can choose which action to do. 
#this is the main menu
while true; do 
	echo
	echo "--------------------------Process Manager Tool---------------------------"
	echo "Select an option:"
	echo "0) List all processes again"
	echo "1) Kill a process with PID"
	echo "2) Display process ran by specific user"
	echo "3) Show top 5 processes using most CPU and Memory"
	echo "4) Allow scheduling of process status checks every minute and save the logs to a
file"
	echo "5) Exit program"
	read -p " Enter option: " option #getting option from user
	
	if [ $option -eq 0 ]; then 
		ps aux
	elif [ $option -eq 1 ]; then
		kill_a_process #calling the fucntion

	elif [ $option -eq 2 ]; then
		display_by_user #calling the function
		
	elif [ "$option" -eq 3 ]; then
		top_cpu_mem #calling the fucntion
		
	elif [ $option -eq 4 ]; then
		process_status_check
		
	elif [ $option -eq 5 ]; then
		echo "Exiting program"
		exit	#exiting the program
	else
		#if one of the options is not enter error message will show
		echo "Option choosen is invalid. Try again!"
		echo
	fi
	
done 
