# Modern Neovim Configuration

A production-ready, well-architected Neovim configuration built with modern tooling and best practices. This setup provides a comprehensive IDE-like experience while maintaining the speed and flexibility that makes Neovim exceptional.

## Philosophy

This configuration prioritizes:
- **Developer Experience**: Thoughtful defaults, comprehensive LSP support, and powerful navigation
- **Maintainability**: Modular Lua-based architecture with clear separation of concerns
- **Performance**: Lazy loading, optimized startup, and efficient plugin management
- **Reliability**: Locked dependencies and automatic tool installation for reproducibility

## What You Get

### Language Support (25+ Languages)

Out-of-the-box LSP configurations for:
- **Web**: TypeScript/JavaScript, HTML, CSS, Tailwind CSS
- **Systems**: Rust, Go, Zig, Odin, C
- **Scripting**: Python, Bash, Lua, Elixir
- **DevOps**: Docker, Terraform, YAML, TOML
- **Data**: PostgreSQL, Prisma, JSON
- **Documentation**: Markdown, AsciiDoc

All language servers are automatically installed via Mason with zero manual setup required.

### Intelligent Code Formatting

Smart formatter chains with fallback support:
- **JavaScript/TypeScript**: Biome (fastest) → Prettier
- **Python**: isort + black
- **Go**: goimports + gofmt
- **Web**: Prettier for JSON/YAML/Markdown/CSS
- **Lua**: stylua

Format on-demand with `<leader>fb` or configure auto-format on save.

### Powerful Navigation

**Telescope**: Fuzzy finding for everything
- `<leader>sf` - Search files (includes hidden, excludes .git)
- `<leader>sg` - Live grep across project
- `<leader>sw` - Search word under cursor
- `<leader>sd` - Search diagnostics
- `<leader>/` - Fuzzy search in current buffer

**Harpoon**: Lightning-fast file jumping
- Mark files with `ha`, jump instantly with `<leader>1-4`
- Perfect for multi-file workflows

**Treesitter Text Objects**: Advanced code manipulation
- Jump between functions, methods, classes, conditionals
- Select/swap parameters, arguments, entire functions
- Incremental selection with `<C-space>`

### Complete LSP Integration

Full Language Server Protocol support with sensible keybindings:
- `gd` - Go to definition
- `gr` - Go to references  
- `gI` - Go to implementation
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `[d` / `]d` - Navigate diagnostics

**Breadcrumb Navigation**: See your code context in the status line with nvim-navic integration.

### Built-in Debugging (DAP)

Full debug adapter protocol support with UI:
- `<F5>` - Start/continue debugging
- `<F1>/<F2>/<F3>` - Step into/over/out
- `<leader>b` - Toggle breakpoint
- `<F7>` - Toggle DAP UI

Pre-configured for Go, extensible for other languages.

### Git Integration

Comprehensive Git workflow support:
- **Gitsigns**: Inline diff markers, hunk operations, blame
  - `[c` / `]c` - Previous/next hunk
  - `<leader>hs/hr/hp` - Stage/reset/preview hunk
  - `<leader>hb` - Blame line
- **LazyGit**: Full-featured Git UI (`<leader>lg`)
- **Git Blame**: Inline author annotations

### Modern UI

**Status Line (lualine)**: Custom bubble theme showing:
- Mode indicator with colors
- Git branch and file status
- Breadcrumb code navigation
- Plugin update notifications
- File type and progress

**Buffer Line**: Tab-like buffer display with LSP diagnostics
- `<S-l>` / `<S-h>` - Next/previous buffer
- Visual indicators for modified/unsaved files

**Theme**: Kanagawa wave - Beautiful Japanese-inspired color scheme with excellent contrast

**Smart Notifications**: Filtered system messages with snacks.nvim

### Productivity Features

**Completion (nvim-cmp)**:
- Intelligent suggestions from LSP, snippets, and path
- Tailwind CSS color previews
- LuaSnip integration for custom snippets
- Smart auto-pairs with Treesitter awareness

**File Management (oil.nvim)**:
- Edit your filesystem like a buffer
- `-` - Open in current directory
- `<leader>-` - Open at project root

**Diagnostics (trouble.nvim)**:
- Organized diagnostics list with filtering
- `<leader>xx` - Toggle diagnostics
- Jump between issues with context

**Smart Commenting (Comment.nvim)**:
- Context-aware commenting using Treesitter
- Works correctly in mixed-language files (JSX, Vue, etc.)

**TODO Highlighting (todo-comments)**:
- Highlights TODO, FIXME, NOTE, WARN, PERF, TEST
- Quick navigation to all project TODOs

**Python Virtual Environments**:
- Automatic detection and switching with venv-selector
- `<leader>v` - Select virtual environment

### AI Integration

**Claude Code**: Official Claude AI integration for AI-assisted development directly in Neovim with floating window support.

### Quality of Life

- **Auto-indentation detection** (vim-sleuth)
- **Split maximizer** (`<leader>mm`)
- **Dashboard** (alpha.nvim) with recent files
- **Keybinding hints** (which-key) - See available commands
- **Indent guides** (indent-blankline)
- **Highlight on yank** - Visual feedback when copying
- **JSON/YAML schema validation** (schemastore)
- **Scrollbar** with git change indicators

## Architecture

```
nvim/
├── init.lua                    # Minimal entry point
├── lazy-lock.json              # Locked plugin versions
└── lua/
    ├── config/                 # Core configuration
    │   ├── settings.lua        # Editor options
    │   ├── keymap.lua          # Keybindings
    │   ├── autocmd.lua         # Autocommands
    │   └── lazy.lua            # Plugin manager bootstrap
    ├── plugins/                # Plugin specifications (~27 plugins)
    │   ├── lspconfig.lua
    │   ├── telescope.lua
    │   ├── treesitter.lua
    │   └── [others...]
    ├── lsp/                    # LSP & tool configurations
    │   ├── mason.lua           # Language server definitions
    │   ├── conform.lua         # Formatter configurations
    │   └── treesitter.lua      # Treesitter languages
    ├── macros/                 # Custom helper functions
    └── utils/                  # Utility functions
```

**Philosophy**: Each plugin gets its own file in `plugins/`, tool configurations live in `lsp/`, and core settings are cleanly separated. This makes customization straightforward and debugging easy.

## Installation

### Prerequisites

- Neovim 0.9.0+ (0.10.0+ recommended)
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Node.js (for some LSP servers)
- ripgrep (for Telescope grep)
- fd (optional, for faster file finding)

### Quick Start

1. **Backup your existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone or symlink this configuration**:
   ```bash
   # If using these dotfiles
   ln -s ~/Projects/dotfiles/tools/shared/nvim/.config/nvim ~/.config/nvim
   
   # Or clone directly
   git clone <your-repo> ~/.config/nvim
   ```

3. **Launch Neovim**:
   ```bash
   nvim
   ```

4. **Wait for plugins to install**: Lazy.nvim will automatically install all plugins on first launch.

5. **Install language servers**: Open any file and Mason will automatically install the required LSP servers. Or manually trigger with `:Mason`.

6. **Restart Neovim**: Some plugins require a restart to fully initialize.

### Post-Installation

- **Check health**: Run `:checkhealth` to verify everything is working
- **Explore keybindings**: Press `<space>` and wait to see available commands (which-key)
- **Configure formatters**: Edit `lua/lsp/conform.lua` to customize formatting
- **Add language servers**: Edit `lua/lsp/mason.lua` to add more LSP servers

## Key Bindings Reference

**Leader key**: `<space>`

### Essential

| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlighting |
| `<leader>h/j/k/l` | Navigate windows |
| `<leader>sv/sh` | Split vertical/horizontal |
| `<leader>q` | Close buffer |
| `-` | Open file explorer (current dir) |
| `<leader>-` | Open file explorer (project root) |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>fb` | Format buffer |
| `[d` / `]d` | Previous/next diagnostic |

### Search (Telescope)

| Key | Action |
|-----|--------|
| `<leader>sf` | Search files |
| `<leader>sg` | Live grep |
| `<leader>sw` | Search word under cursor |
| `<leader>sd` | Search diagnostics |
| `<leader>/` | Fuzzy search buffer |
| `<leader><leader>` | Find buffers |

### Git

| Key | Action |
|-----|--------|
| `<leader>lg` | Open LazyGit |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `[c` / `]c` | Previous/next hunk |

### Debugging

| Key | Action |
|-----|--------|
| `<F5>` | Start/continue |
| `<F1>` | Step into |
| `<F2>` | Step over |
| `<F3>` | Step out |
| `<F7>` | Toggle DAP UI |
| `<leader>b` | Toggle breakpoint |

### Buffers & Navigation

| Key | Action |
|-----|--------|
| `<S-l>` / `<S-h>` | Next/previous buffer |
| `<leader>bo` | Close other buffers |
| `ha` | Add file to Harpoon |
| `ho` | Open Harpoon menu |
| `<leader>1-4` | Jump to Harpoon file |

## Customization

### Adding a Language Server

Edit `lua/lsp/mason.lua`:
```lua
return {
  "your-language-server",
  -- ... existing servers
}
```

### Adding a Formatter

Edit `lua/lsp/conform.lua`:
```lua
formatters_by_ft = {
  yourfiletype = { "your-formatter" },
}
```

### Adding a Plugin

Create `lua/plugins/yourplugin.lua`:
```lua
return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- your config
    })
  end,
}
```

### Changing Theme

Edit `lua/plugins/kanagawa.lua` or install a different colorscheme plugin.

### Modifying Keybindings

Edit `lua/config/keymap.lua` or add keybindings in individual plugin files.

## Troubleshooting

### LSP Not Working

1. Check if the language server is installed: `:Mason`
2. Check LSP status: `:LspInfo`
3. Restart LSP: `:LspRestart`
4. Check health: `:checkhealth lspconfig`

### Formatters Not Working

1. Check if formatter is installed: `:Mason`
2. Check conform status: `:ConformInfo`
3. Verify formatter config in `lua/lsp/conform.lua`

### Plugin Issues

1. Update plugins: `:Lazy sync`
2. Check plugin status: `:Lazy`
3. Check for errors: `:messages`
4. Clean and reinstall: `:Lazy clean` then `:Lazy sync`

### Performance Issues

1. Check startup time: `nvim --startuptime startup.log`
2. Profile plugins: `:Lazy profile`
3. Disable unused language servers in `lua/lsp/mason.lua`

## Notable Features

### Deprecation Management

This config actively manages Neovim 0.11+ deprecation warnings with appropriate suppressions and TODO markers for future updates. You won't see spam warnings while the ecosystem catches up.

### Automatic Tool Installation

Mason automatically installs all required language servers, formatters, and linters. No manual installation steps required - just open a file and the tools appear.

### Locked Dependencies

The `lazy-lock.json` ensures everyone gets the same plugin versions for reproducible setups. Update when ready with `:Lazy sync`.

### Context-Aware Breadcrumbs

The status line shows your current code context (function, class, method) using LSP information - rare in community configs.

### Smart Formatter Chains

Formatters try the fastest option first (Biome) with automatic fallback to alternatives (Prettier). You get speed when available, reliability always.

## Requirements

### Minimum

- Neovim 0.9.0+
- Git
- Basic terminal emulator

### Recommended

- Neovim 0.10.0+
- Nerd Font terminal (for icons)
- True color support (24-bit color)
- ripgrep (for faster searching)
- fd (for faster file finding)
- Node.js (for many LSP servers)
- LazyGit (for Git UI)

### Optional

- Go (for gopls, goimports)
- Python 3 (for Python LSP)
- Rust (for rust-analyzer)
- Language-specific tooling for your stack

## Contributing

Found an issue or have a suggestion? This is my personal config, but I'm happy to discuss improvements. Feel free to:
- Open an issue for bugs or questions
- Submit PRs for fixes (please explain the "why")
- Fork and customize for your needs

## License

This configuration is provided as-is for educational and personal use. Feel free to use, modify, and share.

## Acknowledgments

Built on the shoulders of giants:
- [Neovim](https://neovim.io/) - The editor
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin management
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP foundation
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finding
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax understanding
- And all the plugin authors who make this ecosystem amazing

---

**Note**: This configuration is actively maintained and updated. If you encounter issues, check that you're using a recent version of Neovim and have run `:Lazy sync` to update plugins.
