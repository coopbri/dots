# Dotfiles live in two bare repos that share $HOME as the work tree:
#   cfg   ~/.dots          public   github.com/coopbri/dots
#   cfgp  ~/.dots-private  private  github.com/coopbri/dots-private
# Every file belongs to exactly one repo. `dots <git args>` runs in both
#
# New machine setup and how to move a file between repos: see ~/README.md

_dots_git() { /usr/bin/git -C "$HOME" --git-dir="$1" --work-tree="$HOME" "${@:2}"; }

# Refuse `add` of a path the other repo already tracks
_dots_guard() {
  local other=$1 p rel
  shift
  [[ $1 == add && -d $other ]] || return 0
  for p in "${@:2}"; do
    [[ $p == -* ]] && continue
    rel=${${p:A}#$HOME/}
    if [[ -n $(_dots_git "$other" ls-files -- "$rel" 2>/dev/null) ]]; then
      print -u2 "dots: $rel is tracked in ${other:t}, a file belongs to one repo only"
      return 1
    fi
  done
}

unalias cfg cfgp 2>/dev/null
cfg()  { _dots_guard "$HOME/.dots-private" "$@" && _dots_git "$HOME/.dots" "$@"; }
cfgp() { _dots_guard "$HOME/.dots" "$@" && _dots_git "$HOME/.dots-private" "$@"; }

# Run the same git command in both repos, e.g. `dots status`, `dots pull`, `dots push`
dots() {
  local r
  for r in "$HOME/.dots" "$HOME/.dots-private"; do
    [[ -d $r ]] || continue
    print -P "%B${r:t}%b"
    _dots_git "$r" "$@" || return
  done
}
