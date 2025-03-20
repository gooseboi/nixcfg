{
  pkgs,
  lib,
  ...
}: {
  config = with pkgs.vimPlugins; ''
    {
      dir =  "${lualine-nvim}",
      name = "lualine",
      dependencies = {
        { dir = "${nvim-web-devicons}", name = "nvim-web-devicons" },
      },
      config = function()
        require("lualine").setup {
        	options = {
        		icons_enabled = true,
        		theme = "gruvbox_dark",
        		component_separators = { left = "", right = "" },
        		section_separators = { left = "", right = "" },
        		disabled_filetypes = {
        			statusline = {},
        			winbar = {},
        		},
        		ignore_focus = {},
        		always_divide_middle = true,
        		globalstatus = false,
        		refresh = {
        			statusline = 10,
        			tabline = 10,
        			winbar = 10,
        		}
        	},
        	sections = {
        		lualine_a = { "mode" },
        		lualine_b = { "branch", "diff", "diagnostics" },
        		lualine_c = { "filename" },
        		lualine_x = { "encoding", "fileformat", "filetype" },
        		lualine_y = { "progress" },
        		lualine_z = { "location" }
        	},
        	inactive_sections = {
        		lualine_a = {},
        		lualine_b = {},
        		lualine_c = { "filename" },
        		lualine_x = { "location" },
        		lualine_y = {},
        		lualine_z = {}
        	},
        	tabline = {},
        	winbar = {},
        	inactive_winbar = {},
        	extensions = {}
        }
      end
    },
  '';
}
