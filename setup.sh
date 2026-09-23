#!/bin/bash
# Prepare the BPF CI AI review environment.
#
# Usage: setup.sh <kernel-worktree> <trigger-output-file>
#
# - lays out the review prompts in <kernel-worktree>/review
# - renders trigger.md into <trigger-output-file>, substituting
#   ${SHA}, ${BASE_SHA} and ${HEAD_SHA} from the environment
# - appends claude/env to $GITHUB_ENV, if set, so that the variables
#   reach the Claude Code step
set -euo pipefail

if [ $# -ne 2 ]; then
	echo "usage: $0 <kernel-worktree> <trigger-output-file>" >&2
	exit 2
fi

worktree=$1
trigger_out=$2
wrapper_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
prompts_dir=$wrapper_dir/review-prompts/kernel

: "${SHA:?}" "${BASE_SHA:?}" "${HEAD_SHA:?}"

if [ ! -f "$prompts_dir/agent/orc.md" ]; then
	echo "review-prompts submodule is not checked out: $prompts_dir" >&2
	exit 1
fi

rm -rf "$worktree/review"
cp -r "$prompts_dir" "$worktree/review"

trigger=$(<"$wrapper_dir/trigger.md")
trigger=${trigger//'${SHA}'/$SHA}
trigger=${trigger//'${BASE_SHA}'/$BASE_SHA}
trigger=${trigger//'${HEAD_SHA}'/$HEAD_SHA}
printf '%s\n' "$trigger" > "$trigger_out"

env_vars=$(grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' "$wrapper_dir/claude/env" || true)
if [ -n "${GITHUB_ENV:-}" ] && [ -n "$env_vars" ]; then
	printf '%s\n' "$env_vars" >> "$GITHUB_ENV"
fi

echo "bpf-ai-review: $(git -C "$wrapper_dir" rev-parse --verify -q HEAD || echo unknown)"
echo "review-prompts: $(git -C "$wrapper_dir/review-prompts" log -1 --format='%H %s' 2>/dev/null || echo unknown)"
echo "claude env: ${env_vars:-none}"
