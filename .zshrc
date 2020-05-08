# Add git info for the prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

# PROMPT
setopt PROMPT_SUBST
NEWLINE=$'\n'
PROMPT='%F{029}%~%f %F{088}{${vcs_info_msg_0_}}${NEWLINE}%f%F{059}->%f '

setopt NO_CASE_GLOB
setopt CORRECT  #enables auto correct
setopt CORRECT_ALL

autoload -Uz compinit && compinit

#aliases
alias ll='ls -al'
