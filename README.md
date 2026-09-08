# Neovim

A hand-rolled Neovim configuration — no distro, no framework. Plain Lua modules on top of
[lazy.nvim](https://github.com/folke/lazy.nvim), plus a custom colour theme that keeps its own
flat, low-contrast chrome no matter which colourscheme you switch to.

Built around Rust, Go, TypeScript and Lua, with a second life as a Markdown/Obsidian notebook.

---

## Screenshots

### Splash screen

<img width="1920" height="1080" alt="untitled" src="https://github.com/user-attachments/assets/a28727f3-0f01-49cd-a06d-b18bdac28a96" />

### Editor view

<img width="1920" height="1080" alt="2" src="https://github.com/user-attachments/assets/f35aac91-f104-4e85-b8a6-badedffd90a1" />

---

## Requirements

| | |
|---|---|
| **Neovim** | 0.11 or newer — the LSP setup uses `vim.lsp.config()` / `vim.lsp.enable()`. Developed on 0.12. |
| **git**, **make** | lazy.nvim bootstrap; `make` builds `telescope-fzf-native` (skipped if absent) |
| **A Nerd Font** | icons in neo-tree, lualine, the dashboard and diagnostics |
| **Language toolchains** | `cargo` for Rust, `go` for Go/`gopls`/`slides`, `node` for the TypeScript server |
| **Optional** | [`silicon`](https://github.com/Aloxaf/silicon) for code screenshots, `go` for [`slides`](https://github.com/maaslalani/slides) |

Language servers, debug adapters and formatters are installed by Mason on first launch — nothing
to set up by hand.

## Install

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself into `stdpath("data")/lazy`, installs the plugins, and Mason pulls the
toolchain. `checker.enabled = true`, so lazy checks for plugin updates in the background;
`rocks.enabled = false`, because no plugin here needs a real luarock (every rockspec asks only for
`lua >= 5.1`, which Neovim's LuaJIT satisfies).

## Layout

```
init.lua                  options → lazy → theme → diagnostics → keymaps
lua/config/
  lazy.lua                leader keys, lazy.nvim bootstrap and setup
  options.lua             editor defaults, tab policy, markdown/Obsidian buffer tweaks
  diagnostics.lua         diagnostic signs and float behaviour
  keymaps.lua             global keymaps
lua/plugins/*.lua         one file per area, imported wholesale by lazy
lua/theme/
  colors.lua              the hand-authored palette
  palette.lua             rebuilds that palette from whichever colourscheme is active
  highlights.lua          ~350 highlight groups across every plugin used here
  lualine.lua             statusline theme derived from the palette
  init.lua                colourscheme registry, live picker, persistence
queries/markdown/         treesitter injection override
```

---

## Features

### Editor defaults

- **Real tabs, width 4**, reasserted per buffer on every `FileType` so no plugin's ftplugin can
  quietly turn them into spaces.
- **`.editorconfig` ignored** on purpose (`vim.g.editorconfig = false`) — project files don't get
  to override the tab policy.
- Relative *and* absolute line numbers, `cursorline`, mouse enabled, folds enabled, and the `~`
  end-of-buffer filler blanked out.
- The clipboard is explicit: `<leader>y` / `<leader>P` and friends talk to `"+`, and the unnamed
  register is left alone.

### Theme system

The centrepiece. A hand-authored palette designed for **low visual noise**: muted backgrounds,
clear highlighting on the syntax that matters, and deliberately flat, unsaturated chrome for
everything secondary — statusline, line numbers, sidebar, floating windows.

It is also visually compatible with [**guitar**](https://github.com/asinglebit/guitar), a git TUI
client by the same author.

**Switching themes.** `<leader>uc` opens a live picker: the colourscheme applies as you move
through the list, `<Esc>` puts back what you had, `<CR>` keeps it and writes it to
`stdpath("state")/theme.txt` so it survives restarts.

**31 variants across 11 colourschemes** are wired up alongside the custom one:

| Family | Variants |
|---|---|
| onedark | warmer *(the custom theme)* |
| Catppuccin | Mocha, Macchiato, Frappe, Latte |
| Tokyo Night | Night, Storm, Moon, Day |
| Rose Pine | Main, Moon, Dawn |
| Gruvbox | Dark, Light |
| Kanagawa | Wave, Dragon, Lotus |
| Nightfox | Night, Dusk, Nord, Tera, Carbon, Day, Dawn |
| Nord | — |
| Everforest | Dark, Light |
| Dracula | Dracula, Soft |
| Oxocarbon | Dark, Light |

Every colourscheme plugin is declared `lazy = true`, so none of them cost anything at startup —
lazy.nvim pulls one in on `ColorSchemePre`.

**The custom chrome is not abandoned when you switch.** `lua/theme/palette.lua` rebuilds the grey
ramp from whichever theme is active:

- Each of the eleven ramp steps keeps the **exact lightness offset** it has in the authored
  palette, and takes its **hue from that theme's own `Normal` background**.
- Chroma is held absolute and capped (`TINT_CEILING = 0.08`) — otherwise a cream background walks
  the far end of the ramp into mustard.
- The ramp direction **inverts on light backgrounds**, which is why light entries carry
  `background = "light"` in the registry and everything else falls back to `"dark"`.
- Accent roles are resolved by *reading the theme's own highlight groups* — `String`, `Function`,
  `Keyword`, `Type`, `Identifier`, `Number`, `Comment`, `Diagnostic*`, `GitSigns*` — with Neovim's
  stock diff colours filtered out, so a theme that never set them doesn't count as having chosen.

So the sidebar, telescope, which-key and lualine keep their flat shape while the syntax colours
come from the theme. The authored `onedark warmer` entry is exempt and uses `lua/theme/colors.lua`
verbatim.

A `ColorScheme` autocmd re-derives the palette, reapplies all highlights and rebuilds lualine, so
a switch is instant and complete.

### UI

- **alpha-nvim** dashboard — ASCII splash, vertically centred, with Find File / Recent Files /
  New File / Projects / Quit buttons.
- **lualine** with `globalstatus`, themed from the live palette. Section A is colour-coded per
  mode (normal, insert, visual, command, terminal, replace).
- **noice.nvim** + **nvim-notify** — the command line becomes a floating popup 10% down the
  screen and 80% wide, messages render `mini`, and the command-palette preset is on. `vim.notify`
  is routed through nvim-notify.
- **which-key** with the arrows, separators and group icons stripped out, centre-aligned and
  padded. Groups are declared for Debug, Buffers, Windows, Find, Lazy, Mason, Quit/Session,
  Obsidian and UI. `<leader>?` shows buffer-local keymaps only.
- **neominimap** (v3) — a code minimap, **off by default**, with the full toggle/enable/refresh
  matrix bound under `<leader>n` for global, window, tab and buffer scope, plus focus control.
- **nvim-colorizer** — highlights colours in place across all filetypes, including CSS
  `rgb()`/`hsl()` functions, colour names and Tailwind classes.
- **neoscroll** — cubic-eased smooth scrolling with the cursor hidden mid-flight. Half-page
  (`<C-u>`/`<C-d>`) runs in 100ms; full-page (`<C-b>`/`<C-f>`, `<PageUp>`/`<PageDown>`) in 450ms.
- **dressing.nvim** and **mini.icons** are declared as optional UI helpers for the plugins above.

### Files and navigation

**neo-tree** (`<leader>e`) — three sources behind a statusline source selector:

| Source | What it gives you |
|---|---|
| Files | 45-column tree, git status, diagnostics, follows the current file, takes over netrw |
| Buffers | Open buffers as a tree, `d` to delete |
| Git | Floating window with `ga` add, `A` add all, `gu` unstage, `gr` revert, `gc` commit, `gp` push, `gg` commit and push, `gU` undo last commit |

- `h` / `l` collapse and open, `z` closes everything, `P` opens a floating preview.
- `S` / `s` open in a horizontal / vertical split, `t` in a tab, `w` with the window picker.
- Full file management inline: `a` add, `A` add directory, `d` delete, `r` rename, `b` rename
  basename, `y` / `x` / `p` clipboard, `c` copy, `m` move.
- Dotfiles and gitignored files are hidden; `H` toggles them, `/` fuzzy-finds, `f` filters.
- `o` opens a sort menu (`on` name, `os` size, `ot` type, `om` modified, `oc` created,
  `og` git status, `od` diagnostics).
- Size, type, last-modified and created columns appear progressively as the window widens.

**Telescope** — `fzf-native` sorter with smart case, hidden files included in `find_files`,
`node_modules` and `.git/` ignored, devicon colouring off to match the flat chrome. `<C-j>`/`<C-k>`
move the selection, `<C-q>` sends to the quickfix list, `q` closes in normal mode.

**telescope-project** — scans `~/projects` (depth 3) and `~/.config` (depth 2), renders as a
dropdown, and selecting a project `cd`s into it and syncs the tree. Inside the picker:
`<leader>tf` find project files, `<leader>tb` browse, `<leader>ta` add a project, `<leader>td` add
the cwd.

**Buffers and windows** — `H` / `L` cycle buffers, `<C-h/j/k/l>` move between windows, and
`<leader>w…` covers splits, closing and directional moves.

### LSP, completion and formatting

Mason keeps the toolchain current: `rust_analyzer`, `ts_ls`, `gopls`, `lua_ls`, `biome` as
servers, and `stylua`, `rustfmt`, `biome` as tools (auto-updating, installed on start).

| Language | Server | Notable settings |
|---|---|---|
| Rust | **rustaceanvim** (rust-analyzer) | all cargo features, check on save, inlay hints |
| TypeScript / JavaScript | `ts_ls` | function-call completion, parameter/variable/return inlay hints, root from `tsconfig.json` / `package.json` / `.git` |
| Go | `gopls` | `gofumpt`, `staticcheck`, `unusedparams` and `shadow` analyses, root from `go.work` / `go.mod` / `.git` |
| Lua | `lua_ls` | LuaJIT runtime, `vim` global recognised, Neovim runtime on the library path, telemetry off |
| JS/TS/CSS/HTML | `biome` | LSP proxy; also applies `source.fixAll.biome` on **every save** |

All four non-Rust servers are declared with the modern `vim.lsp.config()` / `vim.lsp.enable()`
API. Each attaches the same core keys: `gd` definition, `gr` references, `K` hover,
`<leader>rn` rename, and `<leader>ca` code action (Go, Lua and Biome).

**nvim-cmp** drives completion from LSP, LuaSnip and buffer sources, and extends to the command
line: `:` gets file paths plus command completion (skipping `terminal` and `TermExec`, which are
slow to enumerate), while `/` and `?` complete buffer words. `<C-Space>` opens the menu, `<CR>`
confirms, `<C-e>` aborts, `<C-j>`/`<C-k>` move, `<C-b>`/`<C-f>` scroll the docs.

**conform.nvim** formats on demand with `<leader>cf` — stylua for Lua, rustfmt for Rust, biome for
JS/TS/JSX/TSX. Format-on-save is deliberately left commented out; Biome's `fixAll` code action is
the only thing that touches a buffer at write time.

**Diagnostics** are tuned for quiet: virtual text **off**, custom sign glyphs and underline on,
severity-sorted, never updated mid-insert, and rendered in a rounded float. `<leader>j` opens the
float for the diagnostic under the cursor.

### Debugging

**nvim-dap** with **nvim-dap-ui**, which opens itself when a session initialises and closes itself
when the session exits.

- **Rust** via `codelldb` from Mason — the launch target is resolved at run time from
  `cargo metadata`, so there are no hardcoded binary paths.
- **Go** via `dlv` from Mason, with "current file" and "current package" configurations.
- `<F5>` start/continue, `<F10>` step over, `<F11>` step into, `<F12>` step out,
  `<leader>b` (also `<leader>db`) toggle breakpoint, `<leader>du` toggle the UI.

### Treesitter

`master` branch, `:TSUpdate` on install, highlighting and indentation on, with parsers for
`rust`, `lua`, `toml`, `json`, `markdown`, `markdown_inline` and `yaml`.

`queries/markdown/injections.scm` overrides nvim-treesitter's own copy, whose
`#set-lang-from-info-string!` directive is broken on Neovim 0.12 — with the override, fenced code
blocks are highlighted by their info-string language again, and YAML/TOML frontmatter and inline
HTML get their proper parsers.

### Markdown and notes

**obsidian.nvim** on the `payperpaper` vault (`~/projects/personal/payperpaper/docs`), using
Telescope as its picker:

- **Frontmatter writing is off** — the vault is git-tracked with hand-written tags and aliases.
- **Note filenames are the title verbatim** (`Wages and Banking.md`), not a Zettel id, falling
  back to a Zettel id only for untitled notes.
- Daily notes live in `Daily/`, attachments in `assets/`, checkboxes cycle `" "` → `"x"`.
- Obsidian's own UI layer is disabled so it doesn't fight the renderer below.

**render-markdown.nvim** owns the rendering, on the `obsidian` preset — rendered in every mode,
like Obsidian's live preview. Headings and code blocks are block-width with padding, tables get
rounded borders, and HTML and LaTeX are off (the vault has neither, and `<u32>` / `<Vec3>` are
Rust generics in code spans, not tags). `<leader>or` toggles rendering per buffer. Heading
backgrounds and bullets are themed from the palette, replacing the far-too-loud `Diff*` defaults
that `RenderMarkdownH1..H6` link to by default.

**Markdown buffers** get their own treatment, all of it for a reason:

| Setting | Why |
|---|---|
| 2-space soft indents | tab-indented lists don't render in Obsidian |
| `wrap` off | a wrapped row breaks the table renderer's column lines — `<leader>ow` toggles it back, with `linebreak` and `breakindent` waiting for when you do |
| `sidescrolloff` 8 | neominimap sets it to 36 globally |
| `foldlevel` 99 | `markdown_folding` plus `foldenable` would otherwise open every note collapsed |
| `markdown_folding` | `<CR>` on a heading cycles its fold |

**Presenting.** `:Slides` (or `<leader>sl`) presents the current file with
[maaslalani/slides](https://github.com/maaslalani/slides) in a terminal tab. The binary is looked
up on `PATH`, then `$GOBIN`, then `$GOPATH/bin`, then `~/go/bin`, with a clear message if it isn't
installed — and you get a warning rather than stale slides if the buffer has unsaved changes.

### Code screenshots

**nvim-silicon**, from visual mode: `<leader>sc` copies a screenshot of the selection to the
clipboard, `<leader>sf` saves it to a file, `<leader>ss` shoots with the configured defaults.

---

## Keymap reference

Leader is `<Space>`; local leader is `\`.

### Finding things

| Key | Action |
|---|---|
| `<leader>ff` | Find files (hidden included) |
| `<leader>fg` | Live grep |
| `<leader>fb` · `<leader>bb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` · `<leader>r` | Recent files |
| `<leader>fp` · `<leader>p` | Projects |
| `<leader>e` | Toggle neo-tree |

### Buffers and windows

| Key | Action |
|---|---|
| `H` · `L` | Previous / next buffer |
| `<leader>bn` · `<leader>bp` | Next / previous buffer |
| `<leader>bd` | Delete buffer |
| `<C-h/j/k/l>` | Move between windows |
| `<leader>wh/wj/wk/wl` | Move between windows |
| `<leader>ws` · `<leader>wv` | Horizontal / vertical split |
| `<leader>wc` · `<leader>wo` | Close window / close others |

### Clipboard

| Key | Mode | Action |
|---|---|---|
| `<leader>y` | n, v | Yank to system clipboard |
| `<leader>yy` | n | Yank line |
| `<leader>Y` | n | Yank to end of line |
| `<leader>p` | v | Paste over selection |
| `<leader>P` | n, v | Paste before |

### Code

| Key | Action |
|---|---|
| `gd` · `gr` · `K` | Definition / references / hover *(on LSP attach)* |
| `<leader>rn` · `<leader>ca` | Rename / code action *(on LSP attach)* |
| `<leader>cf` | Format buffer (conform) |
| `<leader>j` | Diagnostic float under cursor |

### Debug

| Key | Action |
|---|---|
| `<F5>` | Start / continue |
| `<F10>` · `<F11>` · `<F12>` | Step over / into / out |
| `<leader>b` · `<leader>db` | Toggle breakpoint |
| `<leader>du` | Toggle DAP UI |

### Notes (markdown buffers)

| Key | Action |
|---|---|
| `<leader>oo` · `<leader>og` | Switch note / grep vault |
| `<leader>on` · `<leader>ot` | New note / tags |
| `<leader>ob` · `<leader>ol` · `<leader>oc` | Backlinks / links / table of contents |
| `<leader>od` · `<leader>oD` | Today's note / daily notes |
| `<leader>ox` · `<leader>oi` | Toggle checkbox / paste image |
| `<leader>or` · `<leader>ow` | Toggle rendering / toggle wrap |
| `<leader>oe` · `<leader>ok` *(visual)* | Extract to new note / link selection |

### Minimap

| Key | Scope |
|---|---|
| `<leader>nm` · `<leader>no` · `<leader>nc` · `<leader>nr` | Global toggle / enable / disable / refresh |
| `<leader>nw{t,o,c,r}` | Same four, current window |
| `<leader>nt{t,o,c,r}` | Same four, current tab |
| `<leader>nb{t,o,c,r}` | Same four, current buffer |
| `<leader>nf` · `<leader>nu` · `<leader>ns` | Focus / unfocus / toggle focus |

### Scrolling

| Key | Action |
|---|---|
| `<C-u>` · `<C-d>` | Half page, 100ms |
| `<C-b>` · `<C-f>` | Full page, 450ms |
| `<PageUp>` · `<PageDown>` | Full page, 450ms |

### Completion (insert mode)

| Key | Action |
|---|---|
| `<C-Space>` · `<CR>` · `<C-e>` | Open menu / confirm / abort |
| `<C-j>` · `<C-k>` | Next / previous item |
| `<C-b>` · `<C-f>` | Scroll docs |

### Meta

| Key | Action |
|---|---|
| `<leader>uc` | Theme picker |
| `<leader>?` | Buffer-local keymaps (which-key) |
| `<leader>li` · `<leader>ls` · `<leader>lu` | Lazy install / sync / update |
| `<leader>mm` · `<leader>ml` · `<leader>mu` | Mason UI / log / update |
| `<leader>qs` · `<leader>qq` | Save file / quit all |
| `<leader>sc` · `<leader>sf` · `<leader>ss` *(visual)* | Silicon: clipboard / file / shoot |
| `<leader>sl` | Present current file with slides |

### Collisions worth knowing

A few prefixes are declared in two places, and which-key's spec loads last:

- `<leader>p` is **Projects** in normal mode; the clipboard paste survives only in visual mode.
  Use `<leader>P` to paste in normal mode.
- `<leader>b` is a complete mapping (toggle breakpoint) *and* the Buffers group prefix, so
  `<leader>bb` and friends wait out `timeoutlen` first.
- `<leader>ff`, `<leader>fg` and `<leader>fp` are declared twice with equivalent commands.
- In the project picker, `<leader>td` is bound twice in the same table; **add cwd** wins, so
  *delete project* is effectively unbound.

---

## Notes

- Shared dependencies (`plenary.nvim`, `nvim-web-devicons`, `nui.nvim`) are pulled in by several
  plugins at once — lazy.nvim deduplicates them.
- The palette derivation lives entirely in `lua/theme/palette.lua`; if a new colourscheme looks
  wrong, that is the file to read. `lua/theme/highlights.lua` keeps a large block of commented-out
  groups on purpose — they are the escape hatch for taking a group back from the active theme.
