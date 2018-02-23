if [ -f $HOME/.bash_aliases ]; then
   source $HOME/.bash_aliases
fi

# This is probably not the right way to do this
if [ -d ~/.nix-profile/etc/bash_completion.d/ ]; then
    cd ~/.nix-profile/etc/bash_completion.d
    while read line; do
	source "$line";
    done < <(ls)
    cd $OLDPWD
fi

export PS1='\n\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\n\$\[\033[00m\] '
