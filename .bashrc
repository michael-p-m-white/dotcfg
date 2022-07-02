if [ -r $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

if [ -r ~/.nix-profile/etc/profile.d/bash_completion.sh ]; then
    source  ~/.nix-profile/etc/profile.d/bash_completion.sh
fi

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
