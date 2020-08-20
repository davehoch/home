
# Add git info for the prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

# good promp chars
# ⛄️
# ⮕
# 👉

# PROMPT
setopt PROMPT_SUBST
NEWLINE=$'\n'
PROMPT='%F{059}$USER@%m%f %F{029}%~%f %F{088}(${vcs_info_msg_0_})${NEWLINE}%f%F{059}⚡%f'

setopt NO_CASE_GLOB
setopt CORRECT  #enables auto correct
setopt CORRECT_ALL

# Kubernetes
source <(kubectl completion zsh)
export KUBECONFIG=$HOME/.kube/config
for filename in $HOME/.kube/config.d/*; do
   export KUBECONFIG=$KUBECONFIG:$filename
done

# ZSH_DISABLE_COMPFIX="true"  #This doesn't seem to work
# commenting this out for now because this is annoying: Ignore insecure directories and continue [y] or abort compinit [n]?
autoload -Uz compinit && compinit

# aliases
# Do not put aliases to applications in here.  Use ln -s to make a link instead
# ln -s <source> /usr/local/bin/<target>
alias ll='ls -alh'
alias ql='qlmanage -p "$@" > /dev/null'
alias mvnupdate='mvn com.clearwateranalytics:ca-versions-maven-plugin:update-properties com.clearwateranalytics:ca-versions-maven-plugin:use-latest-releases -DallowMajorUpdates=true -Dmaven.version.rules=https://versionmanager.arbfund.com/app/rules/version-rules.xml -DgenerateBackupPoms=false'
alias mvnfix='mvn com.clearwateranalytics:dependency:resolve-transitives'