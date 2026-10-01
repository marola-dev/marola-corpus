#!/usr/bin/env bash
# corpus-tarball — knowledge/ as marola-corpus-<tag>.tar.gz, the release asset marola's
# scripts/corpus-fetch.sh downloads for the tag in its corpus.version (MIP-0070 §5.4).
#
# Byte-reproducible: sorted entries, owner 0:0, normalised modes, and every mtime set to the
# commit's time (SOURCE_DATE_EPOCH overrides), so re-running a tag's build gives the same sha256.
#
#   scripts/corpus-tarball.sh <tag> [out-dir]   # default out-dir: .tmp
#   scripts/corpus-tarball.sh --self-test
set -euo pipefail

build() {
  local tag="$1" out="${2:-.tmp}" epoch file
  [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "corpus-tarball: tag must be vX.Y.Z, got '$tag'" >&2; return 2; }
  [ -d knowledge ] || { echo "corpus-tarball: no knowledge/ in $PWD" >&2; return 1; }
  epoch="${SOURCE_DATE_EPOCH:-$(git log -1 --format=%ct)}"
  mkdir -p "$out"
  file="$out/marola-corpus-$tag.tar.gz"
  tar --sort=name --mtime="@$epoch" --owner=0 --group=0 --numeric-owner \
    --mode='u+rwX,go+rX,go-w' --format=gnu -cf - knowledge | gzip -9n >"$file"
  echo "$file $(sha256sum "$file" | cut -d' ' -f1)"
}

self_test() {
  local t f=0 a b
  t="$(mktemp -d)"
  trap 'rm -rf "$t"' RETURN
  mkdir -p "$t/repo/knowledge/safety"
  printf '# A\nSource: https://example.org/a\n' >"$t/repo/knowledge/a.md"
  printf '# R\nSource: https://example.org/r\n' >"$t/repo/knowledge/safety/r.md"
  (
    cd "$t/repo"
    export SOURCE_DATE_EPOCH=1700000000
    a="$(build v0.1.0 out | cut -d' ' -f2)"
    touch knowledge/a.md && chmod 600 knowledge/safety/r.md
    b="$(build v0.1.0 out | cut -d' ' -f2)"
    [ "$a" = "$b" ] || { echo "FAIL: a touch/chmod changed the tarball ($a vs $b)"; exit 1; }
  ) || f=1
  [ "$(tar -tzf "$t/repo/out/marola-corpus-v0.1.0.tar.gz" | LC_ALL=C sort | tr '\n' ' ')" = \
    "knowledge/ knowledge/a.md knowledge/safety/ knowledge/safety/r.md " ] ||
    { echo "FAIL: entries are not knowledge/..."; f=1; }
  (cd "$t/repo" && build latest out >/dev/null 2>&1) && { echo "FAIL: a non-vX.Y.Z tag should fail"; f=1; }

  echo "corpus-tarball self-test:" "$([ "$f" -eq 0 ] && echo ok || echo FAILED)"
  [ "$f" -eq 0 ]
}

case "${1:-}" in
  --self-test) self_test ;;
  ""|-*) echo "usage: $0 <tag> [out-dir] | --self-test" >&2; exit 2 ;;
  *) build "$@" ;;
esac
