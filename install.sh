#!/usr/bin/env bash
# Set up the always-on rule, the skills and their companions in every agent on this machine; --remove takes them out. Safe to rerun.
set -euo pipefail

repo=$(cd "$(dirname "$0")" && pwd)
mode=${1:-}
kit=aditya-skills
start="<!-- $kit:start -->"
end="<!-- $kit:end -->"
plugin=$HOME/.cursor/plugins/local/$kit
#        agent        home            always-on file             skills folder
agents=("Codex|$HOME/.codex|$HOME/.codex/AGENTS.md|$HOME/.agents/skills"
        "Claude Code|$HOME/.claude|$HOME/.claude/CLAUDE.md|$HOME/.claude/skills"
        "Gemini CLI|$HOME/.gemini|$HOME/.gemini/GEMINI.md|$HOME/.agents/skills")
#            companion  source                                                 pinned commit
companions=("ponytail|https://github.com/DietrichGebert/ponytail.git|96608e078b2d5ea607c5c3b8b5a54d1c1fba6846"
            "egm|https://github.com/google/elephant-goldfish-model.git|72d06f52a2482885d9a64bd24b291c6e8628942c")
ponytail_skills=(ponytail-review ponytail-audit ponytail-debt)
egm_cursor=$HOME/.cursor/plugins/local/egm

drop_rule() {  # drop_rule FILE: delete the rule block, and the file if nothing else is left
  [ -f "$1" ] || return 0
  # cat > writes through a symlinked file (dotfiles); sed -i would replace the link
  sed "/$start/,/$end/d" "$1" > "$1.tmp" && cat "$1.tmp" > "$1" && rm "$1.tmp"
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

fetch() {  # fetch NAME URL COMMIT: check out a companion at its pinned commit in .companions/NAME
  dir=$repo/.companions/$1
  [ -d "$dir/.git" ] || git clone -q "$2" "$dir" || return 1
  git -C "$dir" cat-file -e "$3^{commit}" 2>/dev/null || git -C "$dir" fetch -q || return 1
  git -C "$dir" -c advice.detachedHead=false checkout -q "$3"
}

link_skills() {  # link_skills DIR: link the kit's and ponytail's skills into DIR, or with --remove delete those links
  [ "$mode" = --remove ] || mkdir -p "$1"
  for skill in "${skills[@]}"; do
    target=$1/$(basename "$skill")
    if [ "$mode" = --remove ]; then
      if [ "$(readlink "$target")" = "$skill" ]; then rm "$target"; fi
    elif [ ! -d "$skill" ]; then
      continue
    elif [ -e "$target" ] && [ "$(readlink "$target")" != "$skill" ]; then
      echo "  skipped $target: it exists and isn't from this repo"
    else
      ln -sfn "$skill" "$target"
    fi
  done
}

egm_plugin() {  # egm_plugin CLI VERB: install EGM with that agent's own plugin command
  command -v "$1" >/dev/null || { echo "  EGM skipped: no $1 command"; return 0; }
  "$1" plugin marketplace add google/elephant-goldfish-model >/dev/null 2>&1 || true  # fails when already added
  "$1" plugin "$2" egm@egm >/dev/null || echo "  EGM not installed: run $1 plugin $2 egm@egm"
}

case $mode in
  "" | --remove) ;;
  *) echo "usage: $0 [--remove]" >&2; exit 1 ;;
esac

if [ "$mode" != --remove ]; then
  for entry in "${companions[@]}"; do
    IFS='|' read -r name url commit <<< "$entry"
    fetch "$name" "$url" "$commit" || echo "Companion $name unavailable (offline?); continuing without it"
  done
fi
skills=("$repo"/skills/*)
for skill in "${ponytail_skills[@]}"; do skills+=("$repo/.companions/ponytail/skills/$skill"); done

if [ -d "$HOME/.cursor" ]; then
  echo "Cursor: $plugin, $HOME/.agents/skills"
  rm -rf "$plugin"
  [ "$mode" = --remove ] || { mkdir -p "$plugin" && cp -R "$repo/.cursor-plugin" "$repo/rules" "$plugin/"; }
  link_skills "$HOME/.agents/skills"
  if [ -e "$egm_cursor" ] && [ ! -f "$egm_cursor/.$kit" ]; then
    echo "  EGM already in $egm_cursor; left as is"
  elif [ "$mode" = --remove ]; then
    rm -rf "$egm_cursor"
  elif [ -d "$repo/.companions/egm" ]; then
    rm -rf "$egm_cursor" && mkdir -p "$egm_cursor"
    (cd "$repo/.companions/egm" && cp -R .cursor-plugin skills agents resources docs LICENSE "$egm_cursor/" && git rev-parse HEAD > "$egm_cursor/.egm-source-sha")
    touch "$egm_cursor/.$kit"
  fi
fi
for entry in "${agents[@]}"; do
  IFS='|' read -r name home rule_file skills_dir <<< "$entry"
  [ -d "$home" ] || continue
  echo "$name: $rule_file, $skills_dir"
  if [ "$mode" = --remove ]; then drop_rule "$rule_file"; else put_rule "$rule_file"; fi
  link_skills "$skills_dir"
  if [ "$mode" != --remove ]; then
    case $name in
      Codex) egm_plugin codex add ;;
      "Claude Code") egm_plugin claude install ;;
      *) echo "  EGM skipped: no $name version" ;;
    esac
  fi
done

if [ "$mode" = --remove ]; then echo "Removed. Restart your agents."; else echo "Done. Restart your agents, and rerun this after every git pull."; fi
