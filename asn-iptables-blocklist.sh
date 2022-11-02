#!/bin/bash

# Script and blacklist urls are being collected at:
# https://github.com/chriscapisce/iptables-personal-blocklist
#

BLACKLISTS=(
  "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/202425/ipv4-aggregated.txt"
  "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/267784/ipv4-aggregated.txt"
  "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/48721/ipv4-aggregated.txt"
  "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/209588/ipv4-aggregated.txt"
  "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/213010/ipv4-aggregated.txt"
  "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/399471/ipv4-aggregated.txt"
  "https://raw.githubusercontent.com/ipverse/asn-ip/master/as/51447/ipv4-aggregated.txt"
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
