local _2afile_2a = "fnl/nvim-printer/printer.fnl"
local _2amodule_name_2a = "nvim-printer.printer"
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
local autoload = (require("nvim-printer.aniseed.autoload")).autoload
local core, ts_utils = autoload("nvim-printer.aniseed.core"), autoload("nvim-treesitter.ts_utils")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["ts_utils"] = ts_utils
local function is_in_3f(list, element)
  local first = core.first(list)
  local rest = core.rest(list)
  print(first, rest)
  if not core["nil?"](first) then
    if (first == element) then
      return true
    else
      return is_in_3f(rest, element)
    end
  else
    return false
  end
end
_2amodule_2a["is-in?"] = is_in_3f
local function traverse_ancestors_until(input_node, _until)
  local node_type = input_node:type()
  local node_paret = input_node:parent()
  if (node_type ~= _until) then
    return traverse_ancestors_until(node_paret, _until)
  else
    return node_paret()
  end
end
return is_in_3f({"ciao", "come"}, "ciao")