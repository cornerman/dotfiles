# colorize manpages
export LESS_TERMCAP_mb=$(printf "\33[01;34m")   # begin blinking
export LESS_TERMCAP_md=$(printf "\33[01;34m")   # begin bold
export LESS_TERMCAP_me=$(printf "\33[0m")       # end mode
export LESS_TERMCAP_se=$(printf "\33[0m")       # end standout-mode
export LESS_TERMCAP_so=$(printf "\33[44;1;37m") # begin standout-mode - info box
export LESS_TERMCAP_ue=$(printf "\33[0m")       # end underline
export LESS_TERMCAP_us=$(printf "\33[01;35m")   # begin underline

[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"

# export SBT_OPTS="-Xmx3000M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Duser.timezone=GMT -Xss16M"
export SBT_OPTS="-Xmx4G -Xss16M"
export JAVA_OPTS="-Xmx512M -Xss16M"
# export SBT_NATIVE_CLIENT="true"
