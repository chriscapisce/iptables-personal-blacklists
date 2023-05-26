#!/bin/bash

# Script and blacklist urls are being collected at:
# Google Drive: Custom Exim4 & IPsets Blacklists
#

BLACKLISTS=(
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/bd/ipv4-aggregated.txt" # Bangladesh (BD)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/br/ipv4-aggregated.txt" # Brazil (BR)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/cn/ipv4-aggregated.txt" # China (CN)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/co/ipv4-aggregated.txt" # Colombia (CO)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/cz/ipv4-aggregated.txt" # Czechia (CZ)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/do/ipv4-aggregated.txt" # Dominican Republic (DO)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/in/ipv4-aggregated.txt" # India (IN)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/id/ipv4-aggregated.txt" # Indonesia (ID)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/ir/ipv4-aggregated.txt" # Iran (IR)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/la/ipv4-aggregated.txt" # Laos (LA)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/lt/ipv4-aggregated.txt" # Lithuania (LT)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/mx/ipv4-aggregated.txt" # Mexico (MX)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/pl/ipv4-aggregated.txt" # Poland (PL)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/ro/ipv4-aggregated.txt" # Romania (RO)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/ru/ipv4-aggregated.txt" # Russia (RU)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/sa/ipv4-aggregated.txt" # Saudi Arabia (SA)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/sc/ipv4-aggregated.txt" # Seychelles (SC)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/kr/ipv4-aggregated.txt" # South Korea (KR)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/tr/ipv4-aggregated.txt" # Turkey (TR)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/ua/ipv4-aggregated.txt" # Ukraine (UA)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/us/ipv4-aggregated.txt" # United States (US)
        "https://raw.githubusercontent.com/ipverse/rir-ip/master/country/vn/ipv4-aggregated.txt" # Vietnam (VN)
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
