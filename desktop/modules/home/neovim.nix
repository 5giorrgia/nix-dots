{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      clang-tools
      nixd
      pyright
      rust-analyzer

      cargo
      rustc

      black
      nixfmt
      rustfmt
      stylua

      fd
      ripgrep
    ];

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      nvim-web-devicons

      alpha-nvim
      bufferline-nvim
      lualine-nvim
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      toggleterm-nvim

      telescope-nvim
      telescope-file-browser-nvim

      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      conform-nvim
    ];

    initLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.opt.number = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.termguicolors = true
      vim.opt.mouse = "a"
      vim.opt.fillchars = { eob = " " }

      local transparent_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "NvimTreeNormal",
        "NvimTreeNormalNC",
        "SignColumn",
        "LineNr",
        "CursorLine",
        "CursorLineNr",
        "EndOfBuffer",
        "MsgArea",
        "ToggleTerm",
        "ToggleTermNormal",
      }

      local function apply_highlights()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89b4fa", bold = true })
        vim.api.nvim_set_hl(0, "AlphaButtons", { bold = true })
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f38ba8", bold = true })
        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
        end
      end

      apply_highlights()

      local user_group = vim.api.nvim_create_augroup("user_config", { clear = true })

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = user_group,
        desc = "Reapply the custom highlights after a colorscheme change",
        callback = apply_highlights,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = user_group,
        desc = "Keep a 2 space indent in every filetype",
        callback = function(args)
          vim.bo[args.buf].tabstop = 2
          vim.bo[args.buf].shiftwidth = 2
          vim.bo[args.buf].softtabstop = 2
          vim.bo[args.buf].expandtab = true
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = user_group,
        desc = "Start treesitter when a parser is available",
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      local telescope = require("telescope")
      local skip_git = "--glob=!**/.git/*"

      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            skip_git,
          },
        },
        pickers = {
          find_files = { hidden = true, find_command = { "rg", "--files", skip_git } },
        },
      })
      pcall(telescope.load_extension, "file_browser")

      local function select_directory()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        require("telescope.builtin").find_files({
          prompt_title = "Select Directory",
          cwd = vim.fn.expand("~"),
          find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git", "--absolute-path" },
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              local dir = selection and selection[1]
              if dir then
                vim.cmd.cd(vim.fn.fnameescape(dir))
                require("nvim-tree.api").tree.open({ path = dir })
              end
            end)
            return true
          end,
        })
      end

      vim.api.nvim_create_user_command("SelectDirectory", select_directory, {
        desc = "Pick a directory, cd into it and open the file tree",
      })

      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      local function button(shortcut, text, command)
        local btn = dashboard.button(shortcut, text, command)
        btn.opts.hl = { { "AlphaButtons", 0, -1 } }
        btn.opts.hl_shortcut = "AlphaShortcut"
        return btn
      end

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.header.val = {
        [[    _        _   _             __     ___               ]],
        [[   / \   ___| |_| |__   ___ _ _\ \   / (_)_ __ ___  ]],
        [[  / _ \ / _ \ __| '_ \ / _ \ '__\ \ / /| | '_ ` _ \ ]],
        [[ / ___ \  __/ |_| | | |  __/ |    \ V / | | | | | | |]],
        [[/_/   \_\___|\__|_| |_|\___|_|     \_/  |_|_| |_| |_|]],                     
      }

      dashboard.section.buttons.val = {
        button("n", "  New file", ":enew<CR>"),
        button("f", "  Find file", ":Telescope find_files<CR>"),
        button("d", "󰈭  Find word", ":Telescope live_grep<CR>"),
        button("e", "  Enter a path", ":SelectDirectory<CR>"),
        button("q", "  Quit", ":qa<CR>"),
      }

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

      vim.lsp.config("nixd", {
        settings = {
          nixd = {
            nixpkgs = { expr = 'import (builtins.getFlake "/home/aether/nix-dots").inputs.nixpkgs { }' },
          },
        },
      })

      vim.lsp.enable({ "clangd", "nixd", "pyright", "rust_analyzer" })

      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          vim.keymap.set("n", "n", api.tree.change_root_to_node, opts("CD into folder"))
          vim.keymap.set("n", "b", api.tree.change_root_to_parent, opts("CD to parent folder"))
        end,
      })

      require("lualine").setup()

      require("bufferline").setup({
        options = { diagnostics = "nvim_lsp", show_close_icon = true, separator_style = "thin" },
      })

      require("toggleterm").setup({ size = 15, direction = "horizontal" })

      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          c = { "clang-format" },
          cpp = { "clang-format" },
          lua = { "stylua" },
          nix = { "nixfmt" },
          python = { "black" },
          rust = { "rustfmt" },
        },
      })

      local function replace_in_file()
        vim.ui.input({ prompt = "Search: " }, function(search)
          if not search or search == "" then
            return
          end
          vim.ui.input({ prompt = "Replace with: " }, function(replace)
            if not replace then
              return
            end
            local cmd = string.format("%%s/%s/%s/gc", vim.fn.escape(search, "/"), vim.fn.escape(replace, "/"))
            pcall(vim.cmd, cmd)
          end)
        end)
      end

      local function close_buffer()
        local buf = vim.api.nvim_get_current_buf()
        if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
          vim.cmd.bprevious()
        end
        vim.api.nvim_buf_delete(buf, { force = false })
      end

      local function delete_word_forward()
        local line = vim.api.nvim_get_current_line()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local rest = line:sub(col + 1)
        local removed = rest:match("^%s+") or rest:match("^[%w_]+%s*") or rest:match("^[^%w_%s]+%s*")

        if removed then
          vim.api.nvim_set_current_line(line:sub(1, col) .. rest:sub(#removed + 1))
        elseif row < vim.api.nvim_buf_line_count(0) then
          local next_line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
          vim.api.nvim_buf_set_lines(0, row - 1, row + 1, true, { line .. next_line:gsub("^%s+", "") })
        end
      end

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc })
      end

      map("n", "<leader>s", "<cmd>w<CR>", "Save")
      map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", "Toggle explorer")
      map("n", "<leader>f", "<cmd>Telescope find_files<CR>", "Find files")
      map("n", "<leader>d", "<cmd>Telescope live_grep<CR>", "Grep")
      map("n", "<leader>r", replace_in_file, "Replace in current file")
      map("n", "<leader>c", close_buffer, "Close buffer")
      map("n", "<leader><Tab>", "<cmd>BufferLineCycleNext<CR>", "Next buffer")
      map("n", "<leader><Left>", "<cmd>BufferLineCyclePrev<CR>", "Previous buffer")
      map("n", "<leader><Right>", "<cmd>BufferLineCycleNext<CR>", "Next buffer")
      map({ "n", "t" }, "<leader>j", "<cmd>ToggleTerm<CR>", "Terminal")
      map({ "n", "t" }, "<leader>w", "<cmd>wincmd w<CR>", "Cycle windows")
      map({ "n", "v" }, "<leader>F", function()
        conform.format({ async = true, lsp_format = "fallback" })
      end, "Format")
      map("t", "<Esc>", [[<C-\><C-n>]], "Exit terminal mode")

      map("i", "<C-BS>", "<C-w>", "Delete word before cursor")
      map("i", "<C-h>", "<C-w>", "Delete word before cursor")
      map("i", "<C-Del>", delete_word_forward, "Delete word after cursor")
    '';
  };
}
