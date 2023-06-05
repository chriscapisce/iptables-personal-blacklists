#!/bin/bash

# Script and blacklist urls are being collected at:
# https://github.com/chriscapisce/iptables-personal-blocklist
#

BLACKLISTS=(
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/202425/ipv4-aggregated.txt" # AS202425 (INT-NETWORK) IP Volume inc
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/267784/ipv4-aggregated.txt" # AS267784 (FLYSERVERS-SA) Flyservers S.A.
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/48721/ipv4-aggregated.txt"  # AS48721 (FLYSERVERS-ENDCLIENTS) Flyservers S.A.
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/209588/ipv4-aggregated.txt" # AS209588 (FLYSERVERS) Flyservers S.A.
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/213010/ipv4-aggregated.txt" # AS213010 (GIGAHOSTINGSERVICES) GigaHostingServices OU
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/399471/ipv4-aggregated.txt" # AS399471 (SERVERION) Serverion LLC
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/51447/ipv4-aggregated.txt"  # AS51447 (ROOTLAYERNET) RootLayer Web Services Ltd.
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/211252/ipv4-aggregated.txt" # AS211252 (DELIS) Delis LLC
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/36352/ipv4-aggregated.txt"  # AS36352 (COLOCROSSING) ColoCrossing
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/4766/ipv4-aggregated.txt"   # AS4766 (KIXS) Korea Telecom
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/262197/ipv4-aggregated.txt" # AS262197 (MILLICOM-CABLE-COSTA-RICA) MILLICOM CABLE COSTA RICA S.A. 
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/263333/ipv4-aggregated.txt" # AS263333 (VIPTURBO-COMRCIO-SERVIOS) VIPTURBO COMRCIO & SERVIOS DE INFORMTICA LTDA
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/31235/ipv4-aggregated.txt"  # AS31235 (SKIWEBCENTER) SKIWEBCENTER SARL
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/12400/ipv4-aggregated.txt"  # AS12400 (PARTNER) Partner Communications Ltd.
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/16116/ipv4-aggregated.txt"  # AS16116 (PELEPHONE-COMMUNICATIONS-LTD) Pelephone Communications Ltd.
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/28146/ipv4-aggregated.txt"  # AS28146 (MHNET-TELECOM) MHNET TELECOM
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/20001/ipv4-aggregated.txt"  # AS20001 (TWC-PACWEST) Charter Communications Inc
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/20115/ipv4-aggregated.txt"  # AS20115 (CHARTER) Charter Communications
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/12271/ipv4-aggregated.txt"  # AS12271 (TWC-NYC) Charter Communications Inc
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/33667/ipv4-aggregated.txt"  # AS33667 (CMCS) Comcast Cable Communications, LLC
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/33668/ipv4-aggregated.txt"  # AS33668 (CMCS) Comcast Cable Communications, LLC
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/20214/ipv4-aggregated.txt" # AS20214 (COMCAST) Comcast Cable Communications, LLC
        "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/198896/ipv4-aggregated.txt" # AS198896 (CITYLAN) CITYLAN Sp. z o.o.
)

IP_BLACKLIST_TMP=$(mktemp)
for i in "${BLACKLISTS[@]}"; do
    IP_TMP=$(mktemp)
    (( HTTP_RC=$(curl -L --connect-timeout 10 --max-time 10 -o "$IP_TMP" -s -w "%{http_code}" "$i") ))
    if (( HTTP_RC == 200 || HTTP_RC == 302 || HTTP_RC == 0 )); then # "0" because file:/// returns 000
        command grep -Po '^(?:\d{1,3}\.){3}\d{1,3}(?:/\d{1,2})?' "$IP_TMP" | sed -r 's/^0*([0-9]+)\.0*([0-9]+)\.0*([0-9]+)\.0*([0-9]+)$/\1.\2.\3.\4/' >> "$IP_BLACKLIST_TMP"
    elif (( HTTP_RC == 503 )); then
        echo >&2 -e "\\nUnavailable (${HTTP_RC}): $i"
    else
        echo >&2 -e "\\nWarning: curl returned HTTP response code $HTTP_RC for URL $i"
    fi
    rm -f "$IP_TMP"
done

sed -r -e '/^(0\.0\.0\.0|10\.|127\.|172\.1[6-9]\.|172\.2[0-9]\.|172\.3[0-1]\.|192\.168\.|22[4-9]\.|23[0-9]\.)/d' "$IP_BLACKLIST_TMP"|sort -n|sort -mu
rm -f "$IP_BLACKLIST_TMP"
