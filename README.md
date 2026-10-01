# marola-corpus

The sourced ocean knowledge [marola](https://github.com/marola-dev/marola) answers from: rip
currents, jellyfish and the Portuguese man o' war, bathing-water quality, waves and tides, sea foam,
whales off Santa Catarina. When marola's `--ask` or its `ask_ocean_question` tool answers a sea
question, every cited fact comes from a file in [`knowledge/`](https://github.com/marola-dev/marola-corpus/tree/main/knowledge),
and the citation is that file's `Source:` line.

It is one of the marola repos under the [umbrella](https://github.com/marola-dev/marola)
(MIP-0070), and its history before the split is marola's, filtered to these files.

## Adding a document

One topic, one real source, fetched and read. The file is `knowledge/<kebab-topic>.md` (or
`knowledge/safety/` for a safety topic, whose answers get marola's emergency footer):

```markdown
# <Title>
Source: <the URL you read>

One paragraph per claim, blank lines between them. Only what the source supports.
```

`just corpus-check` (CI runs it too) fails a file without that title and `Source:` line. The
`corpus-doc` skill in `.claude/skills/` walks an agent through the same steps. To see the answer
the new file produces before any release, run marola against this checkout:
`MAROLA_KNOWLEDGE_DIR=<this-repo>/knowledge just ask "<question>"` from a marola checkout.

## Releases

A `v*` tag publishes `marola-corpus-<tag>.tar.gz` (the `knowledge/` directory, byte-reproducible)
on that tag's GitHub release, through `.github/workflows/release.yml`. `just corpus-tarball <tag>`
builds the same file locally.

## How marola consumes it

marola pins a release tag in its `corpus.version` file. Its `scripts/corpus-fetch.sh` downloads
that tag's tarball into `.tmp/knowledge`, which its tests, `just ask` and the image build read; the
image ships it as `/app/knowledge`. A new release reaches marola only through a PR that bumps
`corpus.version`, so each image says which corpus it answers from.

More in [docs/](docs/index.md) and [AGENTS.md](https://github.com/marola-dev/marola-corpus/blob/main/AGENTS.md).
