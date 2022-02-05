local _2afile_2a = "fnl/nvim-printer/languages/python.fnl"
local _2amodule_name_2a = "nvim-printer.python"
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
local core, nvim, printer, ts_utils = require("aniseed.core"), require("aniseed.nvim"), require("nvim-printer.printer"), require("nvim-treesitter.ts_utils")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["printer"] = printer
_2amodule_locals_2a["ts_utils"] = ts_utils
local stop_criterions = {"identifier", "subscript", "call", "assignment"}
_2amodule_locals_2a["stop_criterions"] = stop_criterions
local call_triggers = {"identifier", "subscript", "call", "assignment"}
_2amodule_locals_2a["call_triggers"] = call_triggers
local output = "print(f'%s: {%s}')"
_2amodule_locals_2a["output"] = output
local function generate_output_string(content)
  local escaped = string.gsub(content, "'", "\"")
  local doubled = string.gsub(escaped, "{", "{{")
  local doubled0 = string.gsub(doubled, "}", "}}")
  return string.format(output, doubled0, escaped)
end
local function traverse(node, _until)
  local pos = printer["get-indentation"](node, "expression_statement")
  local ancestor = printer["traverse-ancestors-until"](node, _until)
  local ancestor_text = printer["get-node-text"](ancestor)
  local content = generate_output_string(ancestor_text)
  return printer["place-text"](content, pos[1], pos[2])
end
local function generic_handler(node)
  return traverse(node, stop_criterions)
end
local function call_check(node, parent)
  return ((node:type() == "identifier") and (parent:type() == "call"))
end
local function subscript_check(node, parent)
  return ((node:type() == "string") and (parent:type() == "subscript"))
end
local function variable_check(node, parent)
  return (node:type() == "identifier")
end
local function current_node_handler(node)
  local node_text = printer["get-node-text"](node)
  local content = generate_output_string(node_text)
  local pos = printer["get-indentation"](node, "expression_statement")
  return printer["place-text"](content, pos[1], pos[2])
end
local function nested_identifier_check(node, parent)
  return ((node:type() == "identifier") and ((parent:type() == "identifier") or (parent:type() == "attribute")))
end
local function nested_identifier_handler(node)
  return traverse(node, {"call"})
end
local function list_dict_check(node, parent)
  return ((node:type() == "list") or (node:type() == "dictionary"))
end
local function list_dict_handler(node)
  return current_node_handler(node)
end
local conditions = {list_dict_check, call_check, nested_identifier_check, subscript_check, variable_check}
_2amodule_locals_2a["conditions"] = conditions
local handlers = {list_dict_handler, generic_handler, nested_identifier_handler, generic_handler, current_node_handler}
_2amodule_locals_2a["handlers"] = handlers
local printed = false
local function get_output()
  do
    local node = ts_utils.get_node_at_cursor()
    local parent = node:parent()
    for i = 1, table.getn(conditions) do
      if printed then break end
      if conditions[i](node, parent) then
        handlers[i](node)
        printed = true
      else
      end
    end
  end
  printed = false
  return nil
end
_2amodule_2a["get_output"] = get_output
return get_output