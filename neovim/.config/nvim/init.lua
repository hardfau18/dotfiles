local fn = vim.fn

-- other configs
require("cfg.config")
require("cfg.colorscheme")
require("cfg.utils")
require("cfg.key_maps")
-- install packer if its not installed
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	print("installing packer")
	vim.cmd("packadd packer.nvim") -- add the packer to vim
end

-- auto load packer file if its written
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost */nvim/init.lua source <afile> | PackerSync
	augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
	print("Failed to load packer ")
	return
end

-- better to reset when re sourcing
packer.reset()
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

packer.startup(function()
	-- manage itself
	use("wbthomason/packer.nvim")
	-- colorschemes
	use("rebelot/kanagawa.nvim")
	use("folke/tokyonight.nvim")
	use("morhetz/gruvbox")
	use({
		"yuttie/comfortable-motion.vim",
		config = function()
			require("cfg.comfortable-motion")
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("cfg.treesitter")
		end,
	})
	use({
		"tpope/vim-fugitive",
		config = function()
			require("cfg.fugitive")
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				toggler = {
					line = "<leader>cc",
					block = "<leader>cb",
				},
				extra = {
					above = "<leader>cO",
					below = "<leader>co",
					eol = "<leader>cA",
				},
                mappings = {
                    basic = "toggler"
                }
			})
		end,
	})
	use({ -- diagnostics looks cool
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		requires = { { "jose-elias-alvarez/null-ls.nvim", opt = true } },
		config = function()
			require("cfg.lsp")
		end,
	})

	use({
		"simrat39/rust-tools.nvim",
		requires = { "neovim/nvim-lspconfig" },
		config = function()
			require("cfg.rust_tools").setup()
		end,
	})

	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("cfg.nvim-tree")
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
		config = function()
			require("cfg.telescope")
		end,
	})
	use({
		"nvim-neorg/neorg", -- 
		config = function()
            require("cfg.neorg").init()
		end,
		requires = {"nvim-lua/plenary.nvim",
		"nvim-neorg/neorg-telescope" }
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("cfg.lua_line")
		end,
	})
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	-- nvim cmp plugin and sources
	use({
		"hrsh7th/nvim-cmp",
		requires = { "neovim/nvim-lspconfig", },
		config = function()
			require("cfg.nvim-cmp")
		end,
	})
	use({ "saadparwaiz1/cmp_luasnip", requires = { "hrsh7th/nvim-cmp", "L3MON4D3/LuaSnip" } }) -- luasnip completion support
	use({ "hrsh7th/cmp-nvim-lsp", requires = { "hrsh7th/nvim-cmp" } }) -- basic lsp cmp
	use({ "hrsh7th/cmp-buffer", requires = { "hrsh7th/nvim-cmp" } }) -- buffer words completion
	use({ "hrsh7th/cmp-path", requires = { "hrsh7th/nvim-cmp" } }) -- path completion
	use({ "hrsh7th/cmp-nvim-lua", requires = { "hrsh7th/nvim-cmp" } }) -- lua completion source
	use({ "onsails/lspkind-nvim", requires = { "hrsh7th/nvim-cmp" } }) -- lsp completion formatting
	use({ "f3fora/cmp-spell", requires = { "hrsh7th/nvim-cmp" } }) -- vim spell check
	use({ "petertriho/cmp-git", requires = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" } }) -- vim spell check
end)
