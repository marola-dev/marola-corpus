# AGENTS.md

Instructions for any AI coding agent working in **marola-corpus**. This is the repo layer
(MIP-0070 §5.1): the workspace rules live in the umbrella's
[AGENTS.md](https://github.com/marola-dev/marola/blob/main/AGENTS.md); this file says what this
repo is and where it differs.

<!-- invariants:start -->
## Org invariants

Non-negotiable in every marola repo; a repo may make these stricter, never looser (MIP-0070 §5.1).

- **Cost and deployment safety**: never provision or deploy a paid cloud resource without explicit human confirmation first ([AGENTS.md](AGENTS.md#cost--deployment-safety-hard-rule)).
- **No secrets in code**: never hardcode a key/connection string/secret; `.env.example` holds placeholders only ([AGENTS.md](AGENTS.md#cost--deployment-safety-hard-rule)).
- **The agent-ready gate**: an agent may only begin implementation on an issue carrying `agent-ready` ([AGENTS.md](AGENTS.md#issue-tracking-hard-rule)).
- **The three commit trailers**: commits carry three trailers and nothing else — `Tested:`, `Cost:`, and `Co-Authored-By: Claude <noreply@anthropic.com>` ([AGENTS.md](AGENTS.md#attribution-and-cost-accounting-hard-rule)).
- **Phase discipline**: work one phase at a time; never start a later phase before the current one is done ([AGENTS.md](AGENTS.md#phase-discipline-hard-rule)).
<!-- invariants:end -->

## What this repo is

marola's retrieval corpus: the sourced Markdown notes that the app's `--ask` and the MCP tool
`ask_ocean_question` answer from, and nothing else.

- `knowledge/*.md`: one topic per file. Line 1 `# <title>`, line 2 `Source: <url>`, then prose in
  blank-line-separated paragraphs (the app's `Corpus` chunks on blank lines: `docs/1-design.md`).
  Each document has a row in `docs/4-reference.md` with its source and verification status.
- `knowledge/safety/`: safety topics. An answer grounded in one gets the app's emergency footer;
  never write that footer into the Markdown.
- `.claude/skills/corpus-doc/`: adding a document. Its index and ask steps run in a marola-app
  checkout, pointed at this one with `MAROLA_KNOWLEDGE_DIR` (below).
- `scripts/corpus-check.sh`: the format gate. `scripts/corpus-tarball.sh`: the release asset.

## What it consumes and produces

| Direction | Contract |
|---|---|
| corpus → app, ml | `marola-corpus-<tag>.tar.gz` on each `v*` tag's release (`release.yml`): `knowledge/` with sorted entries, owner 0:0 and the commit's mtime, so a tag always has the same bytes. A consumer pins the tag in its `corpus.version`; its `corpus-fetch` unpacks it into `.tmp/knowledge` |
| corpus → umbrella | `README.md` and `docs/`, aggregated into docs.marola.dev (`notify-umbrella.yml`) |

This repo never reads a consumer's tree, and no workflow here builds the app (MIP-0070 §5.4).

**Trying an unreleased document in the app.** In a marola-app checkout with this repo next to it
(the umbrella's submodule, or any clone): `MAROLA_KNOWLEDGE_DIR=<path-to-this-repo>/knowledge just
ask "<question>"`. The pin is for releases only.

**Cutting a release.** Merge to `main`, then tag it `vX.Y.Z` (a new or changed document is a minor
bump, a fix a patch) and push the tag; `release.yml` attaches the tarball. Then bump
`corpus.version` in each consumer in its own PR: the app's image ships the new `/app/knowledge`
from that PR on. Tagging and pushing are a human's act.

## Commands

```bash
nix develop               # the lint tools and the devkit's tools; links .devkit
just quality              # every gate CI runs
just corpus-check         # the format gate alone
just corpus-tarball v0.1.0  # .tmp/marola-corpus-v0.1.0.tar.gz, as release.yml builds it
```

The devkit's git hooks (`core.hooksPath .devkit/.githooks`, set by the dev shell) run
`just precommit` and `just prepush`.

## Docs

`README.md` is the landing: what the repo is, its status, adding a document, the repo map, its
contracts and links. There is no `docs/index.md`. `docs/` holds numbered pages (MIP-0074 §5.2):
`1-design` (the document format, chunking), `3-development` (trying a change, releasing, bumping
the consumers), `4-reference` (each document's source and verification status). The H1 is the nav
label.

- **Links**: relative within `docs/` and from the README into `docs/`, written to work on GitHub.
  A file outside `docs/` (`AGENTS.md`, a `knowledge/` file) is linked by its
  `https://github.com/marola-dev/marola-corpus/blob/main/…` URL; another repo or the umbrella by
  `https://docs.marola.dev/…`.
- **Recipes**: a doc names only this repo's and the devkit's recipes. Any other carries the
  checkout marker: "in a marola-<name> checkout" in the same sentence, or
  `# in a marola-<name> checkout` as a fence's first line.
- `just quality` runs `docs-lint` (MIP-0074 §7): it fails on a foreign recipe without the marker,
  a relative link that leaves the repo, and `docs/index.md`.

## Cost & deployment safety (hard rule)

As in the umbrella. Nothing here is paid; a release is public the moment it exists, so an agent
does not create tags or releases (`gh release` and `git tag` are denied in `.claude/settings.json`).

## Issue tracking (hard rule)

An agent starts work only on an issue carrying `agent-ready`, in this repo (MIP-0070 §5.7).

## Attribution and cost accounting (hard rule)

Commits carry `Tested:`, `Cost:` and `Co-Authored-By: Claude <noreply@anthropic.com>`, as in the
umbrella.

## Phase discipline (hard rule)

The phase list is the umbrella's `docs/PHASES.md`. Corpus work serves the current phase.

## Content rules

Every sentence traces to the source named on line 2, fetched and read, never paraphrased from
memory; what cannot be checked against it is deleted, not softened. One source per document; a
second source means a second document. Shell: `set -euo pipefail`, shellcheck-clean. Comments only
for why, a trap, or a pointer, as the umbrella's AGENTS.md spells out.
