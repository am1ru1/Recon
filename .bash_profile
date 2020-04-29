# This is my bash_profile:
#----- AWS -------

s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1 
}

#---- Content discovery ----
thewadl(){ #this grabs endpoints from a application.wadl and puts them in yahooapi.txt
curl -s $1 | grep path | sed -n "s/.*resource path=\"\(.*\)\".*/\1/p" | tee -a ~/tools/dirsearch/db/yahooapi.txt
}

#----- recon -----
httprobe(){
/root/go/bin/httprobe

}




crtndstry(){
./tools/crtndstry/crtndstry $1
}

am(){ #runs amass passively and saves to json
amass enum --passive -d $1 -json $1.json
jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1-domains.txt
}

certprobe(){ #runs httprobe on all the hosts from certspotter
curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe | tee -a ./all.txt
}

mscan(){ #runs masscan
sudo masscan -p4443,2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,744$}
}

certspotter(){ 
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
} #h/t Michiel Prins

crtsh(){
curl -s https://crt.sh/?q\=%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
}

certnmap(){
curl https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1  | nmap -T5 -Pn -sS -i - -$
} #h/t Jobert Abma

ipinfo(){
curl http://ipinfo.io/$1
}


#------ Tools ------
dirsearch(){ runs dirsearch and takes host and extension as arguments
python3 ~/tools/dirsearch/dirsearch.py -u $1 -e $2 -t 50 -b 
}

sqlmap(){
python ~/tools/sqlmap*/sqlmap.py -u $1 
}

ncx(){
nc -l -n -vv -p $1 -k
}

crtshdirsearch(){ #gets all domains from crtsh, runs httprobe and then dir bruteforcers
curl -s https://crt.sh/?q\=%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe -c 50 | grep https | xargs -n1 -I{} python3 ~/tools/dirsearch/dirsearch.py -u {} -e $2 -t 50 -b 
}


#----------WPSCAN---------------

wpscan-token(){
wpscan --api-token wyVEf4ZEvVEYefMeD02v15aoNcay5CnW5zBvZdBUfoA --url $1
}


#---------SUBDOMAINFINDER-------


subdomainfinder(){

curl -X POST -d "CSRF105313754=subnet103082308&CSRF107418110=CSRF107174636&CSRF101740976=subnet110800449&CSRF105811285=drudge105855526&CSRF100087812=stalker110887387&CSRF101168481=ipv4101704393&CSRF103054950=mask104084992&CSRF107192433=thief101913694&CSRF110916072=phishing106195861&CSRF105785876=cyberwar107894402&CSRF106621990=car100487584&CSRF108546680=firewall100726446&CSRF105360087=bogey109504445&CSRF104076367=hack107838097&CSRF104524164=geek107517204&CSRF110184690=tenant105928859&CSRF109698049=identitytheft105416991&CSRF110054704=cyber103963264&CSRF101220730=Trojan100808831&CSRF109285041=network108275072&CSRF103486028=tech106550140&CSRF110053623=TrojanHorse102639450&CSRF100192998=computer103253042&CSRF104453316=addict102467936&CSRF105612626=CSRF108423419&CSRF109926907=scammer107627689&CSRF106863474=scammer107958460&CSRF103568405=cyberspace102791438&CSRF104203381=TrojanHorse100032409&CSRF102795078=cyber101449337&CSRF109224882=hacking101792002&CSRF109243366=cyberspace109265606&CSRF72129657=93311867&breach=39494889&53598421=CSRF58963662&CSRF109348578=intrusion108998403&CSRF108210345=ipv4106031211&domain="$1"&73122672=CSRF37093339&CSRF27767660=33036427&scanner=16750665&20405972=CSRF41630381&CSRF110569690=24706903&domain_8=car100959875&CSRF106254598=geek107636584&CSRF101938754=intruder109576813&CSRF33086252=49727305&CSRF=96498481&security=45562811&38035666=CSRF35572973&scan_subdomains=" "https://subdomainfinder.c99.nl/index.php" | grep -o '[A-Za-z0-9_\.-]*'$1 | sort -u

}


#----------GITHUB-SUBDOMAIN------------

github-sub(){

python3 /opt/github-subdomains.py -t ac6b18ebee9a00793a5167bc5c1678b7260dffd7 -d $1

}

#-----------FFUF----------------------
ffuf-beast(){

ffuf -fc 403 -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u $1"FUZZ" -w /home/h4ck3r/Desktop/raft-large-files.txt -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk
}

#----------ARCHIVE-------------------

archive(){

curl "http://web.archive.org/cdx/search/cdx?url=*."$1"/*&output=text&fl=original&collapse=urlkey"
}
