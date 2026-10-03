# Development

## Trying a change before a release

Edit or add a `knowledge/*.md` file, then check it against real retrieval from a marola-app
checkout, pointed at this one:

```bash
# in a marola-app checkout
MAROLA_KNOWLEDGE_DIR=<path-to-this-repo>/knowledge just ask "<question>"
```

`just knowledge-index`, run the same way in a marola-app checkout, forces a re-embed without
asking a question. The pin is for releases only — this path never touches it.

## Releasing

Tag `main` as `vX.Y.Z` (a new or changed document is a minor bump, a fix a patch) and push the
tag; `.github/workflows/release.yml` builds `marola-corpus-<tag>.tar.gz` (the `knowledge/`
directory) and attaches it to that tag's GitHub release. `just corpus-tarball <tag>` builds the
same file locally without tagging. The tarball is byte-reproducible — its bytes depend only on the
files' content and the commit time, not the checkout's mtimes, modes or owner, so a tag always has
the same bytes (`scripts/corpus-tarball.sh --self-test` checks this).

Tagging and pushing are a human's act: a release is public the moment it exists.

## Bumping the consumers

marola-app and marola-ml each pin a release tag in their own `corpus.version` file. Once a tag's
release shows the tarball, bump `corpus.version` to that tag in each consumer, in its own PR;
marola-app's image then ships the new `/app/knowledge` from that PR on.
