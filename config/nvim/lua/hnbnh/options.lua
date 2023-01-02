local o = vim.opt

o.splitbelow = true -- Creating vertical windows
o.splitright = true -- Creating horizontal windows
o.timeoutlen = 250 -- Wait for a mapped sequence
o.updatetime = 300 -- For CursorHold events
o.clipboard = "unnamedplus" -- Use system clipboard
o.swapfile = false -- Disable creating swapfiles
-- Ignore certain files and folders when globing
o.wildignore:append({
  "*.obj",
  "*.dylib",
  "*.bin",
  "*.dll",
  "*.exe",
  "*/.git/*",
  "*/__pycache__/*",
  "*/build/**",
  "*.jpg",
  "*.png",
  "*.jpeg",
  "*.bmp",
  "*.gif",
  "*.tiff",
  "*.svg",
  "*.ico",
  "*.pyc",
  "*.pkl",
  "*.aux",
  "*.bbl",
  "*.blg",
  "*.brf",
  "*.fls",
  "*.fdb_latexmk",
  "*.synctex.gz",
  "*.xdv",
})

-- Tab --
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2 -- The number of spaces inserted for each indentation
o.expandtab = true

o.number = true -- Show line number
o.relativenumber = true

-- Ignore case in general, but become case-sensitive when uppercase is present
o.ignorecase = true
o.smartcase = true

-- File and script encoding settings for vim
o.fileencoding = "utf-8"
o.fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1"

-- Wrap long lines with custom character
o.linebreak = true
o.showbreak = "↪"

o.scrolloff = 8 -- Minimum lines to keep above and below cursor when scrolling
o.showmode = false -- Disable showing current mode
o.fileformats = "unix,dos" -- Fileformats to use for new files

-- Do not use visual and errorbells
o.visualbell = true
o.errorbells = false
o.history = 500 -- The number of command and search history to keep
o.undofile = true -- Persistent undo
o.shortmess:append({ c = true, S = true }) -- Do not show "match xx of xx", search match count on bottom right (use plugin instead)
o.completeopt:append({ "menuone", "noselect" }) -- Completion behaviour
-- o.completeopt:remove{"preview"}
o.pumheight = 10 -- Pop up menu height
o.pumblend = 10 -- Pseudo transparency for completion menu
o.winblend = 5 -- Pseudo transparency for floating window
o.complete:append({ "kspell" }) -- Insert mode completion with `spell` turned on (<C-p> or <C-n>)
-- o.complete:remove{"w", "b", "u", "t"}
o.spell = true
o.spelllang = "en"
o.spelloptions = "camel"
o.spellsuggest:append({ 9 }) -- Show 9 spell suggestions at most
o.virtualedit = "block" -- Virtual block edit
o.synmaxcol = 200 -- Text after this column number is not highlighted
o.cmdheight = 2 -- More space for nvim cmd line
-- o.mouse = "a" -- Allow the mouse to be used (turn on later)
o.smartindent = true
o.cursorline = true -- Hightlight the current line
o.signcolumn = "yes" -- Always show the sign column, otherwise it would shift the text each time
o.termguicolors = true

-- Put this at the end of the file
if vim.g.started_by_firenvim then
  o.laststatus = 0
  o.number = false
  o.relativenumber = false
  o.ruler = false
  o.showcmd = false
  o.guifont = { "FiraCode Nerd Font", ":h10" }
  o.winbar = ""
end
