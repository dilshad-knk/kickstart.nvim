--------------------------------------------------------------------------------
-- Requires:
--   1. Neovim >= 0.8.0
--   2. nvim-lua/plenary.nvim
--   3. nvim-tree/nvim-web-devicons (optional)
--   4. MunifTanjim/nui.nvim
--------------------------------------------------------------------------------

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    -- Set global statusline before Neo-tree setup
    vim.opt.laststatus = 3 -- Global status line
    vim.opt.equalalways = false -- Prevent automatic window resize

    require('neo-tree').setup {
      close_if_last_window = true,
      popup_border_style = 'rounded',

      enable_diagnostics = true,
      enable_git_status = true,

      -- Prevent Neo-tree from creating its own statusline
      source_selector = {
        winbar = false,
        statusline = false,
      },

      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = 'open_default',
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
        },
      },

      window = {
        width = 0,
        position = 'left',
        auto_expand_width = true,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<CR>'] = 'open',
          ['o'] = 'open',
          ['s'] = 'open_split',
          ['v'] = 'open_vsplit',
          ['t'] = 'open_tabnew',
          ['w'] = 'open_with_window_picker',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
          ['l'] = 'focus_preview',
        },
      },

      -- Event handlers
      event_handlers = {
        -- Handle input popups
        {
          event = 'neo_tree_popup_input_ready',
          handler = function(args)
            vim.cmd 'stopinsert' -- Stop insert mode
            vim.keymap.set('i', '<esc>', vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
            vim.api.nvim_set_current_buf(args.bufnr) -- Ensure focus is set back to the popup
          end,
        },
        -- Ensure Neo-tree doesn't affect status bar
        {
          event = 'neo_tree_buffer_enter',
          handler = function()
            vim.opt_local.statusline = nil -- Use global statusline
            vim.opt_local.winbar = nil
          end,
        },
        -- Additional handler for window creation
        {
          event = 'neo_tree_window_after_open',
          handler = function()
            vim.opt_local.statusline = nil
            vim.opt_local.winbar = nil
          end,
        },
      },

      default_component_configs = {
        indent = {
          padding = 0,
          with_expanders = true,
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '',
        },
        modified = {
          symbol = '[+]',
        },
        git_status = {
          symbols = {
            added = '',
            deleted = '',
            modified = 'M',
            renamed = '➜',
            untracked = 'U',
            ignored = '◌',
            unstaged = '✗',
            staged = '✓',
            conflict = '',
          },
        },
      },
    }

    -- Additional autocmds to ensure status bar remains untouched
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'neo-tree *',
      callback = function()
        vim.opt_local.statusline = nil -- Use global statusline
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'neo-tree',
      callback = function()
        vim.opt_local.statusline = nil -- Use global statusline
      end,
    })

    -- Global keymaps
    vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true, desc = 'Toggle File Explorer' })
    vim.keymap.set('n', '<leader>o', ':Neotree show<CR>', { silent = true, desc = 'Open File Explorer' })
    vim.keymap.set('n', '<leader>c', ':Neotree close<CR>', { silent = true, desc = 'Close File Explorer' })
    vim.keymap.set('n', '<leader>f', ':Neotree focus<CR>', { silent = true, desc = 'Focus on File Explorer' })

    -- Ensure global statusline is always enabled
    vim.opt.laststatus = 3
  end,
}
