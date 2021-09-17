#!/bin/bash
alias ttop='top -cHi -d1'
alias vi='vim'
alias awk-sum='awk '\''{sum+=$NF} END {print sum}'\'''
alias gip='ip a | grep '\''inet '\'''
alias mip='ip r g 1 | awk '\''/via/ {print $(NF-2)}'\'''
alias pws='python3 -m http.server 80'
alias tstrace='strace -s255 -ttfFp'
alias gitlog='git log --branches --remotes --tags --graph --oneline --decorate'
alias yi='yum install -y'
alias yw='yum whatprovides'
alias rss='ps -F k-rss'
alias rssu='ps -F k-rss -u'
alias cmds='zcat -f /var/log/commands.log* | sort -m | LC_ALL=C sort -k 1M | less'
alias mtailf='multitail --follow-all'
alias fl='firewall-cmd --list-ports'
alias fr='firewall-cmd --reload'
alias fa='firewall-cmd --permanent --add-port'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias unicnt='sort | uniq -c | sort -n'
alias dcdu='docker-compose down && docker-compose up -d'
alias dcps='docker-compose ps'
alias dvars='docker ps -q | xargs -L1 -IA docker inspect A --format "{{range .Config.Env}}{{$.Name}} {{println .}}{{end}}"'
alias dwatch='watch -n1 '\''docker ps -a | grep "second\|minute"'\'''
alias oops='ansible : -i /usr/local/pb_ansible/hosts.py --vault-password-file ~/dev-password -m shell -a'
alias gp='cd $ANSIBLE_HOME && git pull'
alias watch='watch '
alias sudo='sudo '
alias tailf='tail -f '
alias ll='ls -la --group-directories-first --color'
alias lltr='ll -tr'
alias bc="BC_ENV_ARGS=<(echo "scale=2") \bc"
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'
alias gradlektsconverter=$(readlink -f `which gradlekotlinconverter`)
alias gloww='while true; do clear; glow README.md; sleep 2; done'
alias als='alsp 5555'

# kubectl
alias kev='kubectl get events --sort-by="{.lastTimestamp}"'
alias kgco='kubectl get pods -o go-template --template="{{range .items}}{{.metadata.name}}{{printf \"\n\"}}{{range .spec.containers}}  {{.name}}{{printf \"\n\"}}{{end}}{{printf \"---------\n\"}}{{end}}"'
alias h2='helm2 --tiller-namespace $(kubens -c)'
alias h2st='for i in $(h2 ls -q); do h2 status $i; done'
alias h2link='h2st | awk '\''/.k8s.walmart.net/ {print $1}'\'''

# arch
alias pms='sudo pacman -S --noconfirm'
alias pmf='pacman -Ss'
alias pmr='sudo pacman -R --noconfirm'
alias pmff='sudo pacman -F'
alias pmu='sudo pacman -Syu --noconfirm'
alias pml='sudo pacman -Ql'

# copyq
alias cpf='copyq copy - <'
alias cpc='cat <<< $(copyq clipboard)'

# msi
alias temps="sudo isw -r 16S3EMS1"

