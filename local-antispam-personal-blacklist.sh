#!/bin/bash

# Script and blacklist urls are being collected at:
# Google Drive: Custom Exim4 & IPsets Blacklists
#
# I removed this because I added it through DNS at /etc/exim4/dnsbl.conf
# https://www.nixspam.net/download/nixspam-ip.dump.gz # NixSpam - IP Dump
#

BLACKLISTS=(
      "https://lists.blocklist.de/lists/courierimap.txt" # Blocklist.de - Courier Imap
      "https://lists.blocklist.de/lists/courierpop3.txt" # Blocklist.de - Courier Pop3
      "https://lists.blocklist.de/lists/email.txt" # Blocklist.de - E-mail
      "https://lists.blocklist.de/lists/imap.txt" # Blocklist.de - Imap
      "https://lists.blocklist.de/lists/mail.txt" # Blocklist.de - Mail
      "https://lists.blocklist.de/lists/pop3.txt" # Blocklist.de - Pop3
      "https://lists.blocklist.de/lists/postfix.txt" # Blocklist.de - Postfix
      "https://sigs.interserver.net/iprbl.txt" # InterShield - Full
      "https://www.spamhaus.org/drop/drop.txt" # SpamHaus - Droplist
      "https://www.spamhaus.org/drop/edrop.txt" # SpamHaus - Extended Droplist
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
