# Engineering practices

## Simplicity

- Build what is required now, not what might be required later.
- No class, wrapper, interface or helper without a real benefit.
- Straightforward beats clever. Fewer lines is not the goal; a readable five lines beats a cryptic one.
- Early returns and guard clauses instead of nesting.
- Correct and simple first. Optimize only after profiling.

## Duplication

- Never duplicate business logic, configuration, constants or validation rules. One authoritative definition each.
- Remove duplicated knowledge, not every repeated line. Code that looks alike but encodes different rules stays separate.
- Unsure whether two look-alikes encode one rule: wait for a third before extracting.
- Don't recompute a value you already have.

## Names and variables

- No variable that only renames a value. Keep one when it names a meaningful step.
- Descriptive names, longer for wider scope. No `temp`, `data1`, `val`; no type or context repeated in the name.
- Declare variables close to their use. Pass values explicitly instead of sharing mutable state.

## Functions and modules

- One function, one responsibility. Split when it separates logic, not to cut lines.
- No function that only forwards to another.
- Pure functions where possible. Side effects (files, network, mutation) easy to spot.
- Classes only for real state or lifecycle. Composition over inheritance.
- Small public interface. Low coupling, high cohesion, no circular imports.

## Layout

- Organize by responsibility or feature. No dumping-ground `utils` module.
- Not one file per tiny function, not everything in one file.
- Entry point orchestrates; logic lives elsewhere. Configuration separate from code.
- No empty folders made to match a template.

## Errors and logging

- Validate at system boundaries. Fail early with a specific exception and a clear message.
- Never swallow errors. Don't catch broad exceptions to hide bugs.
- Logging, not scattered prints, unless stdout is the product. No secrets in logs.

## Tests

When the repo has tests: deterministic, independent of order, testing behavior rather than internals.
Every bug fix gets a regression test.

## Reproducibility

- No hardcoded machine paths or credentials. Secrets come from the environment.
- Dependencies declared and locked. Few third-party packages, each one justified.
- A fresh machine can set up from the README alone.

## Git

- Small commits, one logical change each. The message says why.
- Review the diff before committing. No unrelated changes in one commit or pull request.
- Never commit credentials or private data. Keep `.gitignore` current.
- Don't break existing behavior or public interfaces without saying so.

## Python defaults

Use these unless the repo already has its own setup:

| Need | Tool |
| --- | --- |
| Project metadata and tool settings | `pyproject.toml` |
| Format and lint | Ruff |
| Run checks before commit | pre-commit |
| Lock dependencies | the repo's existing lock tool, else pip-compile |
| Types | hints on public functions; mypy or Pyright if the repo uses them |
| Tests | pytest, if the repo has tests |
