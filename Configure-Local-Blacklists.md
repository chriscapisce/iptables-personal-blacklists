I created custom IPtables lists like so:

#### 1. Create Local Blacklist File

Create a file in: root@host:/usr/local/hestia/data/firewall/ipset#

	nano asn-personal-blacklist.sh
    
#### 2. Set correct file permissions

###### 2a. CHMOD Local Blacklist script asn-personal-backlist.sh

Location: 'root@host:/usr/local/hestia/data/firewall/ipset#'
	
 	chmod 755 asn-personal-blacklist.sh

##### 2b. Check correct file permissions at 755 being -rwxr-xr-x: 
		
	root@host: ls -l

#### 3. Add IPset to Firewall through HestiaCP GUI.

Go to: https://host.yourdomain.com:2083/add/firewall/ipset/

##### 3a. IP List Name: 
	Local-ASN-IPs-List
##### 3b. Data Source (url, script or file): 

ASN:

	script:/usr/local/hestia/data/firewall/ipset/asn-personal-blacklist.sh

Countries:

	script:/usr/local/hestia/data/firewall/ipset/countries-personal-blacklist.sh

Combined:

	script:/usr/local/hestia/data/firewall/ipset/combined-personal-blacklist.sh
	
##### 3c. IP Version:
	ip v4 
##### 3d. Auto Update:
	Yes

#### 4. Update Firewall within HestiaCP through terminal.

	v-update-firewall
