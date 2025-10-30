{pkgs, ...}: {
  config = pkgs.replaceVarsWith {
    src = ./configs/comment.lua;
    replacements = with pkgs.vimPlugins; {
      inherit comment-nvim;
    };
  };
}
