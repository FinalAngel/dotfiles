#!/bin/zsh
# git worktree helpers ########################
# wt                        pick a worktree and cd into it
# wt $branch [$base]        create or reuse a worktree for $branch and cd in
# wt ls                     list worktrees
# wt rm [$branch]           remove a worktree, dropping the branch if merged
# wt prune                  clear stale entries, report merged worktrees
#
# Worktrees land as siblings of the main checkout — <repo>-<branch> next to
# <repo> — rather than in a central directory such as ~/.worktrees. The
# [includeIf "gitdir:…/devguard/"] blocks in gitconfig.symlink match on path,
# so a worktree parked outside that tree would quietly commit with the wrong
# identity. Being siblings also keeps direnv, tmuxinator projects and editor
# workspaces resolving the way they do in the main checkout.
#
# Two gotchas no helper can paper over: the stash is shared across all
# worktrees of a repository, so don't stash while parallel sessions are
# running, and the same branch cannot be checked out twice — `wt $branch` cds
# to the existing worktree instead of failing.

# the main checkout, no matter which worktree we are standing in:
# --git-common-dir points at <main>/.git from a linked worktree too
function _wt_root() {
  local common
  common="$(command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || return 1
  print -r -- "${common:h}"
}

# <repo>-<branch>, with slashes flattened: branch feature/login in repo "app"
# becomes ../app-feature-login
function _wt_path() {
  print -r -- "${1}-${2//\//-}"
}

# where a new branch starts from, and what "merged" is measured against: the
# remote's default branch when origin/HEAD is set (a normal clone), otherwise
# whatever the main checkout has out. Never the current worktree's HEAD — from
# inside a feature worktree that would branch off, and compare against, itself
function _wt_base() {
  local head
  head="$(command git -C "$1" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)"
  [[ -z "$head" ]] && head="$(command git -C "$1" symbolic-ref --quiet --short HEAD 2>/dev/null)"
  print -r -- "$head"
}

# path of the worktree that has $branch checked out, empty if none does
function _wt_find() {
  local root="$1" branch="$2" line current=""
  command git -C "$root" worktree list --porcelain 2>/dev/null | while IFS= read -r line; do
    case "$line" in
      "worktree "*) current="${line#worktree }" ;;
      "branch refs/heads/$branch") print -r -- "$current"; break ;;
    esac
  done
}

# branch checked out in the worktree at $2, empty when detached
function _wt_branch() {
  command git -C "$2" symbolic-ref --quiet --short HEAD 2>/dev/null
}

# copy the gitignored files a fresh checkout does not get — .env and friends,
# the number one papercut of any worktree flow. Patterns live one per line in
# .worktreeinclude at the repo root, gitignore syntax; that is the same file
# `claude --worktree` reads, so both flows stay in sync from one list.
function _wt_include() {
  local src="$1" dst="$2" include="$1/.worktreeinclude" line rel match
  [[ -f "$include" ]] || return 0

  local -a matches
  local -i copied=0
  while IFS= read -r line; do
    [[ -z "${line// /}" || "$line" == \#* ]] && continue
    # ${~line} makes the line expand as a glob, (DN) includes dotfiles and
    # swallows patterns that match nothing
    matches=("$src"/${~line}(DN))
    for match in $matches; do
      rel="${match#$src/}"
      mkdir -p "$dst/${rel:h}"
      cp -R "$match" "$dst/$rel"
      copied+=1
    done
  done < "$include"

  (( copied )) && print -r -- "wt: copied $copied ignored path(s) from .worktreeinclude"
  return 0
}

# a JS app is broken without node_modules, which a worktree does not inherit
# either. pnpm's content-addressable store makes N copies near-free, so it is
# the one package manager worth doing automatically — set WT_NO_INSTALL=1 to
# skip, and run anything else by hand
function _wt_install() {
  local dst="$1"
  [[ -n "$WT_NO_INSTALL" ]] && return 0
  [[ -f "$dst/pnpm-lock.yaml" ]] || return 0
  (( $+commands[pnpm] )) || return 0

  print -r -- "wt: pnpm install"
  (cd "$dst" && pnpm install --prefer-offline)
}

# fzf over the worktree list; $2 skips the main checkout for `wt rm`
function _wt_pick() {
  local root="$1" list
  if [[ "$2" == "linked" ]]; then
    list="$(command git -C "$root" worktree list | tail -n +2)"
  else
    list="$(command git -C "$root" worktree list)"
  fi
  [[ -z "$list" ]] && return 1

  if (( ! $+commands[fzf] )); then
    print -r -- "$list"
    return 1
  fi

  print -r -- "$list" | fzf --height=40% --reverse --with-nth=1,2,3 \
    --preview 'git -C {1} log --oneline --color=always -10' | awk '{ print $1 }'
}

function _wt_remove() {
  local root="$1" target="$2" dst branch
  if [[ -z "$target" ]]; then
    dst="$(_wt_pick "$root" linked)" || return 1
  else
    dst="$(_wt_find "$root" "$target")"
    # not checked out anywhere: it may still be a detached worktree sitting at
    # the conventional path, otherwise there is nothing to remove
    if [[ -z "$dst" ]]; then
      dst="$(_wt_path "$root" "$target")"
      if ! command git -C "$root" worktree list --porcelain | grep -qxF "worktree $dst"; then
        print -u2 -r -- "wt: no worktree for $target"
        return 1
      fi
    fi
  fi
  [[ -z "$dst" ]] && return 1

  if [[ "$dst" == "$root" ]]; then
    print -u2 -r -- "wt: refusing to remove the main checkout"
    return 1
  fi

  branch="$(_wt_branch "$root" "$dst")"
  # standing inside it would leave the shell in a deleted directory
  [[ "$PWD" == "$dst"* ]] && cd "$root"
  # a headless `claude -p --worktree` run never cleans up and can leave the
  # worktree locked, which makes `worktree remove` refuse
  command git -C "$root" worktree unlock "$dst" 2>/dev/null
  command git -C "$root" worktree remove "$dst" || return 1
  print -r -- "wt: removed $dst"

  # the branch outlives its worktree; -d drops it only when merged, so an
  # unmerged one survives with a warning we can ignore here
  [[ -n "$branch" ]] && command git -C "$root" branch -d "$branch" 2>/dev/null
  return 0
}

function _wt_prune() {
  local root="$1" base line dst branch
  command git -C "$root" worktree prune -v
  base="$(_wt_base "$root")"

  # merged worktrees are reported, not deleted: `wt rm` is one keystroke away
  # and removing directories behind someone's back is how work gets lost
  command git -C "$root" worktree list --porcelain | while IFS= read -r line; do
    case "$line" in
      "worktree "*) dst="${line#worktree }" ;;
      "branch refs/heads/"*)
        branch="${line#branch refs/heads/}"
        [[ "$dst" == "$root" ]] && continue
        # uncommitted work is unmerged work, whatever the branch graph says —
        # and `worktree remove` would refuse it anyway
        [[ -n "$(command git -C "$dst" status --porcelain 2>/dev/null)" ]] && continue
        if command git -C "$root" merge-base --is-ancestor "refs/heads/$branch" "$base" 2>/dev/null; then
          print -r -- "wt: $branch is merged into $base — wt rm $branch"
        fi
        ;;
    esac
  done
}

function wt() {
  local root branch base dst existing
  root="$(_wt_root)" || { print -u2 -r -- "wt: not a git repository"; return 1 }

  case "$1" in
    ls|list)
      command git -C "$root" worktree list
      return
      ;;
    rm|remove)
      _wt_remove "$root" "$2"
      return
      ;;
    prune)
      _wt_prune "$root"
      return
      ;;
    -h|--help)
      print -r -- "usage: wt [<branch> [<base>] | ls | rm [<branch>] | prune]"
      return
      ;;
  esac

  if [[ -z "$1" ]]; then
    dst="$(_wt_pick "$root")" || return 1
    [[ -n "$dst" ]] && cd "$dst"
    return
  fi

  branch="$1"
  existing="$(_wt_find "$root" "$branch")"
  if [[ -n "$existing" ]]; then
    cd "$existing"
    return
  fi

  dst="$(_wt_path "$root" "$branch")"
  if [[ -d "$dst" ]]; then
    print -u2 -r -- "wt: $dst exists but is not a worktree of this repository"
    return 1
  fi

  if command git -C "$root" show-ref --verify --quiet "refs/heads/$branch"; then
    command git -C "$root" worktree add "$dst" "$branch" || return 1
  elif command git -C "$root" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    # existing remote branch: track it rather than forking a namesake off base
    command git -C "$root" worktree add --track -b "$branch" "$dst" "origin/$branch" || return 1
  else
    base="${2:-$(_wt_base "$root")}"
    command git -C "$root" worktree add -b "$branch" "$dst" "${base:-HEAD}" || return 1
  fi

  _wt_include "$root" "$dst"
  _wt_install "$dst"
  cd "$dst"
}
