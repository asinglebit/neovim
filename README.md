
## Screenshots

This section shows the different views of your Neovim setup using **Alpha Dashboard** and related plugins.

### Regular Splash Screen

When you open Neovim in a normal folder (no Git repository), the dashboard shows a simple, clean splash screen with:

<img width="1920" height="1080" alt="untitled" src="https://github.com/user-attachments/assets/a28727f3-0f01-49cd-a06d-b18bdac28a96" />

### Git project splash screen

If opened within git repo folders, the splash screens greets with the contribution heatmap an most recent commits:

<img width="1920" height="1080" alt="3" src="https://github.com/user-attachments/assets/8dae5c8f-9d26-4c9e-b38b-c2eb22c1b9eb" />

### Editor view

<img width="1920" height="1080" alt="2" src="https://github.com/user-attachments/assets/f35aac91-f104-4e85-b8a6-badedffd90a1" />

# Neovim Configuration - Plugin Documentation

This document explains the purpose of each plugin used in this Neovim configuration. It serves as a reference for understanding how the setup works and what each dependency provides.

---

## 1. Completion & Snippets

- **`hrsh7th/nvim-cmp`**  
  A modular, fast, and flexible completion engine for Neovim. Handles all auto-completion sources.

- **`hrsh7th/cmp-nvim-lsp`**  
  Adds **LSP-based completion** support to `nvim-cmp`, allowing language servers to provide suggestions.

- **`hrsh7th/cmp-buffer`**  
  Provides **buffer-based completion**, suggesting words already present in the current buffer.

- **`hrsh7th/cmp-path`**  
  Enables **file path completion** within `nvim-cmp`.

- **`hrsh7th/cmp-cmdline`**  
  Adds completion support for **command-line mode** in Neovim.

- **`saadparwaiz1/cmp_luasnip`**  
  Integrates **LuaSnip snippet support** into `nvim-cmp`.

- **`L3MON4D3/LuaSnip`**  
  A **snippet engine** for Neovim, allowing you to expand and manage code snippets easily.

---

## 2. UI / Dashboard

- **`goolord/alpha-nvim`**  
  Highly customizable **startup dashboard** for Neovim.

- **`nvim-tree/nvim-web-devicons`**  
  Provides **file-type icons** for plugins like `nvim-tree`, `lualine`, and Telescope.

- **`nvim-lualine/lualine.nvim`**  
  A fast and configurable **status line** for Neovim.

- **`stevearc/dressing.nvim`**  
  Improves Neovim’s **builtin UI** for prompts, selects, and input dialogs.

- **`echasnovski/mini.icons`**  
  Adds icons to mappings, menus, and UI elements to enhance visibility.

- **`folke/which-key.nvim`**  
  Displays available **keybindings in a popup**, making it easier to discover commands.

---

## 3. Project Navigation & Productivity

- **`ThePrimeagen/harpoon`**  
  Quick navigation for frequently used files and buffers.

- **`nvim-telescope/telescope.nvim`**  
  Highly extensible **fuzzy finder** for files, buffers, tags, LSP symbols, and more.

- **`nvim-telescope/telescope-fzf-native.nvim`**  
  Improves Telescope performance using a **native FZF sorter**.

- **`nvim-telescope/telescope-project.nvim`**  
  Adds **project management** features to Telescope, including switching, searching, and opening projects.

- **`Isrothy/neominimap.nvim`**  
  A **code minimap** for better code overview and navigation.

- **`nvim-neo-tree/neo-tree.nvim`**  
  Modern **file explorer** with icons, git integration, and project awareness.

- **`MunifTanjim/nui.nvim`**  
  UI component library used by other plugins like Neo-tree and Noice.

---

## 4. Language & LSP Support

- **`williamboman/mason.nvim`**  
  Installs and manages **LSP servers, DAP servers, linters, and formatters** easily.

- **`williamboman/mason-lspconfig.nvim`**  
  Bridges Mason with **nvim-lspconfig** for automatic LSP setup.

- **`mrcjkb/rustaceanvim`**  
  A curated Neovim setup specifically for **Rust development**, including LSP, treesitter, and DAP.

- **`nvim-treesitter/nvim-treesitter`**  
  Provides **syntax highlighting, code parsing, and structural analysis** using Tree-sitter.

---

## 5. Debugging

- **`mfussenegger/nvim-dap`**  
  The **Debug Adapter Protocol client** for Neovim.

- **`rcarriga/nvim-dap-ui`**  
  UI for `nvim-dap` with panels, watches, and layout integration.

- **`git@github.com:nvim-neotest/nvim-nio.git`**  
  Provides integration for **running and testing code** inside Neovim (test runner support).

---

## 6. Notifications & Messaging

- **`rcarriga/nvim-notify`**  
  A fancy **notification manager** for Neovim with animations.

- **`folke/noice.nvim`**  
  Enhances Neovim’s **message, cmdline, and popup handling** with UI improvements.

---

## 7. Utilities

- **`nvim-lua/plenary.nvim`**  
  A **Lua utility library** required by many plugins, including Telescope.

- **`nvim-tree/nvim-web-devicons`** *(listed again)*  
  File-type icons, used in various UI plugins.

---

## 8. Custom Color Theme

This Neovim configuration uses a **custom-designed color theme** optimized for **reducing visual noise** and improving focus during coding.  

### Key Features:

- **Muted Backgrounds:** Soft, low-contrast background colors reduce eye strain over long sessions.
- **Focused Syntax Highlighting:** Important syntax elements like keywords, functions, and variables are highlighted clearly, while less relevant elements are subtly muted.
- **Reduced Visual Clutter:** Minimal use of bright or saturated colors for secondary UI elements (statusline, line numbers, floating windows).
- **Consistent Icon Colors:** File icons, LSP symbols, and UI highlights follow a coherent color palette to aid quick recognition.
- ** guita╭ compatible** Designed to be visually compatible with my other project, the **guita╭** git tui client: https://github.com/asinglebit/guitar

### Notes:

- Many plugins have overlapping dependencies (e.g., `plenary.nvim`, `nvim-web-devicons`) which are shared among multiple tools.  
- Completion and LSP support is handled primarily by `nvim-cmp` + its sources.  
- Telescope + its extensions are the main navigation and project management framework.  
- Snippets are handled by LuaSnip and integrated into the completion engine.  

---
