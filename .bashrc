if [ -r $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

source_if_readable() {
    local source_file="${1}"
    if [ -r "${source_file}" ]; then
        source "${source_file}"
    fi
}

source_if_readable ~/.nix-profile/etc/profile.d/bash_completion.sh
source_if_readable ~/.nix-profile/share/fzf/completion.bash
source_if_readable ~/.nix-profile/share/fzf/key-bindings.bash

if [ -d ~/.nix-profile/etc/bash_completion.d/ ]; then
    cd ~/.nix-profile/etc/bash_completion.d
    while read line; do
	source ./"$line";
    done < <(ls)
    cd $OLDPWD
fi

export PS1='\n\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\n\$\[\033[00m\] '

export EDITOR='emacsclient -c -a "" '

shellHook() {
    runHook preShellHook
    export PS1='\n\[\033[01;32m\]\u@\h [$IN_NIX_SHELL] \w\n\$\[\033[00m\] '
    runHook postShellHook
}
