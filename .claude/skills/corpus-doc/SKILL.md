---
name: corpus-doc
description: Add a new document to marola's knowledge corpus (knowledge/*.md) — the ocean/sea-lore notes that --ask and the ask_ocean_question MCP tool answer from. Use whenever the user wants a new corpus entry, knowledge/*.md file, or sourced ocean/marine-safety/marine-life topic added — phrasings like "add a knowledge doc about X", "the corpus is missing Y", "write a corpus entry about Z", "I want a new knowledge file about W", or naming any specific marine topic marola doesn't yet cover (jellyfish, currents, tides, water quality, sea temperature, marine life) as something to document.
---

# Adding a `knowledge/` document

`knowledge/*.md` is marola's retrieval corpus
([MIP-0001](https://github.com/marola-dev/marola/blob/main/docs/MIPs/MIP-0001-water-quality-and-sea-lore.md),
`docs/1-design.md`): every fact `--ask`/`ask_ocean_question` can cite comes from here, and only
from here. A wrong or unsourced sentence in this directory becomes a confidently wrong answer, so
this skill is stricter than a normal doc edit.

## When this skill applies

A new *topic* worth adding to the corpus (a marine-safety subject, a local phenomenon, a
glossary-style reference), not a correction to an existing file (edit that file directly) and not
marketing/persona copy (the corpus is factual reference only).

## Steps

1. **Pick one real, checkable source**: a government/scientific agency page (NOAA, IMA/SC-style),
   a well-established reference (Wikipedia is acceptable per this repo's existing corpus, but
   prefer a primary source when one exists). Fetch it and read it before writing a word; never
   paraphrase from memory. This mirrors the `/marola-devkit:mip` skill's "verify every external claim" rule.
2. **Write the file** as `knowledge/<kebab-topic>.md`:
   - Line 1: `# <Title>`.
   - Line 2: `Source: <the exact URL you fetched>`.
   - Then prose in blank-line-separated paragraphs, each focused on one sub-claim: the app
     chunks on blank lines (`docs/1-design.md` has the rule). A safety topic goes in
     `knowledge/safety/` instead.
   - Say only what the source actually supports. Anything you can't directly verify against the
     fetched page, delete rather than soften: this corpus has no room for "probably true."
3. **Add its row to `docs/4-reference.md`**: the file, its `Source:` URL, and the verification
   status "not yet human-verified". Only a human who did the sentence-by-sentence check changes a
   status.
4. **Re-index and query it, in a marola-app checkout** (the recipes are the app's, not this
   repo's), pointed at this repo's `knowledge/`:

   ```bash
   # in a marola-app checkout
   MAROLA_KNOWLEDGE_DIR=<path-to-this-repo>/knowledge just knowledge-index
   MAROLA_KNOWLEDGE_DIR=<path-to-this-repo>/knowledge just ask "<a question the new doc should answer>"
   ```

   Confirm the answer cites your new file's source (the `[n]` citation should resolve to your
   `Source:` URL). This needs a local Ollama (`just ollama-up` in a marola-app checkout) and an
   app checkout; if either is missing, say so in the PR rather than claiming this step ran.
5. **Run `just quality`** here: `corpus-check` fails a file without the title and `Source:` lines.

## What this skill does not do

It does not write marine-safety claims from the model's own knowledge, generate a source, or
invent a URL: every sentence traces to something you actually fetched and read. If you can't find
a real source for a claim, the claim doesn't go in.
</content>
