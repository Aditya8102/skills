# AGENTS.md

My agent skills and the always-on Kanso rule. Layout and install: see the [README](README.md).

Owner: mine

Check before every commit:

```sh
pip install skills-ref
for s in skills/*/; do agentskills validate "$s"; done
bash -n install.sh
```

## Decisions

- No dependencies. Companions such as ponytail and EGM are installed separately, never bundled.
- `rules/kanso.mdc` is the only copy of the rule. `install.sh` copies it out and never edits it.
