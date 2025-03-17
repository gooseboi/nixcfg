{
  pkgs,
  lib,
  ...
}: {
  home.file.".config/nvim/lua/chonk/plugins/comment.lua".text = with pkgs.vimPlugins; ''
    return {
      dir = "${comment-nvim}",
      name = "Comment",
      config = function()
      	-- sets gc for commenting lines
      	require("Comment").setup()
      end
    }
  '';
}
