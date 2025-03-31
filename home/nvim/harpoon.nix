{pkgs, ...}: {
  config = with pkgs.vimPlugins;
  /*
  lua
  */
    ''
      {
      dir = "${harpoon}",
      name = "harpoon",
      dependencies = {
        { dir = "${plenary-nvim}", name = "plenary", },
      },
      config = function()
          local mark = require("harpoon.mark")
          local ui = require("harpoon.ui")

          vim.keymap.set("n", "<leader>a", mark.add_file)
          vim.keymap.set("n", "<C-h>", ui.toggle_quick_menu)

          vim.keymap.set("n", "<C-e>", function() ui.nav_next() end)
          vim.keymap.set("n", "<C-s>", function() ui.nav_prev() end)
      end,
      },
    '';
}
