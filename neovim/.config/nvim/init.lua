local fn = vim.fn

-- other configs
require("cfg.opts")
require("cfg.utils")
require("cfg.key_maps")

-- install packer if its not installed
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local fresh_inst = false
if fn.empty(fn.glob(install_path)) > 0 then
    print("installing packer")
    fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    vim.cmd("packadd packer.nvim") -- add the packer to vim
    fresh_inst = true
end

-- auto load packer file if its written
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */nvim/init.lua source <afile> | PackerCompile
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
    print("Failed to load packer ")
    return
end

if fresh_inst then
    packer.sync()
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
    use({
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                dimInactive = true,
                globalStatus = true,
            })
            vim.cmd([[colorscheme kanagawa]])
        end,
    })
    use("folke/tokyonight.nvim")
    use("morhetz/gruvbox")
    --------------
    -- for syncing files with remote repo
    -- use("kenn7/vim-arsync")
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                disable_in_macro = true,
                map_c_w = true,
            })
        end,
    })
    use({
        "folke/which-key.nvim",
        config = function()
            require("cfg.which-key").setup()
        end,
    })

    -- use({
    --     "yuttie/comfortable-motion.vim",
    --     config = function()
    --         require("cfg.comfortable-motion").setup()
    --     end,
    -- })
    use({
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("cfg.treesitter").setup()
        end,
    })
    use({
        "nvim-treesitter/playground",
        requires = { "nvim-treesitter/nvim-treesitter" },
    })
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("cfg.indent_blankline").setup()
        end,
    })
    use({
        "tpope/vim-fugitive",
        config = function()
            require("cfg.fugitive").setup()
        end,
    })
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("cfg.comment_nvim.init").setup()
        end,
    })
    use({ -- diagnostics looks cool
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("cfg.trouble").setup()
        end,
    })
    use({
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
        config = function()
            require("cfg.telescope").setup()
        end,
    })
    use({
        "jose-elias-alvarez/null-ls.nvim",
        disable = true,
        requires = { { "nvim-lua/plenary.nvim" } },
        -- disable = true,
        config = function()
            require("cfg.null-ls").setup()
        end,
    })

    use({
        "nvim-neorg/neorg",
        config = function()
            require("cfg.neorg").init()
        end,
        requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
    })
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("cfg.lua_line")
        end,
    })
    use({
        "iamcco/markdown-preview.nvim",
        run = ":call mkdp#util#install()",
        setup = function()
            require("cfg.markdown-prev").setup()
        end,
        ft = { "markdown" },
    })
    use({
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip/loaders/from_vscode").lazy_load()
        end,
    })
    use({
        "rafamadriz/friendly-snippets",
        requires = { "L3MON4D3/LuaSnip", required = true },
    })
    use({
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("cfg.nvim-tree").setup()
        end,
    })

    use( "neovim/nvim-lspconfig")
    use({
        "simrat39/rust-tools.nvim",
        requires = { { "neovim/nvim-lspconfig", required = true } },
        afetr = "neovim/nvim-lspconfig",
        -- config = function()
        --     require("cfg.rust-tools").setup({})
        -- end,
    })
    -- nvim cmp plugin and sources
    use({
        "hrsh7th/nvim-cmp",
        requires = { "neovim/nvim-lspconfig" },
        config = function()
            require("cfg.nvim-cmp").setup()
        end,
    })
    use({ "saadparwaiz1/cmp_luasnip", requires = { "hrsh7th/nvim-cmp", "L3MON4D3/LuaSnip" } }) -- luasnip completion support
    use({ "hrsh7th/cmp-nvim-lsp", requires = { "hrsh7th/nvim-cmp" } }) -- basic lsp cmp
    use({ "hrsh7th/cmp-buffer", requires = { "hrsh7th/nvim-cmp" } }) -- buffer words completion
    use({ "hrsh7th/cmp-path", requires = { "hrsh7th/nvim-cmp" } }) -- path completion
    use({ "hrsh7th/cmp-nvim-lua", requires = { "hrsh7th/nvim-cmp" } }) -- lua completion source
    use({ "onsails/lspkind-nvim", requires = { "hrsh7th/nvim-cmp" } }) -- lsp completion formatting
    use({ "petertriho/cmp-git", requires = { "hrsh7th/nvim-cmp", "nvim-lua/plenary.nvim" } }) -- vim spell check
end)
require("cfg.lsp").setup()
require("cfg.rust-tools").setup({})
