# Pilha de Design para o Claude Code

Skill `/design` reconstruida em 2026-08-19 como uma pilha de 5 camadas, uma skill por
responsabilidade. Motivo: pesquisa mostrou que skills de design monoliticas (a versao
anterior tinha 610 linhas) pioram o resultado - o agente se perde em regras conflitantes.
O que funciona e verificacao (olhar o resultado renderizado e cobrar correcao), nao
prescricao (pilhas de regras antes de gerar).

## As 5 camadas

| Camada | Skill | Origem | O que faz |
|---|---|---|---|
| Fundacao | `frontend-design` | anthropics/skills (oficial, versao nova) | Direcao estetica, tipografia, elemento assinatura, autocritica contra o default generico |
| Micro | `make-interfaces-feel-better` | jakubkrehel (MIT) | Craft de microinteracao com valores exatos (press 0.96, radius concentrico, bounce 0) |
| Pagina | `skills/motion-choreography/` (deste repo) | autoral, fontes MIT creditadas | Motion cinematografico de pagina: scrolltelling, pin/scrub, parallax, view transitions. So landing/marca, nunca dashboard |
| Revisao | plugin `impeccable` | pbakaus/impeccable (Apache 2.0) | Detector deterministico de 59 padroes de slop + comandos /impeccable audit, polish, bolder, quieter, distill |
| Orquestracao | `skills/design-system/` (deste repo) | autoral | O `/design`: contrato de direcao em DESIGN.md -> gerar -> verificacao full-page em 3 larguras, secao a secao, 2 rodadas |

Regras de ferro da orquestracao: o brief vence; refino preserva, redesign substitui;
direcao unica e NOMEADA; verificar a tela inteira, nunca so elementos.

## O que vem neste repo

- `skills/design-system/` - a skill `/design` (orquestradora)
- `skills/motion-choreography/` - a camada de motion de pagina (com esqueletos GSAP/CSS de armadilhas pre-corrigidas)
- `design-systems/` - biblioteca de 60 design systems reais (Stripe, Linear, Apple...) usada como referencia de direcao
- `INSTALAR.sh` - instala tudo (as 2 skills locais + baixa as 2 externas + orienta o plugin)

## Instalar (Linux / Mac / WSL)

```bash
git clone https://github.com/arsprengel/design-skill-claude-code.git
cd design-skill-claude-code && ./INSTALAR.sh
```

O plugin impeccable e instalado via Claude Code (o script tenta; se falhar, rode dentro
do Claude Code):

```
claude plugin marketplace add pbakaus/impeccable
claude plugin install impeccable@impeccable
```

## Usar

- `/design` ou pedir natural ("cria a landing X", "redesenha a tela Y"). A skill mostra
  o contrato de direcao em ~5 linhas antes de codar; voce aprova com "vai".
- Quer cinema? Diga no brief ("com scrolltelling") - a camada de motion entra sozinha.
- Refinar: "ta sem graca" / "ta poluido" em linguagem natural, ou `/impeccable bolder`,
  `quieter`, `distill`, `polish`, `audit` direto.
- Cole 1-3 URLs de referencia sempre que puder - e o que mais eleva o resultado.

## Manutencao (setup da maquina principal)

Na maquina principal, `~/.claude/skills/design-system` e `~/.claude/skills/motion-choreography`
sao symlinks para as pastas deste clone em `~/dev/design-skill-claude-code`. Editar aqui
vale na hora; `git commit + push` versiona. Nao mover/apagar este clone sem refazer os links.

## Creditos

- Esqueletos GSAP adaptados de Leonxlnx/taste-skill (MIT); valores e regras de contencao
  de emilkowalski/skills (MIT, (c) 2026 Emil Kowalski) e jakubkrehel/make-interfaces-feel-better (MIT).
- Camada de revisao: pbakaus/impeccable (Apache 2.0). Fundacao: anthropics/skills.
