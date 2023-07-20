# iptables-personal-blacklists

I have two types or resources for IPtables blacklists within HestiaCP.

#### 1. Local blacklists based on a .sh script. The files are hosted locally on the server.

    root@host: cd /usr/local/hestia/data/firewall/ipset/
  
- asn-personal-blacklist.sh
  
#### 2. Remote blacklists based on a .txt file. These files are hosted on f.e. Github.

    https://raw.githubusercontent.com/chriscapisce/iptables-personal-blacklists/main/single-ips-personal-blacklist.txt


#### 3. Read how to configure them: 

    https://github.com/chriscapisce/iptables-personal-blacklists/blob/main/Configure-Local-Blacklists.md
    
    

