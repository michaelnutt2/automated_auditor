set_prompt() {
    local red green yellow blue magenta cyan orange grey violet lgrey no_color
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
	blue=$(tput setaf 4)
	magenta=$(tput setaf 5)
	cyan=$(tput setaf 6)
	orange=$(tput setaf 9)
	grey=$(tput setaf 10)
	violet=$(tput setaf 13)
	lgrey=$(tput setaf 14)
	no_color=$(tput sgr0)

    PS1=

    # If $PWD starts with $HOME, replace the $HOME part with a tilde
	if [[ $PWD == "$HOME"* ]]; then
		__cwd="~${PWD:${#HOME}}"
	else
		__cwd=$PWD
	fi

    __un="[${USER}]"

    # If host name has multiple parts, shorten to 'a-b' or similar; else just use first letter
	__hn=${HOSTNAME:0:1}
	if [[ $HOSTNAME == *?[-._]?* ]]; then
		suff=${HOSTNAME#*[-._]}
		__hn+=${HOSTNAME:$((${#HOSTNAME} - ${#suff} - 1)):1}${suff:0:1}
	fi

	# Except for the basename, shorten all directories in $PWD to the first 3 letters
	# Use '/' as delimiter because it's the only character not allowed in filenames
    local cwd_arr
	IFS='/' read -ra cwd_arr <<< "${__cwd#/}"
	if ((${#cwd_arr[@]} > 1)); then
		printf -v __cwd '%.4s/' "${cwd_arr[@]:0:$((${#cwd_arr[@]} - 1))}"
		__cwd+=${cwd_arr[-1]%/}
	fi
	# Re-insert leading slash unless we use ~ or /
	if [[ $__cwd != [~/]* ]]; then
		__cwd=/$__cwd
	fi

	# Set rest of prompt
	# User and hostname
    PS1+="\\[$green\\]\$__un\\[$orange\\]@\\[$blue\\]\$__hn\\[$orange\\]:"

    # Working directory and coloured prompt
	PS1+="\\[$green\\]\$__cwd\\[$magenta\\]\\∴\\[$no_color\\] "
}
