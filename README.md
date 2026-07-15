# Skill de Design para o Claude Code

Este pacote instala uma skill de design no Claude Code. Depois de instalada,
voce digita `/design` dentro do Claude Code e ele vira um designer de UI/UX:
faz umas perguntas sobre o que voce quer, estuda sites reais de referencia,
gera um preview de tela, valida no navegador e ajuda a aplicar no seu projeto.

Nao precisa saber programar pra usar. Voce conversa em portugues e valida
olhando o resultado.

---

## Como baixar este pacote

Nesta pagina do GitHub, clique no botao verde **`Code`** (em cima, a direita
da lista de arquivos) e escolha **`Download ZIP`**. Salve e descompacte a pasta
no seu computador. Depois siga a secao "Como instalar" mais abaixo.

---

## O que vem dentro

- `skills/design-system/` - a skill principal (o `/design`)
- `skills/design-motion-principles/` - skill de apoio (auditoria de animacao)
- `design-systems/` - biblioteca com 60 design systems reais (Stripe, Linear,
  Apple, Vercel, etc.) + tabelas de cor, tipografia e padroes de industria.
  E daqui que a skill tira o "bom gosto". Sem essa pasta a skill roda pela metade.

Tudo junto tem cerca de 5 MB.

---

## Como instalar (escolha o seu caso)

### Linux, Mac ou Windows com WSL
Abra o terminal na pasta deste pacote e rode:

```bash
bash INSTALAR.sh
```

### Windows (sem WSL, PowerShell)
Clique com o botao direito em `INSTALAR.ps1` e escolha "Executar com o PowerShell".
Se o Windows reclamar de permissao, abra o PowerShell e rode:

```powershell
powershell -ExecutionPolicy Bypass -File INSTALAR.ps1
```

### Instalacao manual (se preferir copiar na mao)
Copie as pastas para dentro da pasta `.claude` do seu usuario:

- `skills/design-system`            -> `~/.claude/skills/design-system`
- `skills/design-motion-principles` -> `~/.claude/skills/design-motion-principles`
- `design-systems`                  -> `~/.claude/design-systems`

No Windows nativo, `~` e a sua pasta de usuario (ex.: `C:\Users\SeuNome\.claude`).

Depois de copiar, feche e abra o Claude Code de novo.

---

## Requisitos (o que precisa ter instalado antes)

1. **Claude Code** - o app/CLI da Anthropic. Sem ele nada roda.
2. **Node.js** (recomendado) - a skill usa um script que le cores/fontes de
   sites de referencia. Instale em https://nodejs.org (versao LTS).
3. **MCP do Playwright** (recomendado) - e o que deixa a skill abrir o navegador
   pra estudar sites e validar o preview. Sem ele, as fases de validacao pulam.
   No Claude Code:
   ```
   claude mcp add playwright npx '@playwright/mcp@latest'
   ```
   e depois `npx playwright install chromium`.
4. **MCP do shadcn** (opcional) - so pra puxar componentes prontos de estrutura.

Se faltar Playwright ou shadcn, a skill AINDA funciona - ela so avisa que
pulou a parte que dependia deles. O essencial (perguntas, direcao, geracao do
preview) roda so com o Claude Code + a biblioteca `design-systems`.

---

## O que NAO vem incluso (de proposito)

- **Chave de API de geracao de imagem** (`GEMINI_DESIGN_API_KEY`). Essa chave e
  pessoal e paga - nao mandei a minha junto. A skill so precisa dela se voce
  pedir pra gerar imagem paga (Imagen / Nano Banana). O nivel gratis
  (Pollinations) funciona sem chave nenhuma. Se um dia quiser o nivel pago,
  pega uma chave em https://aistudio.google.com e configura:
  ```bash
  export GEMINI_DESIGN_API_KEY="sua-chave-aqui"
  ```

---

## Como usar (depois de instalado)

1. Abra o Claude Code numa pasta de projeto (ou numa pasta vazia pra so testar).
2. Digite: `/design`
3. Responda as perguntas (tipo de produto, vibe, cor, referencias que voce curte).
4. Ele te mostra uma direcao + moodboard pra aprovar, gera o preview, valida no
   navegador e te entrega os arquivos pra abrir.
5. Se gostou, pode pedir pra "aplicar no projeto".

Dica: se voce ja tem um site que curte, cola a URL quando ele perguntar por
referencias - o resultado fica muito melhor.

---

## Problemas comuns

- **"/design nao aparece"**: confira que a pasta `design-system` ficou em
  `~/.claude/skills/` e reabra o Claude Code.
- **"pulou a validacao / nao abriu o navegador"**: falta o MCP do Playwright
  (ver Requisitos, item 3).
- **"nao achou os design systems"**: a pasta `design-systems` precisa estar em
  `~/.claude/design-systems` (nao dentro de `skills`).
