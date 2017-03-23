nginx:
  ng:
    vhosts:
      managed:
        vagrant.conf:
          enabled: True
          config:
            - server:
              - server_name: localhost
              - listen:
                - 8080
                - default_server
              - listen:
                - 443 ssl default_server
              - ssl_certificate: ssl/vagrant.crt
              - ssl_certificate_key: ssl/vagrant.key
              - root: /vagrant/public
              - index index.php 
              - access_log: /var/log/nginx/vagrant.log
              - location /:
                - try_files:
                  - $uri
                  - $uri/
                  - '@rewrite'
              - location @rewrite:
                - rewrite:
                  - ^/(.*)$
                  - /index.php?q=$1
              - location ~ ^/sites/.*/files/(css|js|styles)/:
                - expires: max
                - try_files: $uri @rewrite
              - location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff)$:
                - expires: 1h
              - location ~ \.php$:
                - fastcgi_split_path_info: ^(.+\.php)(/.+)$
                - include: fastcgi_params
                - fastcgi_param: SCRIPT_FILENAME $document_root$fastcgi_script_name
                - fastcgi_intercept_errors: 'on'
                - fastcgi_pass: unix:/var/run/php-fpm/vagrant.sock
