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
  (
    head -1
    grep $@
  )
}
htail() {
  (
    head -1
    tail $@
  )
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
  nmap 1>/dev/null 2>/dev/null -sP $net -oG - --host-timeout 1 &
  neighbours=$(ip -4 n show dev $iface | cut -d" " -f1 | tr "\n" " ")
  nmap -PN -p $port $neighbours --open -oG - 2>/dev/null | awk -v pattern="$port/open" '$0 ~ pattern {print $2}'
}
pwss() {
  if [ $# -gt 0 ]; then
    SERVE_PATH=$1
  else
    SERVE_PATH=./
  fi
  ARGS=(
    -m http.server 80
    --directory $SERVE_PATH
  )
  python3 "${ARGS[@]}"
}
aqr() {
  if [ $# -gt 0 ]; then
    APK_NAME=$(basename $1)
    export APK_URL="http://$(myip)/$APK_NAME"
    echo $APK_URL
    qrencode -t ANSIUTF8 -o- $APK_URL
    export -f pwss
    pwss $(dirname $1)
  else
    echo "Please, supply apk's filename, maybe by pressing Tab..."
  fi
}
aiwf() {
  aqr $1 &
  adb shell am start -a android.intent.action.VIEW -d $APK_URL
}
cfmt() {
  if [ $# -gt 0 ]; then
    sed -i'' -e '1 s/^/#!\/bin\/bash\n\n/' $1
    sed -i'' -e "s/\(.\)' /\1'\\n/g" $1
    sed -i'' -e '/^$/! s/$/ \\/g' $1
    sed -i'' -e '1 s/ \\$//' $1
    chmod +x $1
  else
    echo "Please, supply the filename"
  fi
}
astart() {
  if [ $# -gt 0 ]; then
    adb shell monkey -p $1 1
  else
    echo "Please, supply the package name"
  fi
}
adateset() {
  if [ $# -gt 0 ]; then
    echo "Treating input as date in %m%e%H%M format: 04081759 == April 08 17:59"
    adb shell toybox date -D%m%e%H%M $1
  else
    echo "'adb root' maybe needed if you get 'Operation not permitted' error"
    adb shell toybox date -D%m%e%H%M $(adatelocal)
  fi
}
arestart() {
  if [ $# -gt 0 ]; then
    astop $1 && astart $1
  else
    echo "Please, supply the package name"
  fi
}
ainstall() {
  if [ $# -gt 0 ]; then
    echo "Installing $1"
    adb install $1
  else
    echo "Please, supply the apk path"
  fi
}
afind() {
  if [ $# -gt 1 ]; then
    FLAVOUR=$1
    BUILD_TYPE=$2
    APK_DIR=${3:-apks}
    find ./ -path "*${APK_DIR}/*${FLAVOUR}*${BUILD_TYPE}*apk"
  else
    echo "I take three args only: FLAVOUR, BUILD_TYPE and APK_DIR!"
  fi
}
aipr() {
  ainstall $(afind prod release)
}
aisr() {
  ainstall $(afind staging release)
}
aipro() {
  ainstall $(afind prod release apks_old)
}
aisro() {
  ainstall $(afind staging release apks_old)
}
aipd() {
  ainstall $(afind prod debug)
}
aisd() {
  ainstall $(afind staging debug)
}
aipdo() {
  ainstall $(afind prod debug apks_old)
}
aisdo() {
  ainstall $(afind staging debug apks_old)
}
aclick() { (
  set -e
  acoords "$@"
  set -x
  adb shell input tap $COORDS
  set +x
); }
acoords() {
  if [ $# -gt 0 ]; then
    OPTIND=1
    while getopts a: opt; do
      case $opt in
      a)
        ADDITIONAL_TEXT=$OPTARG
        ;;
      *) ;;

      esac
    done

    shift $(($OPTIND - 1))
    echo "Will use text match: $*"
    echo "Will use additional text match: $ADDITIONAL_TEXT"
    adb shell uiautomator dump
    adb pull {/sdcard,/tmp}/window_dump.xml
    set -x
    export COORDS=$(python3 ~/scripts/android_get_view_center.py -d /tmp/window_dump.xml "$*" -a "$ADDITIONAL_TEXT")
    set +x
  else
    echo "Please, tell me what text to click"
  fi
}
example() {
  OPTIND=1
  aflag=
  bflag=
  while getopts ab: name; do
    case $name in
    a) aflag=1 ;;
    b)
      bflag=1
      bval="$OPTARG"
      ;;
    ?)
      printf "Usage: %s: [-a] [-b value] args\n" $0
      exit 2
      ;;
    esac
  done
  if [ ! -z "$aflag" ]; then
    printf "Option -a specified\n"
  fi
  if [ ! -z "$bflag" ]; then
    printf 'Option -b "%s" specified\n' "$bval"
  fi
  shift $(($OPTIND - 1))
  printf "Remaining arguments are: %s\n$*"
}
setup_godroid() {
  aclick CONFIRM
  aclick -a "goDroid - Mock" Not allowed
  aclick Allow access to manage all files
  aback
  aback
  sleep 5
  aclick COUNTRY
}
setup_godroid_25() {
  aclick ALLOW
  aclick ALLOW
  aclick COUNTRY
}
