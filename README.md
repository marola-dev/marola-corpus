# marola-corpus

The sourced ocean knowledge [marola-app](https://github.com/marola-dev/marola-app)'s `--ask` and
`ask_ocean_question` tool answer from: rip currents, jellyfish and the Portuguese man o' war,
bathing-water quality, waves and tides, sea foam, whales off Santa Catarina. Every cited fact
comes from a file in [`knowledge/`](https://github.com/marola-dev/marola-corpus/tree/main/knowledge),
and the citation is that file's `Source:` line.

It is one of the marola repos under the [umbrella](https://github.com/marola-dev/marola)
(MIP-0070), and its history before the split is marola's, filtered to these files.

**Status:** every document was written by an AI coding agent against the URLs it names —
well-known references (NOAA, IMA/SC, Wikipedia) — but the sentence-by-sentence check against each
source is a human job, and it has **not** been done yet. Do that before this corpus backs a public
bot (Phase 1); anything that can't be verified gets deleted, not softened
([`docs/4-reference.md`](docs/4-reference.md) has the per-source detail).

## Adding a document

One topic, one real source, fetched and read. The file is `knowledge/<kebab-topic>.md` (or
`knowledge/safety/` for a safety topic, whose answers get marola-app's emergency footer):

```markdown
# <Title>
Source: <the URL you read>

One paragraph per claim, blank lines between them. Only what the source supports.
```

`just corpus-check` (CI runs it too) fails a file without that title and `Source:` line — every
document but `knowledge/README.md` itself, which has no source by design. The `corpus-doc` skill
in `.claude/skills/` walks an agent through the same steps; the format and chunking are in
[`docs/1-design.md`](docs/1-design.md). Trying the new file against real retrieval, and cutting a
release, are in [`docs/3-development.md`](docs/3-development.md).

## Repo map

| Path | What |
|---|---|
| `knowledge/*.md` | the documents |
| `knowledge/safety/` | safety topics (emergency footer) |
| `knowledge/README.md` | a format reminder |
| `scripts/corpus-check.sh` | the format gate |
| `scripts/corpus-tarball.sh` | the release asset, byte-reproducibly |
| `.claude/skills/corpus-doc/` | adding a document |

## Contracts

| | |
|---|---|
| Consumes | — (this repo is the source) |
| Publishes | `marola-corpus-<tag>.tar.gz` (`knowledge/`, byte-reproducible) on each `v*` tag's release, via [`release.yml`](https://github.com/marola-dev/marola-corpus/blob/main/.github/workflows/release.yml) |
| Pinned by | marola-app and marola-ml, each in its own `corpus.version` |

## Docs

- [`docs/1-design.md`](docs/1-design.md): the document format and how the app chunks it.
- [`docs/3-development.md`](docs/3-development.md): trying a change, releasing, bumping the consumers.
- [`docs/4-reference.md`](docs/4-reference.md): each document's source and verification status.
- [AGENTS.md](https://github.com/marola-dev/marola-corpus/blob/main/AGENTS.md): the rules for agents working here.
