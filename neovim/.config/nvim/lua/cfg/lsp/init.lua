local mod = {}
require("cfg.lsp.visuals")

-- cursor highlighting enable
local function documentHighlight(client, _)
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

mod.custom_attach = function(client, bufnr)
  documentHighlight(client, bufnr)
  if client.name == "sumneko_lua" then
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end
  require("cfg.lsp.keymaps").setup(bufnr)
end

mod.setup = function()
  local config = require("cfg.lsp.config")
  if config == nil then
    print("lsp cfg table not found")
    return
  end
  local status, lspconfig = pcall(require, "lspconfig")
  if not status then
    print("lspconfig module not found")
    return
  end
  require("vim.lsp.log").set_level(vim.log.levels.ERROR)

  for _, cfg in pairs(config) do
    local lsp = cfg.lsp
    if lsp ~= nil and lsp.provider ~= nil and lsp.provider ~= "" then
      lsp.setup.on_attach = mod.custom_attach
      lsp.setup.capabilities = vim.lsp.protocol.make_client_capabilities()
      local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if status_ok then
        lsp.setup.capabilities = cmp_nvim_lsp.update_capabilities(lsp.setup.capabilities)
      end
      lspconfig[lsp.provider].setup(lsp.setup)
    end
  end
end

return mod
