# Umbrel Nginx Conflict with local niginx 
If already running Nginx on the server, there will likely be a conflict on port 80. 

Umbrel has an option to select the port nginx runs on. 

Umbrel setup scripts automatically sets up an systemd server; so this has to be updated.

Add the line 
```
Environment="NGINX_PORT=12345"
``` 

to the umbrel systemd unit file at /etc/systemd/system/umbrel-startup.service

