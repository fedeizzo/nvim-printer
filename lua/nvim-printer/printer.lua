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
local core, nvim, ts_utils = require("aniseed.core"), require("aniseed.nvim"), require("nvim-treesitter.ts_utils")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["ts_utils"] = ts_utils
local tokens = {python = {assignment = "expression_statement", variable = "identifier", stop_criterions = {"identifier", "subscript", "call", "assignment"}}, fennel = {}}
_2amodule_locals_2a["tokens"] = tokens
local outputs = {python = "print(f'%s: {%s}')", bash = "echo '%s': \"%s\"", nim = "echo \"%s: \", %s", typescript = "console.log('%s: ', %s)"}
_2amodule_locals_2a["outputs"] = outputs
local function is_in_3f(list, element)
  local first = core.first(list)
  local rest = core.rest(list)
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
local function supported_filetype_3f(filetype)
  if is_in_3f(core.keys(tokens), filetype) then
    return true
  else
    return false
  end
end
local function get_node_text(node)
  return core.first(ts_utils.get_node_text(node, nvim.fn.bufnr("%")))
end
local function get_node_position(node)
  local start_row, start_col = node:start()
  local end_row, end_col = node:end_()
  return {start_row, start_col, end_row, end_col}
end
local function format_string(filetype, content)
  return string.format(outputs[filetype], content, content)
end
local function traverse_ancestors_until(input_node, _until)
  local parent_node = input_node:parent()
  local parent_node_type = parent_node:type()
  if not is_in_3f(_until, parent_node_type) then
    return traverse_ancestors_until(parent_node, _until)
  else
    return parent_node
  end
end
local function get_indentation(node, filetype)
  local indent_node = traverse_ancestors_until(node, {tokens[filetype].assignment})
  local pos = get_node_position(node)
  local start_col = pos[2]
  local end_row = pos[3]
  return {(end_row + 1), start_col}
end
local function place_text(text, row, col)
  local prefix = ""
  for i = 1, col do
    prefix = core.str(prefix, " ")
  end
  return nvim.fn.append(row, core.str(prefix, text))
end
local function get_content(node, filetype)
  local ancestor = traverse_ancestors_until(node, tokens[filetype].stop_criterions)
  local content = get_node_text(ancestor)
  return format_string(filetype, content)
end
local function get_output()
  local filetype = nvim.bo.filetype
  local node = ts_utils.get_node_at_cursor()
  if supported_filetype_3f(filetype) then
    if (node:type() == tokens[filetype].variable) then
      local content = format_string(filetype, get_node_text(node))
      local pos = get_node_position(node)
      local start_col = pos[2]
      local end_row = pos[3]
      return place_text(content, (end_row + 1), start_col)
    else
      if (node:type() ~= tokens[filetype].assignment) then
        print("assignment")
        local pos = get_indentation(node, filetype)
        local content = get_content(node, filetype)
        return place_text(content, pos[1], pos[2])
      else
        return nil
      end
    end
  else
    return nil
  end
end
_2amodule_2a["get-output"] = get_output