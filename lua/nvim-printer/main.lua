local _2afile_2a = "fnl/nvim-printer/main.fnl"
local _2amodule_name_2a = "nvim-printer.main"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local nvim, printer = require("aniseed.nvim"), require("nvim-printer.printer")
do end (_2amodule_locals_2a)["nvim"] = nvim
_2amodule_locals_2a["printer"] = printer
local function init()
  return nvim.set_keymap("n", "<Leader>c", ":lua require'nvim-printer.main'.get_output()<CR>", {noremap = true, silent = false})
end
_2amodule_2a["init"] = init
return {init = init, get_output = printer["get-output"]}