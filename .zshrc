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

# returns the passed in param, OR the current path if the param is '.'
function getPathParam() {
	local param=$1
	if [ "$param" = "." ]; then
		param=${PWD##*/}
	fi

	echo "$param"
}

# This only handles encoding forward slashes.  It could be expanded later if needed.
function urlencode() {
	echo "$1" | sed 's/\//%252F/g'
}

# if no param then go to devbuild
# if param is '.' then go to the project in the current directory
# if param then go to that project
function devbuild() {
	if [ -z "$1" ]; then
		open https://devbuild.arbfund.com/
	elif [ "$1" = "." ]; then
		local project=${PWD##*/}
		local branch=$(urlencode $(git branch --show-current))
		open https://devbuild.arbfund.com/job/$project/job/$branch
	else
		open https://devbuild.arbfund.com/job/$1/
	fi
}

function grok() {
	open https://opengrok.arbfund.com/source/search\?q=$1
}

# Open Jira with the passed in case number
# If no parameter is passed in, try to pull the case number off the current git branch
# If no case is found, then just open the Jira dashboard
function jira() {
  if (( $1 )); then
      open https://jira.arbfund.com/browse/$1
  else
    local CASE_NUM=$(git branch --show-current | egrep -o '\w*-\d+')
	if (( $CASE_NUM )); then
	    open https://jira.arbfund.com/browse/$CASE_NUM
	else
		open https://jira.arbfund.com/secure/Dashboard.jspa
	fi
  fi
}

function sonar() {
	if [ -z "$1" ]; then
		open https://sonarqube.cwantools.io
	else
		local val=$(getPathParam "$@")
		open https://sonarqube.cwantools.io/dashboard\?id=com.clearwateranalytics:$val
	fi
}

function stash() {
	if [ -z "$1" ]; then
		open https://stash.arbfund.com
	else
		local val=$(getPathParam "$@")
		open https://stash.arbfund.com/projects/UI/repos/$val/browse
	fi
}

function versionmanager() {
	if [ -z "$1" ]; then
		open https://versionmanager.arbfund.com
	else
		local val=$(getPathParam "$@")
		open https://versionmanager.arbfund.com/#/projects/$val\?ac=settings
	fi
}

# aliases
# Do not put aliases to applications in here.  Use ln -s to make a link instead
# ln -s <source> /usr/local/bin/<target>
# ln -s "/Applications/NetBeans/Apache NetBeans 12.1.app/Contents/Resources/NetBeans/netbeans/bin/netbeans" /usr/local/bin/netbeans
alias cypress='./node_modules/cypress/bin/cypress open &'
alias ll='ls -lhG'
alias lla='ls -alhG'
alias ls='ls -G'
alias mvnfix='mvn com.clearwateranalytics:dependency:resolve-transitives'
alias mvnquick='mvn clean install -DskipDependencyCheck=true -DskipTests=true'
alias mvnupdate='mvn com.clearwateranalytics:ca-versions-maven-plugin:update-properties com.clearwateranalytics:ca-versions-maven-plugin:use-latest-releases -DallowMajorUpdates=true -Dmaven.version.rules=https://versionmanager.arbfund.com/app/rules/version-rules.xml -DgenerateBackupPoms=false'
alias ql='qlmanage -p "$@" > /dev/null'

