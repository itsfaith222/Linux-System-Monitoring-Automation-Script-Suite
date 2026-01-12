#!/bin/bash

#----------------------------------Log file variable/creation------------------------------------------

#this is the creation of the log file
touch cpu_manager.log
LOGFILE="cpu_manager.log"

#-------------------------------------------option 1 --------------------------------------------
#function #1 to display the current CPU usage. 
current_CPU_Usage() {
	#get the time to display so user knows the time the cpu was got at
	timestamp=$(date)
    	usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')
    	echo 
    	#printing the cpu usage in % to the screen. 
    	echo "Current CPU Usage ($timestamp): $usage"
    	
}

#-------------------------------------------option 2-------------------------------------------------

#function 2 that tracks cpu usage over specific period and logs the data
track_cpu_over_period() {
	# this is going to collect the cpu usage every 5 seconds during the duration the user enters
	interval=5
	echo
	#ask user to inpu how long they want to track cpu for
	read -p "How long do you want to track the CPU usage? Enter in seconds: " duration
	echo "(Tracking the cpu usage for $duration seconds, in intervals of 5 seconds) Enter q to stop "
	
	#setting the start and end time to help time how long we track the cpu usage
	start_time=$(date +%s)
	end_time=$((start_time + duration)) 	#end the clock after duration
	
	#Begin tracking for the duration 
	while [ "$(date +%s)" -lt "$end_time" ]; do
    		timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    		#get cpu usage
    		cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')

    		#logging the data
    		echo "$timestamp -- CPU usage: $cpu_usage" >> "$LOGFILE"
    
    		sleep "$interval"
    		
    		#let user exit with the letter q 
    		read -t 1 key
    		if [[ "$key" == "q" ]]; then 
    			echo "stopping CPU usgae alert monitoring."
    			break
    		fi
	done
	
	#last 3 lines of the log file
	echo
	echo "    Last 3 lines of $LOGFILE"
	tail -n 3 "$LOGFILE" | while read line; do
    		echo "    $line" 
    	done
	
	echo
	#print out the data has been logged to cpu_manager.log file
	echo "CPU tracking complete. Data has been loged to $LOGFILE"
}

#------------------------------------------option 3------------------------------------------------

#function 3 letting users set affinity for specific process
assign_affinity_for_process() {
	echo 
	#get pid from user
	read -p "Enter the process id: " pid #gets the pid for process 
	
	#Check if the process exists
    	if ! ps -p "$pid" > /dev/null; then
        	echo "Error: Process $pid does not exist."
        	return 1
    	fi
    	
    	#display current affinity for process 
    	echo
    	echo "Current CPU Affinity for PID $pid:"
    	sudo cat /proc/$pid/status | grep Cpus_allowed_list
    	
    	#get the cores from user
    	echo
	read -p "Enter CPU cores (e.g., 0, 1 or 0,1): " cores #get the cores to assign process to
	echo
	
	#set the affinity
	timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    	echo "$timestamp -- $(taskset -cp "$cores" "$pid")" >> "$LOGFILE" 
	
	#display new affinity for process 
    	echo "New CPU Affinity for PID $pid:"
    	sudo cat /proc/$pid/status | grep Cpus_allowed_list
    	echo "data has been loged to $LOGFILE"
    	
}

#-------------------------------------------option 4-------------------------------------------------

#function 4 to begin generating alerts if cpu exceeds certain threshold.
cpu_alert_generator() {
	echo
	#get threshold from user
	read -p "Enter alert CPU usage threshold (In percentage e.g., 90 for 90%): " threshold
	
	#start monitoring and alert when exceeds. alerts are also logged to file 
	echo "Monitoring CPU usage... Alert when it exceeds $threshold%."
    	echo "Enter 'q' to stop the monitoring."
    	
    	#monitoring loop
    	while true; do 
    		#get timestamp and current cpu usage
    		cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    		
    		#check for the cpu is high and create alert if is
    		if (( $(echo "$cpu_usage > $threshold" | bc -l) )); then
    			timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    			
    			#write alert to temrinal
    			echo "  $timestamp -- ALERT: CPU usage is HIGH at $cpu_usage%!"
    			
    			#write allert to terminal 
    			echo "$timestamp -- ALERT: CPU usage is HIGH at $cpu_usage%!" >> "$LOGFILE"
    		fi
    		
    		#sleep to run loop every second. 
    		sleep 1
    		
    		#let user exit with the letter q 
    		read -t 1 key
    		if [[ "$key" == "q" ]]; then 
    			echo "stopping CPU usgae alert monitoring and logging all data to $LOGFILE"
    			break
    		fi
    	done
}

#--------------------------------------------main menu------------------------------------------

#while loop with if else satement so user can choose which action to do. 
#this is the main menu
while true; do 
	echo
	echo "--------------------------CPU Manager Tool---------------------------"
	echo "Select an option:"
	echo "1) Display the current CPU usage percentage."
	echo "2) Track CPU usage over a specific period and log the data"
	echo "3) Allow users to set CPU affinity for a specific process (assign it to specific CPUs)"
	echo "4) Generate an alert if CPU usage exceeds a certain threshold (e.g., 90%)."
	echo "5) Exit program"
	read -p "Enter option: " option #getting option from user
	
	if [ $option -eq 1 ]; then
		 current_CPU_Usage #calling the fucntion
		 
	elif [ $option -eq 2 ]; then
		track_cpu_over_period #calling the function
		
	elif [ "$option" -eq 3 ]; then
		assign_affinity_for_process #calling the fucntion
		
	elif [ $option -eq 4 ]; then
		cpu_alert_generator #calling the function 
		
	elif [ $option -eq 5 ]; then
		echo "Exiting program"
		exit	#exit the program
	else
		#if non of the set options is enter error message will show
		echo "Option choosen is invalid. Try again!"
		echo
	fi
	
done 
