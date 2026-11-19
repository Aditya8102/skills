# skills

My agent skills and my house style, Kanso, in one repo. One install sets them up in Cursor, Claude Code, Codex and Gemini CLI. Any other agent that reads [Agent Skills](https://agentskills.io) can use the skills too.

The kit is one rule and a few skills. Everything else only loads them into agents.

## Use it

| Type | What happens |
| --- | --- |
| Nothing | The Kanso rule applies in every chat |
| `/kanso-repo` | The agent picks the situation and follows its routine |
| `/kanso-repo join` | Read-only tour of an unfamiliar repo, ending in a one-page map |
| `/kanso-repo new`, `change`, `restructure`, `bug`, `contribute` | That situation's routine |
| `/kanso review <path>` | Kanso review: each finding with the rule, `file:line` and the fix |
| `/kanso <path>` | Rewrite a doc or comments in Kanso style |

Agents also pick a skill on their own when a task matches its description. In Codex, type `$kanso-repo` instead of `/kanso-repo`.

## What's inside

| Path | What it is | When the agent sees it |
| --- | --- | --- |
| `rules/kanso.mdc` | The always-on rule: six Kanso rules, who wins in a conflict, working habits | Every chat |
| `skills/kanso/` | How docs, comments and reviews should look; `practices.md` holds the engineering practices | When writing docs or reviewing |
| `skills/kanso-repo/` | A routine per situation: new repo, joining, change, restructure, bug, contributing; plus an `AGENTS.md` template | At the start of repo work |
| `install.sh` | Sets up the rule and skills in each agent on the machine | When you run it |
| `.cursor-plugin/` | Makes the repo a Cursor plugin | Cursor reads it |

## Dependencies

None to use it: everything is Markdown. `install.sh` needs only `bash` and `git`.

Optional companions, installed separately:

| Companion | Adds | Install |
| --- | --- | --- |
| [ponytail](https://github.com/DietrichGebert/ponytail) | A smallest-change coding mode | [Its install guide](https://github.com/DietrichGebert/ponytail/blob/main/INSTALL.md) |
| [EGM](https://github.com/google/elephant-goldfish-model) | Independent reviewers for design docs | [Its getting-started guide](https://github.com/google/elephant-goldfish-model/blob/main/docs/getting_started.md) |

The skills work without them. `kanso-repo` uses EGM for reviews when it is installed.

## Install

Clone it to a path you'll keep, because the skills are linked from there:

```sh
git clone git@github.com:Aditya8102/skills.git ~/skills
~/skills/install.sh
```

Then restart your agents. `install.sh` sets up each agent it finds:

| Agent | Found by | Always-on rule | Skills |
| --- | --- | --- | --- |
| Cursor | `~/.cursor` | Local plugin in `~/.cursor/plugins/local/aditya-skills` | `~/.agents/skills` |
| Codex | `~/.codex` | Block in `~/.codex/AGENTS.md` | `~/.agents/skills` |
| Claude Code | `~/.claude` | Block in `~/.claude/CLAUDE.md` | `~/.claude/skills` |
| Gemini CLI | `~/.gemini` | Block in `~/.gemini/GEMINI.md` | `~/.gemini/skills` |

The rule block sits between `<!-- aditya-skills:start -->` and `<!-- aditya-skills:end -->`. Anything else in those files stays untouched.

Cursor also reads `~/.claude/skills`, so with Claude Code installed it may list each skill twice. Both entries are the same files.

### Other ways in

- **Cursor without cloning:** open Customize, choose From GitHub Repository, enter `Aditya8102/skills`, then install `aditya-skills`. Use this or `install.sh`, not both.
- **Any other agent:** `npx skills add Aditya8102/skills -g` installs the skills (needs Node 22.20 or later). Paste the body of `rules/kanso.mdc` into that agent's global instructions.
- **Cloud agents** see only the repo. Paste the rule into the repo's `AGENTS.md`, and run `npx skills add Aditya8102/skills` inside the repo to add the skills under `.agents/skills/`.

## Update

```sh
cd ~/skills && git pull && ./install.sh
```

## Add a skill

1. Create `skills/<name>/SKILL.md` with `name: <name>` and a `description` that says what it does and when to use it.
2. Validate it: `pip install skills-ref`, then `agentskills validate skills/<name>`.
3. Run `./install.sh` and commit.

Guidance that applies to every chat goes in `rules/kanso.mdc`. Everything else is a skill.

## Use in a repo

Copy `skills/kanso-repo/AGENTS.template.md` into the repo as `AGENTS.md` and fill in that repo's facts.

## Remove

```sh
~/skills/install.sh --remove
```

It deletes only what `install.sh` added: the rule blocks, the skill links and the Cursor plugin.
