set shell := ["bash", "-euo", "pipefail", "-c"]
set allow-duplicate-recipes

# The devkit's shared recipes (uprd, pr, stack, issue-*, ...), from the tree `nix develop` links.
import? '.devkit/devkit.just'

default:
    @just --list

# Every knowledge/*.md opens with `# <title>` and `Source: <url>`.
corpus-check:
    scripts/corpus-check.sh

# What release.yml attaches to a tag: .tmp/marola-corpus-<tag>.tar.gz.
corpus-tarball tag:
    scripts/corpus-tarball.sh {{ tag }} .tmp

# Every gate CI runs.
quality:
    #!/usr/bin/env bash
    set -euo pipefail
    for tool in shellcheck actionlint agents-check; do command -v "$tool" >/dev/null || { echo "quality: $tool not installed — run inside 'nix develop'" >&2; exit 1; }; done
    shellcheck --severity=error scripts/*.sh
    actionlint
    scripts/corpus-check.sh
    scripts/corpus-check.sh --self-test
    scripts/corpus-tarball.sh --self-test
    agents-check

# The devkit hooks' contract: fast checks at commit, the full gate at push.
precommit:
    scripts/corpus-check.sh
    agents-check

prepush:
    just quality
