#!/bin/bash
dff() {
       if [ $# -gt 0 ]; then
           df $@ | grep -v "/var/lib/docker/\|/snap/"
       else
           df -h | grep -v "/var/lib/docker/\|/snap"
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
aur() {
  export AUR_PREV_PATH=$(pwd) &&
  cd ~/gits &&
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
  fi
  cd "$1" &&
  makepkg -si &&
  cd "${AUR_PREV_PATH}"
}
aum() {
	cd "$1" &&
	makepkg -si
	cd ..
}
getp() {
  op get item $1 | jq -r '.details.fields[] | select(.designation=="password") | .value'
}
getu() {
  op get item $1 | jq -r '.details.fields[] | select(.designation=="username") | .value'
}
gav() {
  ansible localhost -m setup | sed 's#.*SUCCESS =>##' | jq .ansible_facts."$1"
}
aliasi() {
  cd ~/linux-configs/
  ansible-playbook site.yml -t bash
  cd -
}
rss-sum() {
  ps -F k-rss | awk '{sum+=$6} END {print sum}'
}
rssu-sum() {
  ps -F k-rss -u "$1" | awk '{sum+=$6} END {print sum}'
}
alsp() {
  port=$1
  iface=$(ip r | awk '/default/ {print $NF}')
  net=$(ip a show $iface | awk '/inet / {print $2}')
  1>/dev/null 2>/dev/null nmap -sP $net -oG - --host-timeout 1 &
  neighbours=$(ip -4 n show dev $iface | cut -d" " -f1 | tr "\n" " ")
  nmap -PN -p $port $neighbours --open -oG - 2>/dev/null | awk -v pattern="$port/open" '$0 ~ pattern {print $2}'
}
