# good prompt chars
# ⛄️
# ⮕
# 👉

# Add git info for the prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

# PROMPT
setopt PROMPT_SUBST
NEWLINE=$'\n'
PROMPT='%F{059}$USER@%m%f %F{029}%~%f %F{088}(${vcs_info_msg_0_})${NEWLINE}%f%F{059}⚡%f'

setopt NO_CASE_GLOB # case insensitive globbing.  i.e D* will match d*
# setopt CORRECT  # enables auto correct.  It turns out that I don't like the autocorrect
# setopt CORRECT_ALL

# History file ~/.zsh_history
setopt HIST_IGNORE_DUPS  # do not store duplications
setopt HIST_REDUCE_BLANKS  # removes blank lines from history

# Kubernetes
source <(kubectl completion zsh)
export KUBECONFIG=$HOME/.kube/config
for filename in $HOME/.kube/config.d/*; do
   export KUBECONFIG=$KUBECONFIG:$filename
done

#fix for Docker problem:  https://github.com/docker/for-mac/issues/770
export DOCKER_HOST=tcp://localhost:1234

# ZSH_DISABLE_COMPFIX="true"  #This doesn't seem to work
# commenting this out for now because this is annoying: Ignore insecure directories and continue [y] or abort compinit [n]?
autoload -Uz compinit && compinit

# returns the passed in param, OR the current path if the param is blank or '.'
function getPathParam() {
	local param=$1
	if [ -z "$param" ] || [ "$param" = "." ]
	then
		param=${PWD##*/}
	fi

	echo "$param"
}

function jira() {
	open https://jira.arbfund.com/browse/$1
}

function grok() {
	open https://opengrok.arbfund.com/source/search\?q=$1
}

function devbuild() {
	local val=$(getPathParam "$@")
	open https://devbuild.arbfund.com/job/$val/
}

function versionmanager() {
	local val=$(getPathParam "$@")
	open https://versionmanager.arbfund.com/#/projects/$val\?ac=settings
}

# aliases
# Do not put aliases to applications in here.  Use ln -s to make a link instead
# ln -s <source> /usr/local/bin/<target>
# ln -s "/Applications/NetBeans/Apache NetBeans 12.1.app/Contents/Resources/NetBeans/netbeans/bin/netbeans" /usr/local/bin/netbeans
alias ll='ls -alhG'
alias ls='ls -G'
alias ql='qlmanage -p "$@" > /dev/null'
alias mvnskip='mvn clean install -DskipDependencyCheck=true'
alias mvnupdate='mvn com.clearwateranalytics:ca-versions-maven-plugin:update-properties com.clearwateranalytics:ca-versions-maven-plugin:use-latest-releases -DallowMajorUpdates=true -Dmaven.version.rules=https://versionmanager.arbfund.com/app/rules/version-rules.xml -DgenerateBackupPoms=false'
alias mvnfix='mvn com.clearwateranalytics:dependency:resolve-transitives'
