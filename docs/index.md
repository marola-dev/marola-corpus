# marola-corpus

marola's retrieval corpus (MIP-0001, split out by MIP-0070): the sourced Markdown notes behind
`--ask` and `ask_ocean_question`.

## The contract

| Piece | Where |
|---|---|
| The documents | [`knowledge/`](https://github.com/marola-dev/marola-corpus/tree/main/knowledge): `# <title>`, `Source: <url>`, paragraphs |
| Safety topics | [`knowledge/safety/`](https://github.com/marola-dev/marola-corpus/tree/main/knowledge/safety): answers grounded here get marola's emergency footer |
| The format and source status | [`knowledge/README.md`](https://github.com/marola-dev/marola-corpus/blob/main/knowledge/README.md) |
| The release asset | `marola-corpus-<tag>.tar.gz` on each `v*` release, built by [`release.yml`](https://github.com/marola-dev/marola-corpus/blob/main/.github/workflows/release.yml) |
| The consumer's pin | `corpus.version` in marola, fetched into `.tmp/knowledge` by its `scripts/corpus-fetch.sh` |

## Checks

- `scripts/corpus-check.sh`: every document but `knowledge/README.md` opens with a title line and
  a `Source:` URL.
- `scripts/corpus-tarball.sh --self-test`: the tarball's bytes depend only on the files' content
  and the commit time, not on the checkout's mtimes, modes or owner.

## Bumping marola to a new release

Tag `main` as `vX.Y.Z` and push the tag. Once the release shows the tarball, change marola's
`corpus.version` to the tag in a PR; its image build then ships the new `/app/knowledge`.
