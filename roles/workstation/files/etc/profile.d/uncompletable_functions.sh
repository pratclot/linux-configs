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
