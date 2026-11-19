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

- No dependencies. Companions such as ponytail and EGM are installed separately, never bundled.
- `rules/kanso.mdc` is the only copy of the rule. `install.sh` copies it out and never edits it.
- The README's per-agent table mirrors the `agents` table in `install.sh`. Change both together.
