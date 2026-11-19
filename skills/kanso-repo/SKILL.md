---
name: kanso-repo
description: Routine for repo work in any situation, such as starting a new repo, joining an unfamiliar one, implementing a change, restructuring, fixing a bug, contributing to someone else's repo, or finishing up. Use at the start of repo-level work or when the user says "new repo", "onboard me", "explain this repo", "restructure" or "contribute".
---

# Kanso repo routine

Read the repo's `AGENTS.md` first if it exists. Then pick the situation and follow its steps.
If the user names one, as in `/kanso-repo join`, use it.
A step that names a companion skill (`ponytail-*`, `egm-*`) that isn't installed: do it by hand and say so.

| Situation | Signal |
| --- | --- |
| New repo | Empty folder, or "start a repo" |
| Join | Unfamiliar repo, "explain", "onboard me" |
| Change | A feature or edit in my repo |
| Restructure | Layout, tooling, or changes across many files |
| Bug | Wrong output, an error, a failing check |
| Contribute | A repo I don't own |

Every situation ends with [Finish](#finish).

## New repo

1. Ask the goal, who uses it first, and what is out of scope.
2. Create only what the first working version needs: README, `AGENTS.md` from [AGENTS.template.md](AGENTS.template.md), the code, and, if the code needs them, a locked dependency file, formatter and linter config, `.gitignore`.
3. Make the main command work end to end before adding structure.
4. Commit once it runs.

## Join

Read only. No edits until asked.

1. Read the README, `AGENTS.md`, dependency files, entry points, CI config and recent `git log`.
2. Run setup, the repo's check and the main command. Point anything that writes outside the repo at a temp folder or venv, or skip it and say why. Note what fails.
3. Reply with a one-page map: what it does, how to run it, a layout tree with one line per entry, where the knobs live, and open questions.
4. If `AGENTS.md` is missing, offer to write one from the template.

## Change

1. Restate the goal and how success will be checked.
2. Make the smallest complete change: reuse what the repo has, then the standard library, then an installed dependency. Add nothing that wasn't asked for, and finish every caller it touches.
3. Run the repo's checks and the main command on a real input.
4. Update the one doc that describes the changed behavior.

## Restructure

Only in my repos.

1. Baseline: record current outputs on real inputs, outside the repo, so later phases can be compared exactly.
2. Proposal: start from a `ponytail-audit`, then write the current state, target layout, what moves where, phases, risks and open decisions. Draft it with `egm-draft` and review it with `egm-review`.
3. Wait for approval.
4. Implement one phase at a time. After each phase, compare with the baseline and commit.
5. Final pass: `egm-drift-report` for docs against code, `ponytail-debt` for open shortcuts, dead code, then a `kanso` review.

## Bug

1. Reproduce with the smallest input.
2. Find the root cause: read the whole error, trace the bad value back, compare with a working case.
3. Fix it once, in the shared code. Search for every caller first.
4. Verify with the reproduction. Add a regression test if the repo has tests.
5. After three failed fixes, stop, question the approach and tell me.

## Contribute

1. Follow the repo's CONTRIBUTING, `AGENTS.md` and surrounding style, even where Kanso differs.
2. Every changed line traces to the request. List cleanup ideas instead of doing them.
3. Run their checks. The pull request says what changed, why, and how it was verified.

## Finish

- Show the evidence: commands run and their results.
- If code changed, review the diff with `ponytail-review`. Check the diff and anything written outside the repo for debug leftovers and unrelated changes.
- Say in one or two lines what was not checked and what could break.
- If a rule would have prevented a problem in this session, suggest one line for the always-on rule (`rules/kanso.mdc` in the skills repo).
