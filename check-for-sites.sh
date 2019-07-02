#!/usr/bin/env bash
# check-for-sites.sh - script that will check given sites config path against a given ip address
# usage - ./check-for-sites.sh -t -p
# 			-t HOST 	This will be the host that the script will check against.
#				-p PATH 	Path to check for site configuration files. 

show_help(){
	echo "check-for-sites.sh - script that will check given sites config path against a given ip address
	usage: ./check-for-sites.sh -tp
	-t HOST 	This will be the host that the script will check against.
	-p PATH 	Path to check for site configuration files."
}

check_for_sites(){
	for f in $path; do
		site=$(cat $f | grep server_name | cut -d " " -f2-)
		for site in ${site[@]};
		do
			echo `host ${site//;}` > /dev/null
			if [ $? -ne 0 ]; then
				continue
				echo "$site not resovling"
			else
				ip_addr=$(host ${site//;} | cut -d " " -f4)
				if [ "$ip_addr" = "$host" ]; then
					echo "`hostname`, ${site//;}, $ip_addr, yes" >> $file
				else
					echo "`hostname`, ${site//;}, $ip_addr, no" >> $file
				fi
			fi
		done
	done
}

while getopts "ht:p:" opt; do
	case $opt in 
		h)
			show_help
			exit 0
			;;
		t)
			host=$OPTARG 
			;;
		p) 
			path=$OPTARG 
			;;
	esac
done

file=sites.log				# output file
echo "Checking sites in $path against $host"
echo "Creating output file $file"
echo "hostname,site,ip,on server" > $file
check_for_sites
echo "done"
