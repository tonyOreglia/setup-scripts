this saved me after a whole day of trying to get dam server to work again headless :shrug: 
https://ubuntuforums.org/archive/index.php/t-2331323.html

## Digital Ocean 
There is a script that dynamically updates the digital ocean IP address of the server. This updates the dig ocean A record so that if the server IP address changes, dig ocean still forwards traffic to the correct place. 

It relies on a .env for secrets. See https://tony-oreglia.medium.com/implementing-a-dynamic-ip-with-domain-hosted-on-digitalocean-510bf0f344a3 regarding creation of secrets.
