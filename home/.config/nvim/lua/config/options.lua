vim.g.lazyvim_ruby_lsp = "solargraph"
vim.treesitter.language.register("dockerfile", "Dockerfile")

vim.filetype.add({
  extension = {
    thor = "ruby",
  },
})

local o = vim.opt

o.fileencoding = "utf-8"
o.fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1"

o.linebreak = true
o.wrap = true
o.showbreak = "↪"

o.fileformats = "unix,dos"

-- Persist buffer-local options (e.g. filetype) in sessions;
-- detection is unreliable during session load
o.sessionoptions:append("localoptions")

vim.g.lazyvim_picker = "snacks"
