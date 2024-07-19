allowed_ips_private:
  - 10.0.0.0/24
  - 178.16.70.105/32

webhosts:
  vm.lazywack.no:
     host: https://10.0.0.80:8006
     access: private
     ssl: true
     websocket: true
  plex.lazywack.no:
     host: http://10.0.0.7:32400
     access: public
     ssl: true
     websocket: true
  docker.lazywack.no:
     host: https://10.0.0.3:9443
     access: private
     ssl: true
     websocket: false
  ipa.lazywack.no:
     host: https://10.0.0.150:443
     access: private
     ssl: true
     websocket: false
  kibana.lazywack.no:
     host: https://10.0.0.130:5601
     access: private
     ssl: true
     websocket: false
  backup.lazywack.no:
     host: https://10.0.0.193:8007
     access: public
     ssl: true
     websocket: false
  unifi.lazywack.no:
     host: https://10.0.0.1:443
     access: private
     ssl: true
     websocket: true
  torrent.lazywack.no:
     host: http://10.0.0.172:8080
     access: private
     ssl: true
     websocket: false
  rr.lazywack.no:
     host: http://10.0.0.188:7878
     access: private
     ssl: true
     websocket: false
  sr.lazywack.no:
     host: http://10.0.0.169:8989
     access: private
     ssl: true
     websocket: false
  portal.lazywack.no:
     host: http://10.0.0.3:7575
     access: private
     ssl: true
     websocket: false
