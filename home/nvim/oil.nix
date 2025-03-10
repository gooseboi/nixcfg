{
  pkgs,
  lib,
  ...
}: {
  vim.extraPlugins = with pkgs.vimPlugins; {
    oil-nvim = {
      package = oil-nvim;
      setup = ''
        CustomOilBar = function()
        	local path = vim.fn.expand "%"
        	path = path:gsub("oil://", "")

        	return "  " .. vim.fn.fnamemodify(path, ":.")
        end

        require("oil").setup {
        	columns = { "icon" },
        	keymaps = {
        		["<C-h>"] = false,
        		["<C-l>"] = false,
        		["<C-k>"] = false,
        		["<C-j>"] = false,
        		["<M-h>"] = "actions.select_split",
        	},
        	win_options = {
        		winbar = "%{v:lua.CustomOilBar()}",
        	},
        	view_options = {
        		show_hidden = true,
        	},
        }

        -- Open parent directory in current window
        vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      '';
      after = ["nvim-web-devicons"];
    };
  };
}
