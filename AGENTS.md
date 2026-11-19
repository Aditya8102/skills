# AGENTS.md

My agent skills and the always-on rule. Layout and install: see the [README](README.md).

Owner: Aditya8102 (personal)

Check before every commit:

```sh
pip install skills-ref==0.1.1
for s in skills/*/; do agentskills validate "$s"; done
bash -n install.sh
```

## Decisions

- Companions are pinned in `install.sh`, and every skill installed from them is called by a named step in the rule or a skill. A companion skill that no step calls gets removed.
- Ponytail's always-on mode is left out: the rule and the Change routine already cover it.
- `rules/kanso.mdc` is the only copy of the rule. `install.sh` copies it out and never edits it.
- The README's agent and companion tables mirror the `agents` and `companions` tables in `install.sh`. Change both together.
