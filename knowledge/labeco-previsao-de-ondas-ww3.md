# Como funciona um modelo de previsão de ondas, e o uso do WAVEWATCH III pelo LabECO/UFSC na ReNOMO
Source: https://github.com/h0ffmann/ww3-gpu/tree/main/pubs/proposal

Esta nota resume a proposta de projeto de graduação "Otimização operacional do modelo de ondas WAVEWATCH III para GPU", de Matheus Hoffmann Fernandes Santos (Escola Politécnica da UFRJ, Departamento de Engenharia Eletrônica e de Computação, outubro de 2026), coorientada no LabECO/UFSC. O texto está no repositório público h0ffmann/ww3-gpu, sob a licença MIT.

O WAVEWATCH III (WW3) é um modelo numérico de previsão de ondas oceânicas desenvolvido pelos Centros Nacionais de Previsão Ambiental (NCEP) da NOAA, a agência oceânica e atmosférica dos Estados Unidos, e distribuído em código aberto.

O modelo representa o oceano por uma grade de pontos e descreve o estado do mar em cada ponto pelo espectro de ondas, que é a distribuição da energia das ondas entre frequências e direções. A cada passo de tempo, essa energia é propagada pela grade e modificada pelos termos de fonte: a energia que o vento transfere às ondas, a troca de energia entre as próprias ondas e a perda por quebra.

O WW3 é um modelo de terceira geração: resolve a equação de balanço da ação das ondas (a energia dividida pela frequência) sem impor de antemão a forma do espectro. O código é escrito em Fortran e roda em paralelo com MPI e OpenMP.

Os modelos de ondas são forçados pelo vento que os modelos atmosféricos preveem. Como esses modelos são governados por equações não lineares, a previsão do vento, e com ela a das ondas, perde qualidade à medida que o horizonte de previsão aumenta. Por isso os sistemas operacionais atualizam a previsão várias vezes por dia.

Um exemplo de escala: o NCEP roda o GFS-Wave, seu sistema global de previsão de ondas, quatro vezes ao dia (00, 06, 12 e 18 UTC), em grades globais de 0,16° e 0,25° com grades regionais mais finas aninhadas. Roda também o GEFS-Wave, a versão por conjunto, com 30 membros a 0,25°. Os dois preveem até 384 horas à frente.

No Brasil, o Laboratório de Engenharia e Ciências Oceânicas (LabECO), do Departamento de Engenharia Mecânica da Universidade Federal de Santa Catarina (UFSC), usa o WW3 em seu sistema de previsão operacional, como parte da Rede Nacional de Observação e Monitoramento Oceânico (ReNOMO).

A ReNOMO, financiada pela chamada CNPq/MCTI/Finep 062/2022, integra observação, controle de qualidade e produtos operacionais para o Atlântico Sul e a costa brasileira. Para o campo de ondas que alimenta esses produtos, reduzir o tempo de cada ciclo de previsão permite entregar a previsão mais cedo, usar uma grade mais fina no mesmo prazo ou rodar membros de conjunto para medir a incerteza.

A proposta parte do caso operacional do LabECO e pergunta quanto do tempo de execução de um ciclo de previsão pode ser reduzido sem que os campos previstos, como a altura significativa de onda, o período de pico e a direção de pico, mudem mais do que as tolerâncias definidas pelo grupo de pesquisa do laboratório.
