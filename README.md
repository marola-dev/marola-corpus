<div align="center">

<img alt="Uma pequena onda que se enrola uma vez e se deita em três linhas de texto, como uma página: desenho original feito para o marola-corpus" src="docs/img/marola-corpus.svg" width="300"/>

# marola-corpus

<sub>o que o marola sabe sobre o mar · <a href="#o-que-tem-aqui">as notas</a> · <a href="#quem-usa">quem usa</a> · <a href="#marola-gpt">o marola-gpt</a> · <a href="#como-acrescentar-uma-nota">acrescentar uma nota</a> · <a href="#licença">licença</a></sub>

[![ci](https://img.shields.io/github/actions/workflow/status/marola-dev/marola-corpus/ci.yml?branch=main&label=ci&style=flat-square)](https://github.com/marola-dev/marola-corpus/actions/workflows/ci.yml)
[![release](https://img.shields.io/github/v/tag/marola-dev/marola-corpus?sort=semver&filter=v*&label=release&style=flat-square&color=1682D4)](#versões)
[![Hugging Face: h0ffmann/marola-gpt](https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-h0ffmann%2Fmarola--gpt-FFD21E?style=flat-square)](https://huggingface.co/h0ffmann/marola-gpt)
[![notas: MIT ou CC BY 4.0](https://img.shields.io/badge/notas-MIT%20%C2%B7%20CC%20BY%204.0-1682D4?style=flat-square)](#licença)
[![REUSE](https://img.shields.io/badge/REUSE-reuse%20lint-3FB950?style=flat-square)](REUSE.toml)

Um conjunto de notas curtas sobre o mar, cada uma tirada de uma fonte que dá para abrir e
conferir: correntes de retorno, águas-vivas, balneabilidade, ondas e marés, ressacas, baleias em
Santa Catarina. É daqui que o [marola](https://github.com/marola-dev/marola) tira o que responde
quando alguém pergunta sobre o mar, e é com este texto que ele treina o próprio modelo de
linguagem, o [marola-gpt](https://huggingface.co/h0ffmann/marola-gpt).
</div>

> [!WARNING]
> Toda nota foi escrita por um agente de IA a partir da fonte que ela cita, e nenhuma passou
> ainda pela conferência de uma pessoa, frase por frase. Essa conferência vem antes de o corpus
> responder a um bot público (Fase 1). O que não se confirmar na fonte é apagado, não suavizado.
> A situação de cada nota está em [`docs/4-reference.md`](docs/4-reference.md).

## O que tem aqui

Cada nota é um arquivo Markdown em [`knowledge/`](https://github.com/marola-dev/marola-corpus/tree/main/knowledge),
sobre um assunto só, com uma fonte só. A primeira linha é o título, a segunda é a fonte, e o resto
são parágrafos curtos, um fato por parágrafo:

```markdown
# Correntes de retorno no Rio de Janeiro
Source: https://doi.org/10.1590/S1982-45132010000100009

Um parágrafo por fato, com uma linha em branco entre eles. Só o que a fonte sustenta.
```

São 18 notas: 6 em inglês, de referências como NOAA, IMA/SC e Wikipédia, e 12 em português, de
artigos científicos brasileiros com licença aberta (Anuário do IGEO-UFRJ, Revista Brasileira de
Geografia Física, entre outros) e de atos oficiais do INPO. As notas de segurança ficam em
`knowledge/safety/`: quando uma resposta se apoia numa delas, o marola-app acrescenta um aviso de
emergência no fim. Esse aviso nunca é escrito na nota.

## Quem usa

<details>
<summary>Os dois repositórios que fixam uma versão do corpus</summary>

| Quem | Para quê | Onde fixa a versão |
|---|---|---|
| [marola-app](https://github.com/marola-dev/marola-app) | responder perguntas com `--ask` e com a ferramenta MCP `ask_ocean_question`, sempre citando a linha `Source:` da nota | `corpus.version` |
| [marola-ml](https://github.com/marola-dev/marola-ml) | treinar o marola-gpt | `corpus.version` |

Os dois baixam o mesmo arquivo, `marola-corpus-<tag>.tar.gz`, da release desta versão, e nunca
leem este repositório direto.

</details>

## marola-gpt

O marola-gpt é o modelo de linguagem pequeno do próprio marola. Ele é feito no
[marola-ml](https://github.com/marola-dev/marola-ml#marola-gpt) e publicado no Hugging Face, em
[huggingface.co/h0ffmann/marola-gpt](https://huggingface.co/h0ffmann/marola-gpt). A partir da 0.1.0,
ele é um adaptador LoRA treinado neste corpus, por cima do
[Tucano-2b4](https://huggingface.co/TucanoBR/Tucano-2b4), um modelo aberto treinado do zero em
português do Brasil.

O treino usa a versão do corpus fixada no `corpus.version` do marola-ml, hoje a v0.1.0. Essa
versão ainda não tem as 12 notas em português: elas chegam ao modelo quando sair a próxima release
deste repositório e o marola-ml passar a usá-la.

O marola-gpt é um projeto educacional. Ele continua o texto que recebe, sem compromisso com os
fatos, e **o que ele escreve nunca é conselho sobre o mar**. Quem quer uma resposta com fonte usa o
`--ask` do marola-app, que cita a nota de onde tirou cada frase.

## Como acrescentar uma nota

1. Escolha um assunto e uma fonte que você abriu e leu. A licença da fonte precisa deixar
   redistribuir e adaptar (CC BY 4.0, CC0, MIT ou um ato oficial). Fonte NC, ND, SA ou com todos os
   direitos reservados pode ser citada, mas nunca resumida aqui.
2. Crie `knowledge/<assunto-em-kebab>.md`, ou `knowledge/safety/` se for um tema de segurança, no
   formato acima. Uma nota em português diz, no primeiro parágrafo, os autores, a revista e a
   licença da fonte.
3. Se a fonte for CC BY 4.0, acrescente a nota ao [`REUSE.toml`](REUSE.toml) com os autores dela.
4. Acrescente uma linha à tabela de [`docs/4-reference.md`](docs/4-reference.md).
5. Rode `just quality` e `pipx run reuse==5.0.2 lint`. O CI roda os dois.

A skill `corpus-doc`, em `.claude/skills/`, leva um agente pelos mesmos passos. Para testar a nota
nova numa busca de verdade antes de qualquer release, rode isto num checkout do marola-app:

```bash
# in a marola-app checkout
MAROLA_KNOWLEDGE_DIR=<caminho-deste-repo>/knowledge just ask "<sua pergunta>"
```

## Mapa do repositório

| Caminho | O que é |
|---|---|
| `knowledge/*.md` | as notas |
| `knowledge/safety/` | as notas de segurança (com aviso de emergência) |
| `knowledge/README.md` | um lembrete do formato |
| `scripts/corpus-check.sh` | confere o título e a fonte de cada nota |
| `scripts/corpus-tarball.sh` | monta o arquivo da release, sempre com os mesmos bytes |
| `REUSE.toml`, `LICENSES/` | a licença e os autores de cada arquivo |
| `.claude/skills/corpus-doc/` | o passo a passo de uma nota nova, para agentes |

## Versões

Cada tag `vX.Y.Z` gera, pelo [`release.yml`](https://github.com/marola-dev/marola-corpus/blob/main/.github/workflows/release.yml),
o arquivo `marola-corpus-<tag>.tar.gz` com a pasta `knowledge/`. Uma nota nova ou alterada sobe a
versão do meio (minor), uma correção sobe a última (patch). Criar a tag é tarefa de uma pessoa.
Depois, cada consumidor atualiza o próprio `corpus.version` num PR seu. O passo a passo está em
[`docs/3-development.md`](docs/3-development.md).

## Documentação

- [`docs/1-design.md`](docs/1-design.md): o formato das notas e como o marola-app as divide em
  pedaços para a busca (em inglês).
- [`docs/3-development.md`](docs/3-development.md): testar uma mudança, fazer uma release, atualizar
  os consumidores (em inglês).
- [`docs/4-reference.md`](docs/4-reference.md): a fonte, a licença e a conferência de cada nota
  (em inglês).
- [AGENTS.md](https://github.com/marola-dev/marola-corpus/blob/main/AGENTS.md): as regras para
  agentes de IA que trabalham aqui.

<details>
<summary>Revisão pelo Gemini</summary>

Peça o revisor `marola-dev/gemini` num pull request (barra lateral → Reviewers, ou
`gh pr edit <N> --add-reviewer marola-dev/gemini`). O `marola-gemini-bot` publica uma revisão com
até 10 comentários marcados `[high]`, `[medium]` ou `[low]` e depois envia um commit só com as
correções de que tem certeza, depois que `bash scripts/corpus-check.sh` passa. Ele só roda quando
alguém pede, revisa PRs de fork sem enviar nada para eles e nunca mexe em `.github/`. Peça de novo
depois de commits novos. O `.github/workflows/gemini.yml` chama o workflow
[`gemini-review`](https://github.com/marola-dev/marola-devkit/blob/main/docs/4-reference_workflows.md#gemini-review)
do devkit.

</details>

## Licença

- **Notas que resumem um artigo CC BY 4.0**: [CC BY 4.0](LICENSES/CC-BY-4.0.txt), com os autores
  do artigo creditados.
- **Todo o resto** (as outras notas, os scripts, a documentação, o desenho): [MIT](LICENSE).

O [`REUSE.toml`](REUSE.toml) diz qual licença e quais autores valem para cada arquivo, então nenhum
arquivo leva cabeçalho. O CI roda `reuse lint`. O que não é nosso, e em quais termos:

| O quê | De quem | Termos |
|---|---|---|
| As 9 notas que resumem artigos científicos | os autores de cada artigo, um por um no `REUSE.toml` | CC BY 4.0, como os artigos |
| As 2 notas sobre o INPO | atos oficiais do MCTI e da Presidência | não protegidos (Lei 9.610/98, art. 8º, IV); a nota é MIT |
| A nota sobre a previsão de ondas do LabECO | a proposta do [ww3-gpu](https://github.com/h0ffmann/ww3-gpu), de Matheus Hoffmann | MIT |
| O formato deste README | [h0ffmann/picasso](https://github.com/h0ffmann/picasso), que o trouxe de [gvolpe/nix-config](https://github.com/gvolpe/nix-config) | só o formato foi aproveitado; nenhum texto foi copiado |

O desenho em [`docs/img/marola-corpus.svg`](docs/img/marola-corpus.svg) é original, feito para
este repositório, na mesma linha do desenho do marola-ml.

Este repositório é um dos repositórios do marola sob o
[guarda-chuva](https://github.com/marola-dev/marola) (MIP-0070). A história dele antes da divisão é
a do marola, filtrada para estes arquivos.
