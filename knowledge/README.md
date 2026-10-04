# marola-corpus knowledge

What marola-app's `--ask` and `ask_ocean_question` answer from. Each file:

- line 1 `# <Title>`, line 2 `Source: <url>`: the URL every answer cites;
- then prose in blank-line-separated paragraphs, one claim each;
- only what that source supports. One source per file.

Safety topics go in `safety/`; the app adds the emergency footer, never the file.

The chunking rule is in
[docs/1-design.md](https://github.com/marola-dev/marola-corpus/blob/main/docs/1-design.md); each
file's source and verification status in
[docs/4-reference.md](https://github.com/marola-dev/marola-corpus/blob/main/docs/4-reference.md).
