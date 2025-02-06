
# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
export PATH=$PATH:$HOME/.rustup
export PATH=$PATH:$HOME/.cargo
export PATH=$PATH:$HOME/.cargo/bin
export PATH="/opt/homebrew/opt/go@1.21/bin:$PATH"
export DYLD_FALLBACK_LIBRARY_PATH="$(xcode-select --print-path)/Toolchains/XcodeDefault.xctoolchain/usr/lib/"
export LDFLAGS=-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
#export PATH=$(go env GOPATH)/bin:$PATH


export PATH=$PATH:$HOME/Tools
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PICO_SDK_PATH="$HOME/Private/Development/embedded/pico-sdk"
export CGO_ENABLED=1
#export GOPATH="$HOME/code/go/"
export GODEBUG='netdns=cgo'
export GOPRIVATE="dev.azure.com"

. "/Users/bjornurban/.deno/env"
