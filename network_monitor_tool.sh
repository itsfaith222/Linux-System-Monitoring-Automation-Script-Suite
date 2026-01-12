#program to manage and monitor network activity

#function to display options
options() {
	echo "This is the Network Monitor Tool!"
	echo "Type 1 to show network configuration."
	echo "Type 2 to show bandwidth usage. This command requires root privileges."
	echo "Type 3 to check and show connections from a certain ip."
	echo "Type 4 to monitor network usage over 40 seconds and output it to the network_log.txt file. This command requires root priveleges."
	echo "Type 5 or h to show the options."
	echo "Type q to exit the tool."
	echo "============================================"
}

#function to display IP addresses and status of interfaces
network_config() {
	ip a
	echo "============================================"
}

#function to show bandwidth usage for each interface
bandwidth_usage() {
	#to get the bandwidth of each active interface we will get each interface, and then filter out loopback, and run iftop on the remaining interfaces
	#to get all interfaces on the computer
	interfaces=$(ifconfig -a | grep flags | awk '{print $1}')
	#for each interface
	for inter in $interfaces
	do
		#remove the colon (:) after the interface name
		name=$(echo "${inter::-1}")
		#skip if the name is "lo" (loopback)
		if [ $name == "lo" ]
		then
			continue
		else #otherwise run iftop on the interface
			sudo iftop -i $name
		fi
	done
	echo "============================================"
}

#function to monitor network conections and alert if specific ip connects
check_if_ip_connects() {
	#read user input for ip to search for
	read -p "Enter the IP you'd like to search for: " ip
	#command that checks all ongoing connections at the time of running and checks if the ip has any connections
	ss -n src "$ip"
	echo "============================================"
}

#function to track network traffic over 40s and output it to log
monitor_network() {
	#get all interfaces on the computer
	interfaces=$(ifconfig -a | grep flags | awk '{print $1}')
	#for each interface
	for inter in $interfaces
	do
		#remove the colon (:) after the interface name
		name=$(echo "${inter::-1}")
		#skip if the name is "lo" (loopback)
		if [ $name == "lo" ]
		then
			continue
		else #otherwise run iftop on the interface
			#command to monitor network usage and append it to a file named "network_log.txt"
			sudo iftop -i $name -t -s 40 >> network_log.txt
			#get the current date and time
			current_time=$(date +"%d-%m-%Y %T")
			#add line to report for clarity and seperation of each instance of the log being generated
			echo "Generated network traffic report for interface $name at $current_time" >> network_log.txt
		fi
	done
	#write to console the report finished generating
	echo "The report was generated and recorded in the log file."
	echo "============================================"
}

#variable to keep track of user choice
x=5

#while loop to run until user quits
while true
do
	#switch for user selection
	case "$x" in
		1) #view network configuration
			network_config
			;;
		2) #view bandwidth usage on all active interfaces except loopback
			bandwidth_usage
			;;
		3) #view if a certain ip connects to computer
			check_if_ip_connects
			;;
		4) #monitor network usage of active interfaces and record it to log file
			monitor_network
			;;
		5 | h) #display options
			options
			;;
		q) #exit tool
			exit
			;;
		*) #Invalid option
			echo "That was an invalid option. Type 1 - 4, 5 or h for options, or q to quit."
			;;
	esac #end of switch
	#read user input for next option
	read -p "Enter 1-5 or q to exit: " x
done #end of while loop
