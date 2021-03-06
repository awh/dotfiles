
# Shamelessly robbed from http://www.terminally-incoherent.com/blog/2013/01/14/whats-in-your-bash-prompt/

##-ANSI-COLOR-CODES-##
Color_Off=$(tput sgr0)
###-Regular-###
Red=$(tput setaf 1)
Green=$(tput setaf 2)
Purple=$(tput setaf 5)
####-Bold-####
BRed=$(tput bold; tput setaf 1)
BPurple=$(tput bold; tput setaf 5)

# set up command prompt
function __prompt_command()
{
    # capture the exit status of the last command
    EXIT="$?"
    PS1=""
 
    if [ $EXIT -eq 0 ]; then PS1+="\[$Green\][\!]\[$Color_Off\] "; else PS1+="\[$Red\][\!]\[$Color_Off\] "; fi
 
    # if logged in via ssh shows the ip of the client
    #if [ -n "$SSH_CLIENT" ]; then PS1+="\[$Yellow\]("${$SSH_CLIENT%% *}")\[$Color_Off\]"; fi
 
    # basic information (user@host:path)
    PS1+="\[$BRed\]\u\[$Color_Off\]@\[$BRed\]\h\[$Color_Off\]:\[$BPurple\]\w\[$Color_Off\] "
 
    # check if inside git repo
    local git_status="`git status -unormal 2>&1`"    
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        # parse the porcelain output of git status
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local Color_On=$Green
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local Color_On=$Purple
        else
            local Color_On=$Red
        fi
 
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
        else
            # Detached HEAD. (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
        fi
 
        # add the result to prompt
        PS1+="\[$Color_On\][$branch]\[$Color_Off\] "
    fi
 
    # prompt $ or # for root
    PS1+="\$ "
}
PROMPT_COMMAND=__prompt_command

