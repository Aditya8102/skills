#!/usr/bin/env bash
# Finish a kit install: fetch ponytail and add EGM if it is missing.
set -euo pipefail

EGM_SHA=72d06f52a2482885d9a64bd24b291c6e8628942c  # google/elephant-goldfish-model; the tested version
kit=$(cd "$(dirname "$0")" && pwd)
plugins=$HOME/.cursor/plugins/local

git -C "$kit" submodule update --init

if [ ! -d "$plugins/egm" ]; then
  src=$(mktemp -d)
  git clone -q https://github.com/google/elephant-goldfish-model "$src"
  git -C "$src" checkout -q "$EGM_SHA"
  mkdir -p "$plugins/egm"
  cp -R "$src"/{.cursor-plugin,skills,agents,resources,docs,LICENSE} "$plugins/egm/"
  echo "$EGM_SHA" > "$plugins/egm/.egm-source-sha"
  rm -rf "$src"
fi

[ "$kit" = "$plugins/kanso" ] || echo "Cursor loads this kit only from $plugins/kanso."
echo "Reload Cursor. Settings > Plugins should list kanso and egm."
