# nvim-prime

Configuração Neovim moderna baseada no setup do **ThePrimeagen**, otimizada para desenvolvimento com foco em produtividade e workflow minimalista.

## 🎯 Visão Geral

Setup inspirado no workflow do **ThePrimeagen**: produtividade máxima, distrações mínimas, terminal-first, Git-centric, tudo acessível via teclado sem mouse.

**Estatísticas:**
- 27+ plugins cuidadosamente selecionados
- ~1.233 linhas de configuração Lua
- Organização modular e fácil de manter
- Performance otimizada com lazy loading

## 📁 Estrutura do Projeto

```
nvim-prime/
├── init.lua                    # Entry point (carrega theprimeagen module)
├── lua/theprimeagen/
│   ├── init.lua               # Configuração principal + autocmds
│   ├── set.lua                # Opções do vim
│   ├── remap.lua              # Keybindings globais
│   ├── lazy_init.lua          # Bootstrap do lazy.nvim
│   └── lazy/                  # Plugins (27 arquivos)
│       ├── lsp.lua            # LSP + autocompletion (192 linhas)
│       ├── telescope.lua      # Fuzzy finder
│       ├── harpoon.lua        # Navegação rápida entre arquivos
│       ├── treesitter.lua     # Syntax highlighting
│       ├── fugitive.lua       # Git integration
│       ├── dap.lua            # Debug adapter protocol
│       └── ...                # 21+ outros plugins
```

## 📦 Pré-requisitos

### Requeridos

- [ripgrep](https://github.com/BurntSushi/ripgrep) - Busca rápida em arquivos
- [tmux](https://github.com/tmux/tmux) - Terminal multiplexer
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [Node.js](https://nodejs.org/) - Para LSPs JavaScript/TypeScript

### Opcionais (mas recomendados)

- [lazygit](https://github.com/jesseduffield/lazygit) - Interface TUI para Git
- [tmux-sessionizer](https://github.com/ThePrimeagen/tmux-sessionizer) - Navegação entre projetos

## Instalação do tmux-sessionizer

O tmux-sessionizer é uma ferramenta do ThePrimeagen que permite navegar rapidamente entre projetos usando tmux e fzf.

### 1. Instalar dependências

**macOS (Homebrew):**
```bash
brew install tmux fzf ripgrep
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt install tmux fzf ripgrep
```

**Linux (Arch):**
```bash
sudo pacman -S tmux fzf ripgrep
```

### 2. Criar diretório para binários locais

```bash
mkdir -p ~/.local/bin
```

### 3. Baixar e instalar o tmux-sessionizer

```bash
# Baixar o script do repositório oficial
curl -o ~/.local/bin/tmux-sessionizer https://raw.githubusercontent.com/ThePrimeagen/tmux-sessionizer/master/tmux-sessionizer

# Tornar executável
chmod +x ~/.local/bin/tmux-sessionizer
```

### 4. Adicionar ao PATH

**Para Zsh (~/.zshrc):**
```bash
echo '' >> ~/.zshrc
echo '# Add local bin to PATH' >> ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Para Bash (~/.bashrc):**
```bash
echo '' >> ~/.bashrc
echo '# Add local bin to PATH' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 5. Configurar o tmux-sessionizer

Crie o arquivo de configuração:

```bash
mkdir -p ~/.config/tmux-sessionizer
```

Crie o arquivo `~/.config/tmux-sessionizer/tmux-sessionizer.conf`:

```bash
# tmux-sessionizer configuration

# Search paths for projects
# Format: path:depth (depth is optional, defaults to 1)
TS_EXTRA_SEARCH_PATHS=(
    ~/projects:2
    ~/DEV:2
    ~/.config:1
)

# Maximum depth for directory search
TS_MAX_DEPTH=2

# Session commands (optional)
# These run in windows starting at index 69 to avoid conflicts
# Usage: tmux-sessionizer -s 0 (runs first command)
# TS_SESSION_COMMANDS=(
#     "htop"
#     "lazygit"
# )

# Logging (optional)
# TS_LOG=true
# TS_LOG_FILE=~/.local/share/tmux-sessionizer/tmux-sessionizer.logs
```

### 6. Verificar instalação

```bash
tmux-sessionizer --version
# Deve mostrar: tmux-sessionizer version 0.1.0
```

### 7. Como usar

**No terminal:**
```bash
# Busca interativa com fzf
tmux-sessionizer

# Ir direto para um projeto
tmux-sessionizer ~/meu-projeto
```

**No Neovim (keybinds configurados):**
- `<C-f>` - Abre tmux-sessionizer em nova janela
- `<M-h>` - Abre em split vertical
- `<M-H>` - Abre em nova janela tmux

### Recursos
- [Repositório oficial do tmux-sessionizer](https://github.com/ThePrimeagen/tmux-sessionizer)
- [Dotfiles do ThePrimeagen](https://github.com/ThePrimeagen/.dotfiles)

## ✨ Características Principais

### Configurações Essenciais

- **Números de linha**: Relativos + absolutos para navegação eficiente
- **Indentação**: 4 espaços (padrão), conversão automática de tabs
- **Sem swap files**: Histórico persistente via undodir (`~/.vim/undodir`)
- **Scrolloff**: 8 linhas de contexto sempre visíveis
- **Clipboard**: Integrado com sistema operacional
- **Color column**: Marcador em 80 caracteres
- **Cursorline**: Destaque da linha atual

### Plugins Organizados por Categoria

#### 🔧 Core Development

- **LSP** (Mason + lspconfig + nvim-cmp): Autocomplete, diagnósticos, code actions
  - LSPs configurados: `lua_ls`, `rust_analyzer`, `vtsls`, `tailwindcss`, `zls`
  - Snippet support via LuaSnip
  - Signature help integrado
- **Treesitter**: Syntax highlighting inteligente (otimizado para arquivos < 100KB)
- **Telescope**: Fuzzy finder universal para arquivos, grep, buffers, help tags
- **Harpoon 2**: Navegação ultra-rápida entre arquivos marcados

#### 🐙 Git Integration

- **Fugitive**: Comandos Git nativos dentro do Neovim
- **Gitsigns**: Indicadores visuais de mudanças no código
- **LazyGit**: Interface TUI completa para Git

#### 🚀 Produtividade

- **Conform**: Formatação automática de código
- **Trouble**: Navegação em diagnósticos e quickfix
- **Todo-comments**: Destaque e busca de TODO, FIXME, NOTE, etc.
- **Undotree**: Visualização e navegação no histórico de edições
- **Zen Mode**: Foco sem distrações (2 modos: 80 e 90 colunas)

#### 🛠️ Utilitários

- **DAP** (Debug Adapter Protocol): Debug integrado
- **Snacks**: Coleção de mini utilidades
- **Cloak**: Ocultar secrets/tokens em arquivos de configuração
- **Colorizer**: Preview inline de cores hex/rgb
- **Claude**: Integração com Claude AI
- **Cellular Automaton**: Easter egg divertido (`:leader ca`)

#### 🎨 Temas Disponíveis

- Rose Pine (moon/main/dawn)
- Gruvbox
- Tokyo Night
- Vesper
- Fluoromachine
- Brightburn

## ⚙️ Autocmds e Automações

Esta configuração inclui automações inteligentes para melhorar o workflow:

- **Highlight on yank**: Feedback visual ao copiar texto (40ms)
- **Auto-remove whitespace**: Remove espaços trailing ao salvar (apenas em arquivos modificáveis)
- **Indentação JS/TS**: 4 espaços automáticos para JavaScript/TypeScript/JSON
- **LSP keymaps**: Keybindings automáticos quando LSP attach
- **Treesitter performance**: Desativa automaticamente em arquivos > 100KB
- **Filetype detection**: Suporte para MDX e Templ

## 🎯 Keybindings

**Leader key:** `<space>`

### Geral
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<leader>ex` | Normal | Abre o explorador de arquivos (netrw) |
| `<leader>so` | Normal | Source o arquivo atual |
| `<leader>rr` | Normal | Recarrega a configuração |
| `Q` | Normal | Desabilitado (no-op) |

### Edição de Texto
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `J` | Visual | Move linha(s) para baixo |
| `K` | Visual | Move linha(s) para cima |
| `J` | Normal | Join linha mantendo cursor na posição |
| `<leader>p` | Visual | Cola sem sobrescrever registro |
| `<leader>y` | Normal/Visual | Copia para clipboard do sistema |
| `<leader>Y` | Normal | Copia linha inteira para clipboard do sistema |
| `<leader>d` | Normal/Visual | Deleta sem copiar para registro |
| `<C-c>` | Insert | Sai do modo insert (equivalente a Esc) |
| `=ap` | Normal | Formata parágrafo e volta cursor |

### Navegação
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<C-d>` | Normal | Desce meia página e centraliza |
| `<C-u>` | Normal | Sobe meia página e centraliza |
| `n` | Normal | Próximo resultado de busca (centralizado) |
| `N` | Normal | Resultado anterior de busca (centralizado) |
| `<tab>` | Normal | Próximo buffer |
| `<S-tab>` | Normal | Buffer anterior |

### Telescope (Busca de Arquivos)
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<leader><leader>` | Normal | Busca todos os arquivos |
| `<C-p>` | Normal | Busca arquivos git |
| `<leader>/` | Normal | Live grep (busca em arquivos) |
| `<leader>pws` | Normal | Grep da palavra sob o cursor |
| `<leader>pWs` | Normal | Grep da PALAVRA sob o cursor |
| `<leader>fh` | Normal | Busca help tags |
| `<leader>fb` | Normal | Busca buffers |
| `<leader>st` | Normal | Busca TODO comments |

### Harpoon (Navegação Rápida)
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<leader>a` | Normal | Adiciona arquivo ao harpoon |
| `<leader>A` | Normal | Adiciona arquivo ao início do harpoon |
| `<C-e>` | Normal | Toggle menu do harpoon |
| `<M-1>` | Normal | Vai para arquivo 1 do harpoon |
| `<M-2>` | Normal | Vai para arquivo 2 do harpoon |
| `<M-3>` | Normal | Vai para arquivo 3 do harpoon |
| `<M-4>` | Normal | Vai para arquivo 4 do harpoon |

### Git (Fugitive)
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<leader>gs` | Normal | Git status |
| `<leader>p` | Normal (Fugitive) | Git push |
| `<leader>P` | Normal (Fugitive) | Git pull --rebase |
| `<leader>t` | Normal (Fugitive) | Git push -u origin (set upstream) |
| `gu` | Normal | Diff get da esquerda (//2) |
| `gh` | Normal | Diff get da direita (//3) |
| `<leader>gg` | Normal | Abre LazyGit |

### LSP
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `gd` | Normal | Ir para definição |
| `K` | Normal | Hover (documentação) |
| `<leader>vws` | Normal | Workspace symbol |
| `<leader>vd` | Normal | Abrir diagnóstico float |
| `[d` | Normal | Próximo diagnóstico |
| `]d` | Normal | Diagnóstico anterior |
| `<leader>vca` | Normal | Code action |
| `<leader>vrr` | Normal | Referências |
| `<leader>vrn` | Normal | Renomear |
| `<C-h>` | Insert | Signature help |
| `<leader>zig` | Normal | Restart LSP |

### Autocompletion (nvim-cmp)
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<Tab>` | Insert | Próximo item |
| `<S-Tab>` | Insert | Item anterior |
| `<C-y>` | Insert | Confirmar seleção |
| `<Enter>` | Insert | Confirmar seleção |
| `<C-Space>` | Insert | Trigger completion |

### Undotree
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<leader>u` | Normal | Toggle undotree |

### Zen Mode
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<leader>zz` | Normal | Toggle zen mode (90 width, com números) |
| `<leader>zZ` | Normal | Toggle zen mode (80 width, sem números) |

### Trouble (Diagnósticos)
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<leader>tt` | Normal | Toggle trouble |
| `[t` | Normal | Próximo item (trouble ou todo) |
| `]t` | Normal | Item anterior (trouble ou todo) |

### Tmux Integration
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<C-f>` | Normal | Abre tmux sessionizer |
| `<M-h>` | Normal | Tmux sessionizer split vertical |
| `<M-H>` | Normal | Tmux sessionizer nova janela |

### Quickfix / Location List
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<C-k>` | Normal | Próximo item quickfix |
| `<C-j>` | Normal | Item anterior quickfix |
| `<leader>k` | Normal | Próximo item location list |
| `<leader>j` | Normal | Item anterior location list |

### Utilitários
| Keybinding | Mode | Descrição |
|------------|------|-----------|
| `<leader>s` | Normal | Substituir palavra sob o cursor |
| `<leader>ca` | Normal | Cellular automaton (make it rain) |
| `<leader>tf` | Normal | Plenary test file |
| `<leader>lt` | Normal | Plenary busted test file |

### Comandos de Conveniência
Aceita variações com maiúsculas de comandos comuns:
- `:W` → `:w`
- `:Q` → `:q`
- `:Wq` / `:WQ` → `:wq`
- `:Qa` → `:qa`

## 🌟 Diferenciais

O que torna este setup único:

1. **Minimalista mas Completo**: Sem bloat, apenas ferramentas essenciais cuidadosamente selecionadas
2. **Harpoon como Diferencial**: Sistema de marcação ultra-rápido substitui abas tradicionais
3. **Workflow Terminal-First**: Integração profunda com tmux via tmux-sessionizer
4. **Git-Centric**: Múltiplas ferramentas Git (Fugitive + Gitsigns + LazyGit) para diferentes workflows
5. **Performance Otimizada**: 
   - Lazy loading de plugins
   - Treesitter inteligente (desativa em arquivos grandes)
   - Preview do Telescope sem Treesitter para velocidade
6. **Tolerante a Erros**: Aceita comandos com maiúsculas (`:W`, `:Q`, etc.)
7. **Keybinds do Prime**: Atalhos otimizados para produtividade máxima (baseados em anos de experiência)

## 📚 Recursos e Links

### Recursos do ThePrimeagen

- [Vídeo completo do setup](https://www.youtube.com/watch?v=w7i4amO_zaE)
- [Repositório original do ThePrimeagen](https://github.com/ThePrimeagen/init.lua)
- [Dotfiles do ThePrimeagen](https://github.com/ThePrimeagen/.dotfiles)
- [Canal do YouTube](https://www.youtube.com/@ThePrimeagen)

### Documentação Útil

- [Neovim Docs](https://neovim.io/doc/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Mason.nvim](https://github.com/williamboman/mason.nvim) - LSP installer
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder

---

**Total**: ~1.233 linhas de configuração Lua bem organizadas e modularizadas.

Configuração mantida e personalizada por [@caiogouveia](https://github.com/caiogouveia) baseada no setup do [ThePrimeagen](https://github.com/ThePrimeagen).
