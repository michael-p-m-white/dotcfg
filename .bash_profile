[ -f "$HOME"/.bashrc ] && source "$HOME"/.bashrc

[ -z "$__ETC_BASHRC_SOURCED" -a -f /etc/bashrc ] && source /etc/bashrc
