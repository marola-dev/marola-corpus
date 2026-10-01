#!/usr/bin/env bash
# corpus-check — every corpus document opens with `# <title>` then `Source: <http(s) url>`, the
# two lines marola's Corpus chunker turns into the citation (knowledge/README.md).
#
#   scripts/corpus-check.sh [dir]    # default: knowledge
#   scripts/corpus-check.sh --self-test
set -euo pipefail

check() {
  local dir="$1" f n=0 bad=0
  [ -d "$dir" ] || { echo "corpus-check: $dir is not a directory" >&2; return 1; }
  while IFS= read -r -d '' f; do
    # README.md describes the corpus; the chunker yields no source for it, by design.
    [ "${f#"$dir"/}" = README.md ] && continue
    n=$((n + 1))
    if ! sed -n 1p "$f" | grep -Eq '^# [^ ]'; then
      echo "corpus-check: $f: line 1 is not '# <title>'" >&2; bad=1
    fi
    if ! sed -n 2p "$f" | grep -Eq '^Source: https?://[^ ]+$'; then
      echo "corpus-check: $f: line 2 is not 'Source: <http(s) url>'" >&2; bad=1
    fi
  done < <(find "$dir" -name '*.md' -type f -print0 | LC_ALL=C sort -z)
  [ "$n" -gt 0 ] || { echo "corpus-check: no documents under $dir" >&2; return 1; }
  [ "$bad" -eq 0 ] && echo "corpus-check: $n document(s) under $dir ok"
}

self_test() {
  local t f=0
  t="$(mktemp -d)"
  trap 'rm -rf "$t"' RETURN
  mkdir -p "$t/k/safety"
  printf '# Rips\nSource: https://example.org/rips\n\nText.\n' >"$t/k/safety/rips.md"
  printf '# About\n\nNo source here.\n' >"$t/k/README.md"
  check "$t/k" >/dev/null 2>&1 || { echo "FAIL: a sourced doc plus README.md should pass"; f=1; }

  printf '# Foam\n\nSource: https://example.org/foam\n' >"$t/k/foam.md"
  check "$t/k" >/dev/null 2>&1 && { echo "FAIL: Source: not on line 2 should fail"; f=1; }
  printf '# Foam\nSource: example.org/foam\n' >"$t/k/foam.md"
  check "$t/k" >/dev/null 2>&1 && { echo "FAIL: a Source: that is not a URL should fail"; f=1; }
  printf 'Foam\nSource: https://example.org/foam\n' >"$t/k/foam.md"
  check "$t/k" >/dev/null 2>&1 && { echo "FAIL: a missing title should fail"; f=1; }
  rm "$t/k/foam.md" "$t/k/safety/rips.md"
  check "$t/k" >/dev/null 2>&1 && { echo "FAIL: a corpus of only README.md should fail"; f=1; }

  echo "corpus-check self-test:" "$([ "$f" -eq 0 ] && echo ok || echo FAILED)"
  [ "$f" -eq 0 ]
}

case "${1:-}" in
  --self-test) self_test ;;
  -*) echo "usage: $0 [dir] | --self-test" >&2; exit 2 ;;
  *) check "${1:-knowledge}" ;;
esac
