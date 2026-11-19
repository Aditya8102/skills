# skills

My agent skills and my house style, Kanso, in one repo. One install sets them up in Cursor, Claude Code, Codex and Gemini CLI. Any other agent that reads [Agent Skills](https://agentskills.io) can use the skills too.

The kit is one always-on rule and a few skills. Everything else only loads them into agents.

## Install

```sh
git clone https://github.com/Aditya8102/skills.git ~/skills
~/skills/install.sh
```

Then restart your agents. Clone to a path you'll keep, because the skills are linked from there.

| Task | Command |
| --- | --- |
| Update | `cd ~/skills && git pull && ./install.sh` |
| Remove | `~/skills/install.sh --remove` |

## Use it

| You type | What happens |
| --- | --- |
| Nothing | The always-on rule applies in every chat |
| `/kanso-repo` | The agent picks the situation and follows its routine |
| `/kanso-repo join` | Read-only tour of an unfamiliar repo, ending in a one-page map |
| `/kanso-repo new`, `change`, `restructure`, `bug`, `contribute` | That situation's routine |
| `/kanso review <path>` | Kanso review: each finding with the rule, `file:line` and the fix |
| `/kanso <path>` | Rewrite a doc or comments in Kanso style |

Agents also pick a skill on their own when a task matches its description. In Codex, type `$kanso-repo` instead of `/kanso-repo`. Gemini CLI has no skill commands, so ask in words, such as "use kanso-repo to join this repo".

To give a repo its own facts, copy `skills/kanso-repo/AGENTS.template.md` into it as `AGENTS.md` and fill it in. Agents read it before anything else.

## Dependencies

None to use it: everything is Markdown. Cloning needs `git`; `install.sh` needs only `bash`.

Optional companions, installed separately:

| Companion | Adds | Install |
| --- | --- | --- |
| [ponytail](https://github.com/DietrichGebert/ponytail) | A smallest-change coding mode | [Its install guide](https://github.com/DietrichGebert/ponytail/blob/main/INSTALL.md) |
| [EGM](https://github.com/google/elephant-goldfish-model) | Independent reviewers for design docs | [Its getting-started guide](https://github.com/google/elephant-goldfish-model/blob/main/docs/getting_started.md) |

The skills work without them. `kanso-repo` uses EGM for reviews when it is installed.

## Where it installs

`install.sh` sets up each agent it finds:

| Agent | Found by | Always-on rule | Skills |
| --- | --- | --- | --- |
| Cursor | `~/.cursor` | Local plugin in `~/.cursor/plugins/local/aditya-skills` | `~/.agents/skills` |
| Codex | `~/.codex` | Block in `~/.codex/AGENTS.md` | `~/.agents/skills` |
| Claude Code | `~/.claude` | Block in `~/.claude/CLAUDE.md` | `~/.claude/skills` |
| Gemini CLI | `~/.gemini` | Block in `~/.gemini/GEMINI.md` | `~/.agents/skills` |

The rule block sits between `<!-- aditya-skills:start -->` and `<!-- aditya-skills:end -->`. Anything else in those files stays untouched. Remove deletes the blocks, the skill links and the Cursor plugin; empty folders stay, and a rule file is deleted if nothing else is left in it.

Cursor also reads `~/.claude/skills`, so with Claude Code installed it may list each skill twice. Both entries are the same files.

### Other ways in

- **Cursor without cloning:** open Customize, choose From GitHub Repository, enter `Aditya8102/skills`, then install `aditya-skills`. Use this or `install.sh`, not both.
- **Any other agent:** `npx skills add Aditya8102/skills -g` installs the skills (needs Node 22.20 or later). Paste the body of `rules/kanso.mdc` into that agent's global instructions.
- **Cloud agents** see only the repo. Paste the rule into the repo's `AGENTS.md`, and run `npx skills add Aditya8102/skills` inside the repo to add the skills under `.agents/skills/`.

## Layout

```
skills/
├── rules/kanso.mdc      The always-on rule: six Kanso rules, precedence, working habits
├── skills/
│   ├── kanso/           Docs, comments and review style; practices.md holds the engineering practices
│   └── kanso-repo/      A routine per repo situation, plus an AGENTS.md template
├── install.sh           Sets up the rule and skills in each agent; --remove takes them out
├── .cursor-plugin/      Makes the repo a Cursor plugin and marketplace
└── AGENTS.md            This repo's owner, check and decisions
```

## Add a skill

1. Create `skills/<name>/SKILL.md` with `name: <name>` and a `description` that says what it does and when to use it.
2. Run the check in [AGENTS.md](AGENTS.md).
3. Run `./install.sh` and commit.

Guidance that applies to every chat goes in `rules/kanso.mdc`. Everything else is a skill.
