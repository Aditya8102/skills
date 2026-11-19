# kanso-kit

My house style for AI coding agents, packaged as one Cursor plugin. Once installed, it applies in every repo.

## Install

Once per machine:

```sh
git clone --recurse-submodules <repo-url> ~/.cursor/plugins/local/kanso
~/.cursor/plugins/local/kanso/install.sh
```

Reload Cursor. Settings > Plugins lists `kanso` and `egm`.

## Contents

| Path | What | Loaded |
| --- | --- | --- |
| `rules/kanso.mdc` | The six Kanso rules, precedence, working habits | Every chat |
| `skills/kanso/` | Docs, comments and review style; `practices.md` holds the engineering practices | On demand |
| `skills/kanso-repo/` | A routine per situation: new, join, change, restructure, bug, contribute; the `AGENTS.md` template | On demand |
| `vendor/ponytail/` | [ponytail](https://github.com/DietrichGebert/ponytail) v5.3.3, a submodule: its rule and skills | Rule every chat, skills on demand |

`install.sh` adds [EGM](https://github.com/google/elephant-goldfish-model) beside the kit as its own plugin, pinned by `EGM_SHA`.

## Update

```sh
git -C ~/.cursor/plugins/local/kanso pull --recurse-submodules
```

- Ponytail: `git -C vendor/ponytail checkout <tag>`, then commit.
- EGM: change `EGM_SHA` in `install.sh`, delete `~/.cursor/plugins/local/egm`, rerun `install.sh`.

## Per repo

Copy `skills/kanso-repo/AGENTS.template.md` into the repo as `AGENTS.md` and fill in repo facts only.

## Without the plugin

Cloud agents and other tools don't load local plugins. Paste the body of `rules/kanso.mdc` into Cursor Settings > Rules > User Rules, or into the repo's `AGENTS.md`.

## Keep it Kanso

After a session that went wrong, add one line where it belongs. Delete lines that never change behavior.
