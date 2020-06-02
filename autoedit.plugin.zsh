# --- configuration ---
# default to not creating a file
(( ! ${+ZSH_AUTOEDIT_CREATE_FILE} )) &&
    typeset -g ZSH_AUTOEDIT_CREATE_FILE=false

# default to using $EDITOR
ZSH_AUTOEDIT_EDITOR=${EDITOR}
(( ! ${+EDITOR} )) &&
    typeset -g ZSH_AUTOEDIT_EDITOR="xdg-open"

# given the current buffer,
# if provided a valid file path, 
# edit the file at that path.
_autoedit() {
    cmdstr=${BUFFER//[$'\t\r\n']} # remove newline
    extension="${cmdstr##*.}"     # get file extension
    # ensure cmd is only one line 
    if [[ ! $cmdstr =~ ( |\') ]]; then
        # if the file exists:
        if [ -w $cmdstr ]; then
            # get mime type of file  
            mime=$(file --mime-type ${cmdstr})
            mime2=${mime%%/*}
            bigmime=${mime2##* }
            smlmime=${mime##*/}
            if [[ $bigmime == "text" ]]; then
                # open with text editor
                BUFFER="$ZSH_AUTOEDIT_EDITOR $cmdstr" 
            elif [[ $bigmime == "inode" ]]; then
                # echo "will not open folder; use autocd"
            elif [[ -z $DISPLAY ]]; then 
                # else if a gui is available:
                BUFFER="xdg-open $cmdstr"
            fi

        elif [[ $ZSH_AUTOEDIT_CREATE_FILE ]]; then
            # TODO perhaps create file
        fi
    fi

    zle .accept-line # feed the line back to zsh
}

zle -N accept-line _autoedit
