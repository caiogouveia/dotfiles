# nvim-prime

Esta é uma configuração do Neovim baseada na configuração popular de ThePrimeagen, projetada para uma experiência de desenvolvimento rápida e eficiente. Ela utiliza `lazy.nvim` para o gerenciamento de plugins.

## Instalação

1.  Faça o backup de sua configuração atual do Neovim.
2.  Clone este repositório para o seu diretório de configuração do Neovim (geralmente `~/.config/nvim`).
3.  Inicie o Neovim. Os plugins serão instalados automaticamente na primeira inicialização.

## Funcionalidades

### Gerenciamento de Plugins
-   **Gerenciador de Plugins**: Utiliza [lazy.nvim](https://github.com/folke/lazy.nvim) para carregamento rápido e gerenciamento de plugins.

### Edição de Código e UI
-   **Explorador de Arquivos**: (Não especificado, mas geralmente Telescope ou nvim-tree.lua são usados).
-   **Barra de Status**: `lualine.nvim` para uma barra de status informativa.
-   **Cores**: Vários temas, incluindo `tokyonight`, `onedarkpro`, e outros.
-   **Formatação**: `conform.lua` para formatação de código.
-   **Desfazer Histórico**: `undotree` para visualizar o histórico de alterações.

### Navegação e Busca
-   **Busca Fuzzy**: `telescope.nvim` para busca rápida de arquivos, texto e mais.
    -   `<leader><leader>`: Encontrar arquivos.
    -   `<leader>/`: Busca por texto (live grep).
    -   `<C-p>`: Buscar em arquivos do Git.
-   **Navegação Rápida**: `harpoon.lua` para marcar arquivos e alternar rapidamente entre eles.

### Desenvolvimento
-   **Suporte a LSP**: Configurado através de `lsp.lua`, integrando-se com `mason.nvim` para gerenciar servidores de linguagem.
-   **Git**: `fugitive.lua` e `gitsigns.lua` para uma integração robusta com o Git.
-   **Comentários**: `todo-comments.lua` para destacar comentários `TODO`, `FIXME`, etc.
-   **Snippets**: (Não especificado, mas `LuaSnip` é uma dependência comum).

### Suporte a Linguagens
-   **Syntax Highlighting**: `nvim-treesitter` para realce de sintaxe rápido e preciso.
-   **MDX**: Suporte específico para MDX com `mdx.lua`.
-   **JavaScript/TypeScript**: Configurações específicas em `javascript.lua`.

## Principais Plugins

-   [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim): Busca fuzzy, listas e seleções.
-   [lazy.nvim](https://github.com/folke/lazy.nvim): Gerenciador de plugins.
-   [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter): Realce de sintaxe avançado.
-   [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim): Barra de status.
-   [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim): Sinais do Git na gutter.
-   [harpoon.lua](https://github.com/ThePrimeagen/harpoon): Navegação rápida entre arquivos.
-   [conform.lua](https://github.com/stevearc/conform.nvim): Formatação de código.
-   e muitos outros...
