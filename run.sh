#!/bin/bash
#Coded-by Jimmi Simon
#version=V1.2

export PATH=$PATH:$(go env GOPATH)/bin

echo -e "\n▁ ▂ ▄ ▅ ▆ ▇ █   🎀 【﻿ 𝟶x𝟶ᴘ𝟷ɴ𝟹ʀ 】 🎀   █ ▇ ▆ ▅ ▄ ▂ ▁

			V1.2
	       Developed By : Jimmi Simon\n"

echo "Enter the Domain : "
domain=`python3 domain.py`
if [[ $domain == *http://* ]] || [[ $domain == *https://* ]];
then
	echo "Enter Domain without http/https "
	exit
else
	cp config.json tools/knock/knockpy/
	echo "Domain is $domain , Searching for Subdomains..."


	if [ -f temp.txt ]; then
   		rm temp.txt
   	fi
	if [ -f $domain ]; then
	   	rm $domain
	fi
	if [ -f $domain"new" ]; then
   		rm $domain"new"
   	fi

	sub1=`assetfinder --subs-only $domain | sort -u | tr " " "\n" > temp.txt`
	echo "10% Completed..."
	sub2=`gau -subs $domain | cut -d / -f 3 | cut -d ":" -f1 | tr " " "\n" | sort -u >> temp.txt`
	echo "15% Completed..."
	sub3=`python3 tools/knock/knockpy/knockpy.py $domain | cut -d "," -f1  | tr "]" " "| tr '"' " " | tr "[" " "  | cut -d " " -f6 >>temp.txt`
	echo "25% Completed..."
	sub4=`python3 tools/Sublist3r/sublist3r.py -d $domain -n >> temp.txt`
	echo "30% Completed..."
	sub5=`python3 tools/SUB-Z/Sub-Z.py -d $domain | cut -d "/" -f3 >> temp.txt`
	echo "40% Completed..."
	sub6=`python3 tools/V1D0m/v1d0m.py -d $domain >> temp.txt`
	echo "45% Completed..."


	sub7=`curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r .[].name_value | sed 's/\*\.//g' | httpx -title -silent | anew | cut -d " " -f1 | sort -u >> temp.txt`
	echo "50% completed..."

	sub8=`curl -s "https://dns.bufferover.run/dns?q=.$domain" | jq -r .FDNS_A[] |cut -d "," -f2|sort -u >> temp.txt`
	echo "55% completed..."
	sub9=`curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >>temp.txt`
	echo "60% completed..."
	sub10=`curl -s "http://web.archive.org/cdx/search/cdx?url=*.$domain/*&output=text&fl=original&collapse=urlkey" | sed -e 's_https*://__' -e "s/\/.*//" | cut -d ":" -f1 | sort -u >> temp.txt`
	echo "70% completed..."
	sub11=`curl -s 'https://securitytrails.com/list/apex_domain/$domain' | grep -Po '((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+' | grep '.$domain' | sort -u >> temp.txt`
	echo "80% completed..."

	cat temp.txt | sort -u > $domain
	rm temp.txt


	echo "85% completed..."
	findomain -t $domain | httprobe >> $domain"new" 
	echo "90% completed..."
	echo "completing in a while..."
	fin=`cat $domain | httprobe  >> $domain"new"`

	echo "sorting..."
	final=`cat $domain"new" | sort -u > $domain`
	echo "100% completed"
	echo "Result Saved in $domain"
	rm $domain"new";



fi
