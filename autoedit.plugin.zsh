# --- configuration ---
(( ! ${+ZSH_AUTOEDIT_CREATE_FILE} )) &&
    typeset -g ZSH_AUTOEDIT_CREATE_FILE=true

# file 
edit_ext=(
    js 
    jsx 
    py 
    zsh

    txt
    org 
    md 
    yml 
    yaml
    toml 
    json
)

# files to support
edit_files=(
    Dockerfile 
    # .gitignore TODO allow for editing dotfiles
    # .zshrc
)

# VIM PLUGIN - auto edit file
_autoedit() {
    cmdstr=${BUFFER//[$'\t\r\n']}
    extension="${cmdstr##*.}" 
     
    if [[ ! $cmdstr =~ ( |\') ]]; then
        if [ -z ${cmdstr##*.*} ]; then
            if [[ ! "$(($edit_ext[(Ie)$extension]))" == 0 ]];  then # if the file name has a text editing extension, use the default editor to edit the file
                BUFFER="$EDITOR $cmdstr"
            elif [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
                # if the file type isn't supported and GUI is available,
                # touch it and open it with X
                BUFFER="touch $cmdstr && xdg-open $cmdstr"
            fi
        elif [[ ! "$(($edit_files[(Ie)$cmdstr]))" == 0 ]]; then
            # if the full name of the file matches, edit it
            # TODO match only the last . or / (support full paths)
            BUFFER="$EDITOR $cmdstr"
        fi
    fi

    zle .accept-line
}

zle -N accept-line _autoedit
