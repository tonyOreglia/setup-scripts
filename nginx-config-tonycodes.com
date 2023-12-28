server {
  listen [::]:443 ssl;
  listen 443 ssl;

  server_name tonycodes.com;
  root /var/www/html/tonycodes.com;
  index index.html;
    ssl_certificate /etc/letsencrypt/live/www.tonycodes.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.tonycodes.com/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

  access_log /var/log/nginx/tonycodes.com.access.log;
  error_log /var/log/nginx/tonycodes.com.error.log;

   location / {
     try_files $uri $uri/ =404;
   }

  location /tw/ {
    proxy_pass http://127.0.0.1:1444/;
    proxy_set_header        Host             $host;
    proxy_set_header        X-Real-IP        $remote_addr;
    proxy_set_header        X-Forwarded-For  $proxy_add_x_forwarded_for;
  }

  location /wiki {
    proxy_pass http://127.0.0.1:1445/;
  }

  location /emma/ {
    proxy_pass http://127.0.0.1:1446/;
    proxy_set_header        Host             $host;
    proxy_set_header        X-Real-IP        $remote_addr;
    proxy_set_header        X-Forwarded-For  $proxy_add_x_forwarded_for;
  }

  location /note {
    proxy_pass http://127.0.0.1:8081/note;
  }

  location /allNotes {
    proxy_pass http://127.0.0.1:8081/allNotes;
  }

  location /babelroulette/ {
    proxy_pass http://127.0.0.1:8084/;
    proxy_redirect ~/(.*)$ /babelroulette/$1;
  }

  location /calibre {
    proxy_bind 	$server_addr;
    proxy_pass	http://127.0.0.1:8083;
    proxy_set_header        Host            $http_host;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Scheme        $scheme;
    proxy_set_header        X-Script-Name   /calibre; 
  } 

  # Requests for socket.io are passed on to Node on port 8084
  location ~* \.io {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_set_header X-NginX-Proxy false;

      proxy_pass http://localhost:8084;
      proxy_redirect off;

      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
    }

}

server {
  listen 80 default_server;
  server_name _;
  return 301 https://$host$request_uri;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  ''	close;
}

server {
  listen 8443 ssl;
  ssl_certificate /etc/letsencrypt/live/www.tonycodes.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/www.tonycodes.com/privkey.pem;

  location /uci {
    proxy_pass http://127.0.0.1:8090;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_read_timeout 86400;
  }
}
