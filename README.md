# BPF CI AI review

Configuration of the AI code review that
[BPF CI](https://github.com/kernel-patches/vmtest) runs on patches posted to
the BPF mailing list. The review itself is done by Claude Code following
[review-prompts](https://github.com/masoncl/review-prompts); this repository
pins the prompts and adds what is specific to BPF CI.

## Layout

- `review-prompts/`: submodule tracking the `bpf-ci` branch of
  [kernel-patches/review-prompts](https://github.com/kernel-patches/review-prompts),
  a fork of masoncl/review-prompts. `main` of the fork mirrors upstream,
  `bpf-ci` carries local changes on top of it.
- `trigger.md`: the prompt the review job starts with. `${SHA}`,
  `${BASE_SHA}` and `${HEAD_SHA}` are substituted by `setup.sh`.
- `claude/env`: environment variables for the Claude Code step, exported by
  `setup.sh` through `$GITHUB_ENV`.
- `setup.sh`: called by the review job to lay out the prompts in the kernel
  tree, export `claude/env` and render the trigger prompt.

## How it is used

`.github/workflows/ai-code-review.yml` in kernel-patches/vmtest checks out
this repository with submodules and runs:

    SHA=<commit> BASE_SHA=<base> HEAD_SHA=<head> \
        ./setup.sh <kernel-worktree> <trigger-output-file>

The job then runs Claude Code in the kernel tree with the rendered trigger.
The workflow uses `main` of this repository, so a push to `main` takes effect
on the next review job.

## Making changes

- Prompt changes, including BPF CI specific review rules: commit to the
  `bpf-ci` branch of the fork, then update the submodule here. Changes meant
  for upstream should also be sent to masoncl/review-prompts.
- Updating upstream prompts: sync `main` of the fork with upstream, rebase
  `bpf-ci` on it, then update the submodule here.
- Test changes on kernel-patches/bpf-rc before merging to `main`: AI reviews
  there use the same infrastructure but are not emailed.
