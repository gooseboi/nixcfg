vim.cmd('language en_US.UTF8')

-- Copy indent from previous line
vim.opt.autoindent = true;
-- https://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
vim.opt.timeoutlen = 300;
-- Use UTF-8
vim.opt.encoding = 'utf-8';
-- Keep 5 lines above and below the cursor when scrolling
vim.opt.scrolloff = 5;
-- Keep 7 lines to both sides when scrolling
vim.opt.sidescrolloff = 7;
-- Don't show the editor mode as it is shown by the status bar
vim.opt.showmode = false;
-- Allow unsaved buffers to be hidden
vim.opt.hidden = true;
-- No line wrapping
vim.opt.wrap = false;
-- Don't insert spaces between '.' after joining lines
vim.opt.joinspaces = false;
-- Add a column 80 lines out to mark a limit
vim.opt.colorcolumn = '80';
vim.opt.signcolumn = 'yes';

-- Sane splits
-- Automatically create hsplits right of the current window
vim.opt.splitright = true;
-- Automatically create vsplits below the current window
vim.opt.splitbelow = true;

-- Permanent file for undos
vim.opt.undofile = true;

-- Turn on wildmenu for completion
vim.opt.wildmenu = true;
--`longest` autocompletes to the longest common string
-- `list` lists all matches
vim.opt.wildmode = 'list:longest';
-- Ignore files that have no use being opened in vim
vim.opt.wildignore =
'.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor';

-- Wrapping options
vim.opt.formatoptions = 'tcrqnbjp';

-- Tab settings
vim.opt.shiftwidth = 4;
vim.opt.softtabstop = 4;
vim.opt.tabstop = 4;
vim.opt.expandtab = false;
vim.opt.smartindent = true;

-- Proper search
vim.opt.incsearch = true;
vim.opt.ignorecase = true;
vim.opt.smartcase = true;
vim.opt.gdefault = true;
vim.opt.hlsearch = false;

-- Better message display
vim.opt.cmdheight = 2;
-- Better experience than the default 4000
vim.opt.updatetime = 300;
-- No more beeps
vim.opt.errorbells = false;
-- Backspace over newlines
vim.opt.backspace = '2';
vim.opt.foldenable = false;
vim.opt.lazyredraw = true;
vim.opt.synmaxcol = 500;
vim.opt.laststatus = 2;
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.ruler = true;
vim.opt.showcmd = true;
vim.opt.mouse = '';
vim.opt.listchars = 'nbsp:¬,extends:»,precedes:«,trail:•';

-- Make the border around LSP diagnostics bigger
vim.opt.winborder = "bold";

-- no beeping
vim.opt.vb = true;

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ timeout = 400 })
	end
})

-- Courtesy of Lukesmith
-- Removes trailing whitespace in file before saving
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function(_)
		local currPos = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, currPos)
	end
})
