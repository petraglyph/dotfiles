-- NeoVim Config
--   Penn Bauman <me@pennbauman.com>
--   https://github.com/pennbauman/dotfiles

-- General
vim.opt.filetype = 'plugin'
vim.opt.encoding = 'utf8'
vim.opt.clipboard = 'unnamedplus'
-- Appearance
vim.opt.number = true
vim.opt.linebreak = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.listchars = 'tab:¦ ,trail:~,extends:>,precedes:<'
vim.opt.list = true
vim.opt.guicursor = ''
vim.opt.scrolloff = 5
vim.opt.colorcolumn = '81'
vim.cmd('colorscheme maia-custom')
-- Netrw
vim.api.nvim_set_var('netrw_banner', 1)
vim.api.nvim_set_var('netrw_liststyle', 1)

local augroup = vim.api.nvim_create_augroup('custom', {clear = true})
-- Set spellcheck
local setspell = function()
	vim.opt_local.spell = true
end
vim.api.nvim_create_autocmd('FileType', {pattern = 'text', group = augroup, callback = setspell})
vim.api.nvim_create_autocmd('FileType', {pattern = 'markdown', group = augroup, callback = setspell})
vim.api.nvim_create_autocmd('FileType', {pattern = 'tex', group = augroup, callback = setspell})
-- Remember cursor position
vim.api.nvim_create_autocmd('BufReadPost', {pattern = '*', group = augroup,
	command = 'if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g`\\"" | endif'
})

-- Keyboard Shortcuts
vim.keymap.set('n', '<tab>', ':bnext<Enter>', {noremap = true, silent = true})
vim.keymap.set('n', '<S-tab>', ':bprev<Enter>', {noremap = true, silent = true})
-- Document navigation
vim.keymap.set('', 'k', 'gk', {noremap = true, silent = true})
vim.keymap.set('', 'j', 'gj', {noremap = true, silent = true})
vim.keymap.set('', '<S-h>', 'g^', {noremap = true, silent = true})
vim.keymap.set('', '<S-j>', '15gj', {noremap = true, silent = true})
vim.keymap.set('', '<S-k>', '15gk', {noremap = true, silent = true})
vim.keymap.set('', '<S-l>', 'g$', {noremap = true, silent = true})
vim.keymap.set('n', '<S-u>', ':redo<Enter>', {noremap = true, silent = true})
-- Editing
vim.keymap.set('n', '<enter>', 'o<esc>', {noremap = true, silent = true})
vim.keymap.set('n', ';', ':', {noremap = true, silent = true})
vim.keymap.set('n', '<', 'v<', {noremap = true, silent = true})
vim.keymap.set('n', '>', 'v>', {noremap = true, silent = true})
-- Terminal
vim.keymap.set('n', '<C-t>', ':terminal<Enter>i<end>', {noremap = true, silent = true})
vim.cmd('autocmd TermOpen * setlocal nonumber')
-- Netrw
vim.keymap.set('n', '<C-f>', ':Explore<Enter>', {noremap = true, silent = true})


-- Plugins (packer.nvim)
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	vim.cmd [[packadd packer.nvim]]
end
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'vim-airline/vim-airline'
	use "terrortylor/nvim-comment"
	use 'nvim-lua/completion-nvim'
	use {'steelsojka/completion-buffers', requires = {'nvim-lua/completion-nvim'}}
	use {'lervag/vimtex', ft = {'tex'}}
	use 'nickeb96/fish.vim'

	-- Automatically set up your configuration after cloning packer.nvim
	if packer_bootstrap then
		require('packer').sync()
	end
end)

-- vim-airline
vim.api.nvim_set_var('airline_theme', 'maia_custom')
vim.api.nvim_set_var('airline#extensions#tabline#enabled', 1)

-- nvim-comment
if pcall(require, 'nvim_comment') then
	require('nvim_comment').setup({hook = function()
		local filetype = vim.api.nvim_buf_get_option(0, "filetype")
		if filetype == "cpp" or filetype == "c" then
			vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
		end
	end})
	vim.keymap.set('n', 'c', ':CommentToggle<Enter>', {noremap = true, silent = true})
	vim.keymap.set('v', 'c', ':CommentToggle<Enter>', {noremap = true, silent = true})
end

-- completion-nvim
if pcall(require, 'completion') then
	vim.opt.completeopt = 'menuone,noinsert,noselect'
	table.insert(vim.opt.shortmess, 'c')
	vim.api.nvim_create_autocmd('FileType', {pattern = '*', group = augroup, callback = function()
		require('completion').on_attach({
			sorting = 'length',
			matching_strategy_list = {'exact', 'substring', 'fuzzy'},
			chain_complete_list = {
				default = {{complete_items = {'lsp', 'path', 'buffers'}}},
				string = {{complete_items = {'path', 'buffers'}}},
				comment = {{complete_items = {'buffers'}}},
			},
		})
	end})
	-- Use <Tab> and <S-Tab> to navigate through popup menu
	vim.keymap.set('i', '<Tab>', function()
		return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
	end, { expr = true })
	vim.keymap.set('i', '<S-Tab>', function()
		return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
	end, { expr = true })
end

-- VimTeX
vim.api.nvim_create_autocmd('FileType', {pattern = 'tex', group = augroup, callback = function()
	vim.api.nvim_set_var('tex_flavor', 'latex')
	vim.api.nvim_set_var('vimtex_view_method', 'zathura')
	vim.api.nvim_set_var('vimtex_quickfix_mode', 0)
	vim.keymap.set('n', '<C-l>', ':VimtexCompile<Enter>', {noremap = true, silent = true})
	vim.api.nvim_create_user_command('TexWC', function()
		print(vim.api.nvim_exec(':w !detex | wc -w', true))
	end, {bang = true})
end})
