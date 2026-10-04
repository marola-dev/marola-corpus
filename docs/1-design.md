# Design

## The document format

One topic, one source, one file:

```markdown
# <Title>
Source: <the URL the text was checked against>

One paragraph per claim, blank lines between them. Only what the source supports.
```

- **Line 1** is the title and **line 2** the `Source:` URL: the app labels every retrieved passage
  with both, and an answer's citation is the source. `scripts/corpus-check.sh` fails a file
  without them.
- **One source per document.** A second source means a second document, so a citation always names
  the page the sentence came from.
- **`knowledge/safety/`** holds safety topics
  ([MIP-0022](https://github.com/marola-dev/marola/blob/main/docs/MIPs/MIP-0022-safety-answer-footer.md)).
  The app appends an emergency footer to any answer grounded in one; never write that footer into
  the Markdown.

## Chunking

marola-app's
[`Corpus`](https://github.com/marola-dev/marola-app/blob/main/core/src/main/scala/marola/knowledge/Corpus.scala)
turns a document into retrieval chunks:

1. It reads every `.md` file directly under `knowledge/` and directly under `knowledge/safety/`.
   Any other subdirectory is ignored.
2. It takes the first `# ` line as the title and the first `Source:` line as the source, and drops
   both from the body.
3. It splits the body on blank lines, then merges neighbouring paragraphs while the merged chunk
   stays within 700 characters. A paragraph longer than that stays one chunk; it is never cut.
4. Each chunk carries the title, the source, and whether the file is under `safety/`.

So a paragraph is the smallest unit retrieval can return: keep each one about one claim, readable
on its own.

`knowledge/README.md` is loaded too: it has a title and no `Source:` line, so its chunks carry an
empty source. Giving it a `Source:` line would make it citable.

Which model embeds the chunks is the app's setting:
[Choosing the embedder](https://docs.marola.dev/5-Repos/marola-app/4-reference_config/#choosing-the-embedder).
