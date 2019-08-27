#!/bin/bash
dff() {
       if [ $# -gt 0 ]; then
           df $@ | grep -v "/var/lib/docker/"
       else
           df -h | grep -v "/var/lib/docker/"
       fi
}
mkcd() {
       mkdir -p -- "$1" &&
       cd -P -- "$1"
}
dctop() {
       docker-compose top $@
}
dclogs() {
       docker-compose logs $@
}
dcrst() {
       docker-compose restart
}
hgrep() {
       (head -1; grep $@)
}
htail() {
       (head -1; tail $@)
}
