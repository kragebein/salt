{%- for webhost in salt['pillar.get']('webhosts') %}
create_files_{{ webhost }}:
  file.managed:
    - name: /etc/nginx/sites-available/{{ webhost }}
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - show_changes: True
    - replace: false
    - contents: |
        server {
          # managed zone start
          # managed zone end
        }
    - unless: ls /etc/nginx/sites-available/{{ webhost }}
edit_contents_{{ webhost }}:
  file.blockreplace:
    - name: /etc/nginx/sites-available/{{ webhost }}
    - marker_start: "# managed zone start"
    - marker_end: "# managed zone end"
    - content: |
        server_name {{ webhost }};
        proxy_buffering off;
        access_log /var/log/nginx/{{ webhost }}_access.log;
        error_log /var/log/nginx/{{ webhost }}_error.log;
        location / {
        {%- if salt['pillar.get']('webhosts:' + webhost).access != "public" %}
            {%- for allowed_ip in salt['pillar.get']('allowed_ips_private') %}
            allow {{ allowed_ip }};
            {%- endfor %}
            deny all;
        {%- endif %}
            proxy_pass {{ salt['pillar.get']('webhosts:' + webhost).host }};
            {%- if salt['pillar.get']('webhosts:' + webhost).websocket %}
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
            {%- endif %}
            proxy_hide_header X-Powered-By; ## Hides nginx server version from bad guys.
            proxy_set_header Range $http_range; ## Allows specific chunks of a file to be requested.
            proxy_set_header If-Range $http_if_range; ## Allows specific chunks of a file to be requested.
            proxy_set_header X-Real-IP $remote_addr; ## Passes the real client IP upstream
            proxy_set_header Host $host; ## Passes the requested domain name upstream
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; ## Adds forwarded IP to the list of IPs that were forwarded upstream
        }
symlink_{{ webhost }}:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ webhost }}
    - target: /etc/nginx/sites-available/{{ webhost }}
    - force: True
{%- endfor %}

restart_nginx:
  cmd.run:
    - name: systemctl restart nginx
    - onlyif: nginx -t

{% for webhost in salt['pillar.get']('webhosts') %}
  {% if salt['pillar.get']('webhosts:' + webhost).ssl %}
install_new_cert_for_{{ webhost }}:
  cmd.run:
    - name: certbot run -n -m "stian.langvann@gmail.com" --agree-tos -d {{ webhost }} --nginx --cert-name {{ webhost }}
    - watch:
      - file: /etc/nginx/sites-available/{{ webhost }}
  {% endif %}
{% endfor %}

