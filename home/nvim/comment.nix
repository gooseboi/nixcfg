{pkgs, ...}: {
  config = with pkgs.vimPlugins;
  /*
  lua
  */
    ''
      {
        dir = "${comment-nvim}",
        name = "Comment",
        config = function()
        	-- sets gc for commenting lines
        	require("Comment").setup()
        end
      },
    '';
}
