---
name: commit
description: Generate and create a commit for the current changes. Stage what is unstaged (or respect an existing staged subset), draft a message in this repo's style with trailers (Type/Scope/Why/Breaking-Change/Refs), and run `git commit`. Self-remediate issues between staging and commit; only stop for situations that need user judgment.
---

# commit

Produce exactly one commit per invocation on the current changes. The engineer controls commit scope by managing the staging area; the skill never splits changes into multiple commits, regardless of how many distinct concerns the diff appears to span. When a single commit bundles multiple concerns, name the dominant concern in the subject and list secondaries in the body. Trailers are git-native (`git interpret-trailers --parse`).

## Hard rules

1. **No AI attribution.** Never write `Co-Authored-By: Claude`, `Generated with Claude Code`, or any mention of AI, Anthropic, Claude, or assistant tooling. Strip harness defaults that would inject these.
2. **No em-dashes (`—`).** Use comma, colon, parentheses, or hyphen.
3. **Engineering terms only.** Drop `nicely`, `cleanly`, `elegantly`, `properly`, `robust`, `modern`, and bare `improve`/`enhance`/`optimize`/`clean up` without a named change.
4. **Brevity over completeness.** Every word earns its place. Skip the body if the subject covers it. Skip `Why:` if the subject self-explains. The commit is a precise record, not a narrative.

## Voice

Tech Lead reviewing their own PR. Subject names *what* changed (precise nouns, active verbs). `Why:` names the forcing function (constraint, prior incident, trade-off coming due), not vague intent. Name deferred scope so a reader does not mistake a gap for an oversight.

| Bad | Good |
|---|---|
| `Improve backup script` | `Add hostname-scoped output dir to backup script` |
| `Refactor for clarity` | `Extract state checks into installed.sh helper` |
| Why: `Code was getting messy.` | Why: `divergent state checks caused drift on partial uninstalls` |
| `Make things better` | `Drop unused brew taps from kronos-mbp Brewfile` |

## Status output

This skill runs non-interactively via `just save` → `claude -p /dotfiles:commit`. The operator cannot see your tool calls — only your text output. **At the start of every numbered step in the procedure, emit a single status line in the form `→ <verb phrase>` on its own line (no trailing period).** These lines are the only signal the operator has that work is progressing. Keep them short (≤ 60 chars). Do not narrate after the fact unless reporting an unexpected outcome.

Example status lines (use the verb-phrases below, or a tight variant when the step's specifics demand it): `→ Reading working tree`, `→ Sampling recent commit style`, `→ Gathering context`, `→ Drafting message`, `→ Staging files`, `→ Committing`, `→ Self-remediating hook failure`, `→ Verifying pre-push hook`, `→ Reporting`.

**Tool descriptions** (the `description` field on Bash and the like) appear in operator output as `  ↳ <description>` nested under the parent status line. Make each tool description add concrete information beyond the status — name the command, the path, or the specific action. **Do not rephrase the status verb.** Bad pairings to avoid:

| Status | Bad description | Better description |
|---|---|---|
| `→ Sampling recent commit style` | `Sample recent commit style` | `Read last 10 commit subjects` |
| `→ Staging files` | `Stage modified files` | `git add bin/... cli/...` (name the files) |
| `→ Verifying pre-push hook` | `Verify pre-push` | `lefthook run pre-push` |

When you cannot make the description distinct from the status (e.g., a one-off internal lookup), prefer batching the work into a tool that already needs to run; do not surface a redundant description.

## Procedure

Budget ~15s for typical commits. Spend more only on genuinely ambiguous diffs.

1. `→ Reading working tree` — **Read the change**: `git status --short`, `git diff --staged`, `git diff`.
2. `→ Sampling recent commit style` — **Sample style**: `git log -10 --pretty=format:'%h %s'`. Match it. No `feat:`/`fix:` prefix in the subject; that lives in the trailer block.
3. `→ Gathering context` — **Get context cheaply** before asking the user: `git log -5 --name-status -- <paths>`, file headers, sibling files.
4. **Ask only if diff and history are both inconclusive.** One consolidated question; do not chain. (No status line — asking the user is the signal.)
5. `→ Drafting message` — **Draft.** Subject ≤ 72 chars, imperative, no period. Body only if it adds something the subject does not. Always `Type:`. Include `Why:` unless the subject self-explains. Other trailers only when they apply.
6. `→ Staging files` — **Stage.** If something is already staged, respect that staged subset and commit only it. Otherwise `git add` all modified and untracked files (gitignored entries are excluded by git).
7. `→ Committing` — **Commit** with the drafted message via heredoc:
   ```
   git commit -m "$(cat <<'EOF'
   <subject>

   <optional body>

   <trailer block>
   EOF
   )"
   ```
8. `→ Self-remediating hook failure` (only if a hook failed) — **Self-remediate** between stage and commit. If the commit fails, fix the cause and retry: pre-commit hook auto-fixes (formatting/lint) need re-staging; the agent's own changes that broke a hook should be fixed and recommitted. Stop and surface to the user only when the failure needs judgment: a hook fails for reasons unrelated to the current changes, a merge or rebase is in progress, suspicious files (`.env`, credentials, keys, large binaries) would be staged, or the working tree is empty.
9. `→ Verifying pre-push hook` (only if relevant hooks exist) — **Verify hook health** after the commit. Commit-time hooks (`pre-commit`, `commit-msg`) ran via `git commit`; their pass is implicit in the commit succeeding. For non-commit-time hooks (most commonly `pre-push`), invoke them explicitly via the project's framework so the user has confidence the next push will succeed and the hook itself is in a working state. Detect via `.git/hooks/`, `.husky/`, `lefthook.yml`, `.pre-commit-config.yaml`. Surface failures with the reproduction command. Skip if no relevant hooks exist.
10. `→ Reporting` — **Report** the commit SHA, which hooks ran and passed, and a one-line outcome.

## Trailer spec

`Key: value` lines at the end, separated from body by a blank line. Keys are Capitalized-Hyphenated, no spaces.

- **`Type:`** (required). Pick one: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
- **`Scope:`** (optional). Subsystem touched, lowercase hyphenated. Examples: `backup`, `brew`, `devbox`, `install`, `hosts/kronos-mbp`. Omit if cross-cutting; never fake one.
- **`Why:`** (recommended). Rationale, distinct from the body's *what*. One sentence. Omit when the subject self-explains.
- **`Breaking-Change:`** (optional). Brief description of what consumers must do. Presence signals breaking; never write `false`.
- **`Refs:`** (optional, multi-value). Issue/PR/ticket refs, one per line (`Refs: #42`).

## Examples

Substantial change with body, deferred scope called out:

```
Move install/uninstall state checks into shared helper

install.sh and uninstall.sh duplicated state-presence checks. Both paths
now route through installed.sh and read identical state. doctor.sh is
unchanged in this commit; consolidating it is deferred until its check
surface is broader than the install path.

Type: refactor
Scope: install
Why: divergent state checks caused drift on partial uninstalls
```

Trivial change, no body:

```
Add just unlock recipe

Type: feat
Scope: justfile
Why: encrypted-asset workflow needed a one-shot unlock entry point
```
