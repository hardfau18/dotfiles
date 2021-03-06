local mod = {}
mod.setup = function()
  local nls = require("null-ls")
  local sources = {
    nls.builtins.formatting.prettier.with({
      filetypes = { "html", "json", "yaml", "css", "htmldjango" },
    }),
    nls.builtins.formatting.stylua.with({
      extra_args = {
        "--column-width",
        100,
        "--indent-type",
        "Spaces",
        "--indent-width",
        vim.o.shiftwidth,
      },
    }),
  }
  nls.setup({
    log = { level = "warn" },
    sources = sources,
    on_init = require("cfg.lsp").custom_attach,
  })
end
return mod
