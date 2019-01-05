alias gpo='git push origin'
alias gcn='git config --global user.name'
alias gce='git config --global user.email'
alias grv='git remote -v'

# gg, ggs, ggp后面都可以加上-n, 比如ggs -2, 表示只显示前n个提交
# ggs在gg的基础上会展示每次提交具体变动的文件
alias ggs='gg --stat'
# ggp在gg的基础上会展示文件的具体改动
# ggp -G 关键词 ==> 查找所有提交内容中包含关键词的提交, -G后面支持正则
alias ggp='gg -p'


alias cpu='sysctl -n machdep.cpu.brand_string'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias ppjson='python $ZRF_ZSH_TOOLS/json_pretty.py'

alias pi='pod install'
alias pu='pod update'

alias vim='nvim'
alias vimf='vim $(fzf)'
alias ns='npm start'
alias nb='npm run build'
alias r='source ranger'
alias -g H='| head -n'
alias -g T='| tail -n'
alias -g L="| less"
alias -g R='| row'
alias -g C='| column'
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"