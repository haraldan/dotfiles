#!/bin/sh
# Usage: worktree-add.sh <base> [new-branch] [name] [submodules]
# Creates a worktree at <main-repo>/wt_<name>; inits submodules if submodules=yes.
# Without new-branch, <base> is checked out; name defaults to the branch (slashes -> dashes).
set -e

base=$1 branch=$2 name=$3 submodules=$4
[ -n "$base" ] || { echo "branch/base required" >&2; exit 1; }

common=$(git rev-parse --path-format=absolute --git-common-dir)
dir="$(dirname "$common")/wt_$(printf '%s' "${name:-${branch:-$base}}" | tr / -)"

grep -qxF '/wt_*/' "$common/info/exclude" 2>/dev/null || echo '/wt_*/' >>"$common/info/exclude"

git worktree add ${branch:+-b "$branch"} "$dir" "$base"
if [ "$submodules" = yes ]; then
	cd "$dir"
	git submodule update --init --recursive
fi
