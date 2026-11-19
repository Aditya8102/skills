#!/usr/bin/env bash
# Set up the always-on rule and the skills in every agent on this machine; --remove takes them out. Safe to rerun.
set -euo pipefail

repo=$(cd "$(dirname "$0")" && pwd)
mode=${1:-}
start='<!-- aditya-skills:start -->'
end='<!-- aditya-skills:end -->'
plugin=$HOME/.cursor/plugins/local/aditya-skills
#        agent        home            always-on file             skills folder
agents=("Codex|$HOME/.codex|$HOME/.codex/AGENTS.md|$HOME/.agents/skills"
        "Claude Code|$HOME/.claude|$HOME/.claude/CLAUDE.md|$HOME/.claude/skills"
        "Gemini CLI|$HOME/.gemini|$HOME/.gemini/GEMINI.md|$HOME/.gemini/skills")

drop_rule() {  # drop_rule FILE: delete the rule block, and the file if nothing else is left
  [ -f "$1" ] || return 0
  sed -i.bak "/$start/,/$end/d" "$1" && rm "$1.bak"
  [ -s "$1" ] || rm "$1"
}

put_rule() {  # put_rule FILE: write the rule between markers, replacing an older copy
  drop_rule "$1"
  mkdir -p "$(dirname "$1")" && touch "$1"
  [ -s "$1" ] && [ -n "$(tail -c1 "$1")" ] && echo >> "$1"
  { echo "$start"
    awk 'NR == 1 && /^---$/ { fm = 1; next } fm && /^---$/ { fm = 0; next } !fm' "$repo/rules/kanso.mdc"
    echo "$end"; } >> "$1"
}

skills() {  # skills DIR: link each skill into DIR, or with --remove delete those links
  [ "$mode" = --remove ] || mkdir -p "$1"
  for skill in "$repo"/skills/*/; do
    skill=${skill%/}
    target=$1/$(basename "$skill")
    if [ "$mode" = --remove ]; then
      if [ "$(readlink "$target")" = "$skill" ]; then rm "$target"; fi
    elif [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "  skipped $target: a different skill has that name"
    else
      ln -sfn "$skill" "$target"
    fi
  done
}

case $mode in
  "" | --remove) ;;
  *) echo "usage: $0 [--remove]" >&2; exit 1 ;;
esac

if [ -d "$HOME/.cursor" ]; then
  echo "Cursor: rule in $plugin, skills in $HOME/.agents/skills"
  rm -rf "$plugin"
  [ "$mode" = --remove ] || { mkdir -p "$plugin" && cp -R "$repo/.cursor-plugin" "$repo/rules" "$plugin/"; }
  skills "$HOME/.agents/skills"
fi
for entry in "${agents[@]}"; do
  IFS='|' read -r name home rule_file skills_dir <<< "$entry"
  [ -d "$home" ] || continue
  echo "$name: rule in $rule_file, skills in $skills_dir"
  if [ "$mode" = --remove ]; then drop_rule "$rule_file"; else put_rule "$rule_file"; fi
  skills "$skills_dir"
done

if [ "$mode" = --remove ]; then echo "Removed. Restart your agents."; else echo "Done. Restart your agents, and rerun this after every git pull."; fi
