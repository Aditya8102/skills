---
name: kanso
description: Kanso style for docs, comments and code review. Use when writing or restructuring a README or docs, writing comments or docstrings, reviewing a change for clarity and duplication, or when the user says "make it Kanso", "clean this up" or "simplify the docs".
---

# Kanso style

The six rules are in the always-on Kanso rule. This skill says how they look on the page.
For writing or reviewing code beyond style, read [practices.md](practices.md).

Called as `/kanso review <path>`, review it against [Review](#review). Called as `/kanso <path>`, rewrite it in this style.

## Writing

- Sentences under 25 words. Define a term once, then use only that term.
- Tables for facts, Mermaid for flows, images for examples.
- Every line answers a question a reader has. Cut the rest.
- Link to the one place a fact lives instead of repeating it.
- A unit on every number. A path or command in backticks.
- No filler: robust, seamless, leverage, comprehensive, utilize, streamline, delve, cutting-edge.

## README shape

Only sections that have content, in this order:

1. Title and one sentence: what it does and for whom.
2. Quick start: setup and the main command, on the first screen.
3. What it does: a table, one row per feature or check.
4. Usage and outputs: options, output format, an example.
5. Layout: a tree with one line per entry.
6. Contributing: the check command and a link to the style.

## Docs layout

- The README is the only entry point. Every other page is linked from it.
- Parallel parts get one page each, with the same headings in the same order.
- A concept shared by several pages gets its own page; the others link to it.

## Code comments

- Module: a one-line docstring with a link to its doc page.
- Function: a one-line `input -> output` docstring.
- Constant: `NAME = value  # meaning; source`.
- Comment only the why the code cannot show. No comment that restates the code.
- No commented-out code. A known shortcut gets a `shortcut: <limit>, <when to upgrade>` comment.

## Review

Report each finding as: Kanso rule or practice broken, `file:line`, the fix in one sentence.
Order by impact. Skip anything a formatter or linter already enforces.
