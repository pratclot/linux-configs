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
        SERVE_PATH="$1"
    else
        SERVE_PATH="./"
    fi

    python3 - "$SERVE_PATH" <<'PYEOF'
import os
import re
import sys
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

directory = sys.argv[1]
os.chdir(directory)

class RangeRequestHandler(SimpleHTTPRequestHandler):
    def send_head(self):
        path = self.translate_path(self.path)

        if os.path.isdir(path):
            return super().send_head()

        try:
            f = open(path, 'rb')
        except OSError:
            self.send_error(404, "File not found")
            return None

        size = os.fstat(f.fileno()).st_size
        ctype = self.guess_type(path)

        range_header = self.headers.get("Range")
        if range_header:
            m = re.match(r"bytes=(\d+)-(\d*)", range_header)
            if m:
                start = int(m.group(1))
                end = int(m.group(2)) if m.group(2) else size - 1

                if start >= size:
                    self.send_error(416, "Requested Range Not Satisfiable")
                    return None

                self.send_response(206)
                self.send_header("Content-Type", ctype)
                self.send_header("Content-Range", f"bytes {start}-{end}/{size}")
                self.send_header("Content-Length", str(end - start + 1))
                self.send_header("Accept-Ranges", "bytes")
                self.end_headers()

                f.seek(start)
                remaining = end - start + 1
                while remaining > 0:
                    chunk = f.read(min(64 * 1024, remaining))
                    if not chunk:
                        break
                    self.wfile.write(chunk)
                    remaining -= len(chunk)

                f.close()
                return None

        # Normal full response
        self.send_response(200)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(size))
        self.send_header("Accept-Ranges", "bytes")
        self.end_headers()
        return f


print(f"Serving {directory} with resume support on port 80")
ThreadingHTTPServer(("0.0.0.0", 80), RangeRequestHandler).serve_forever()
PYEOF
}
aqr() {
  if [ $# -gt 0 ]; then
    APK_NAME="$(basename -- "$1")"
    APK_NAME_ENC="$(printf '%s' "$APK_NAME" | jq -sRr @uri)"
    export APK_URL="http://$(myip)/$APK_NAME_ENC"
    echo $APK_URL
    qrencode -t ANSIUTF8 -o- $APK_URL
    export -f pwss
    pwss $(dirname $1)
  else
    echo "Please, supply apk's filename, maybe by pressing Tab..."
  fi
}
rqr ()
{
    SERVE_PATH=${1:-./};
    IP=$(hostname -I | awk '{print $1}');
    URL="http://$(myip):8000/";
    echo "Upload URL: $URL";
    qrencode -t ANSIUTF8 -o- "$URL";
    export PWRECV_DIR="$SERVE_PATH";
    pwrecv "$SERVE_PATH"
}

pwrecv() {
    DIR=${1:-./}

    cat << 'EOF' > /tmp/pwrecv_server.py
import http.server, cgi, os

UPLOAD_DIR = os.environ.get("PWRECV_DIR", ".")

PAGE_HTML = b"""
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Upload file to PC</title>
<style>
    body {
        font-family: sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background: #f0f0f0;
    }
    .container {
        background: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        text-align: center;
    }
    h2 {
        margin-bottom: 30px;
        color: #026;
    }
    input[type="file"] {
        display: block;
        margin: 0 auto 20px;
        font-size: 1.2em;
    }
    input[type="submit"] {
        background-color: #026;
        color: white;
        font-size: 1.3em;
        padding: 15px 40px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
    }
    input[type="submit"]:hover {
        background-color: #048;
    }
</style>
</head>
<body>
<div class="container">
<h2>Upload file to PC</h2>
<form enctype="multipart/form-data" method="post">
    <input name="file" type="file" required><br>
    <input type="submit" value="Upload">
</form>
</div>
</body>
</html>
"""

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(PAGE_HTML)

    def do_POST(self):
        ctype, _ = cgi.parse_header(self.headers.get('Content-type'))
        if ctype == 'multipart/form-data':
            fs = cgi.FieldStorage(fp=self.rfile,
                                  headers=self.headers,
                                  environ={'REQUEST_METHOD':'POST'})
        else:
            self.send_error(400, "Bad upload")
            return

        if "file" not in fs:
            self.send_error(400, "File missing")
            return

        fileitem = fs["file"]

        if not fileitem.filename:
            self.send_error(400, "No filename")
            return

        filename = os.path.basename(fileitem.filename)
        outpath = os.path.join(UPLOAD_DIR, filename)

        with open(outpath, "wb") as f:
            f.write(fileitem.file.read())

        self.send_response(200)
        self.end_headers()
        self.wfile.write(f"Uploaded to: {outpath}".encode())
        print(f"Uploaded: {outpath}")

http.server.HTTPServer(("", 8000), Handler).serve_forever()
EOF

    PWRECV_DIR="$DIR" python3 /tmp/pwrecv_server.py
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
