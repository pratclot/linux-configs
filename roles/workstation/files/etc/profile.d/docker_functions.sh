#!/bin/bash
da() {
   docker attach \
   -e TERM=xterm \
   -e LINES=$(tput lines) \
   -e COLUMNS=$(tput cols) $@
}
de() {
   docker exec -itu0 \
   -e TERM=xterm \
   -e LINES=$(tput lines) \
   -e COLUMNS=$(tput cols) \
    $1 /bin/bash
}
des() {
   docker exec -itu0 \
   -e TERM=xterm \
   -e LINES=$(tput lines) \
   -e COLUMNS=$(tput cols) \
   $1 /bin/sh
}
dex() {
   docker exec -itu0 $@
}
dr() {
   docker run -itu0 $1 $2
}
dps() {
   docker ps $@
}
dpsa() {
   docker ps -a $@
}
dim() {
   docker images $@
}
ds() {
   docker start $1
}
drm() {
   docker rm $1
}
dsrm() {
   docker stop $1 && docker rm $1
}
dcp() {
   docker copy $1:$2 .
}
dtop() {
   docker top $1
}
dis() {
   docker inspect $1 | jq '.'
}
diss() {
   docker inspect $1 --format "{{range .Config.Env}}{{println .}}{{end}}" | sort
}
dtail() {
   docker logs --tail 10 -f $@
}
dlogs() {
   docker logs $@ | less -rS
}
ddif() {
   diff -W $(tput cols) -y <(diss $1) <(diss $2)
}
