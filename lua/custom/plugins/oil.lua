return {
    -- Install oil.nvim for file exploration
    {
      'stevearc/oil.nvim',  -- Plugin name
      opts = {},  -- Options to customize the plugin, can be left empty or customized as needed
  
      -- Optional dependencies
      dependencies = {
        { "echasnovski/mini.icons", opts = {} },  -- This dependency provides icons for the file explorer
        -- Alternatively, you could use nvim-web-devicons for icons as shown below
        -- { "nvim-tree/nvim-web-devicons", opts = {} },
      },
  
      -- Setup configuration function
      config = function()
        -- Custom configurations for oil.nvim can be added here
        require("oil").setup({
          -- You can add your custom configurations here.
          -- Example configurations:
          view = {
            width = 40, -- Set width of the file explorer
            side = "left", -- Position of the file explorer (left or right)
          },
          -- You can enable additional settings here like key mappings, preview options, etc.
        })
      end,
    },
  }
  