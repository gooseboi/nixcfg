require('luacfg.config');
require('luacfg.filetypes');
require('luacfg.neovide');
require('luacfg.remap');

if vim.g.chonkos_desktop == true then
	-- Arguably the files shouldn't even be brought in, but I cannot be bothered
	-- to make a different file set
	require('luacfg.plugins.blink');
	require('luacfg.plugins.easymotion');
	require('luacfg.plugins.harpoon');
	require('luacfg.plugins.lsp');
	require('luacfg.plugins.telescope');
	require('luacfg.plugins.vimwiki');
end

require('luacfg.plugins.comment');
require('luacfg.plugins.gruvbox');
require('luacfg.plugins.lualine');
require('luacfg.plugins.oil');
