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
local nvim, printer, python = require("aniseed.nvim"), require("nvim-printer.printer"), require("nvim-printer.languages.python")
do end (_2amodule_locals_2a)["nvim"] = nvim
_2amodule_locals_2a["printer"] = printer
_2amodule_locals_2a["python"] = python
local filtetypes = {"python"}
local function supported_filetype_3f(filetype)
  if __fnl_global__is_2din_3f(filtetypes, filetype) then
    return true
  else
    return false
  end
end
local function get_output()
  local filetype = nvim.bo.filetype
  if (filetype == "python") then
    return python()
  else
    return nil
  end
end
_2amodule_2a["get-output"] = get_output
local function init()
  return nvim.set_keymap("n", "<Leader>c", ":lua require'nvim-printer.main'.get_output()<CR>", {noremap = true, silent = false})
end
_2amodule_2a["init"] = init
return {init = init, get_output = get_output}