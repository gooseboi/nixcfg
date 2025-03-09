{
  pkgs,
  lib,
  ...
}: {
  vim.extraPlugins = with pkgs.vimPlugins; {
    comment-nvim = {
      package = comment-nvim;
      setup = ''
        require("Comment").setup()
      '';
    };
  };
}
