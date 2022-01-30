(module nvim-printer.printer
        {autoload {ts_utils nvim-treesitter.ts_utils
                   core aniseed.core}})

(defn is-in? [list element]
  (let [first (core.first list)
        rest (core.rest list)]
    (print first rest)
    (if (not (core.nil? first))
      (if (= first element)
        true
        (is-in? rest element))
      false)))

(fn traverse-ancestors-until [input-node until]
  (let [node-type (input-node:type) node-paret (input-node:parent)]
    (if (~= node-type until)
      (traverse-ancestors-until node-paret until)
      (node-paret))))

(is-in? [:ciao :come] :ciao)
; local ts = require'nvim-treesitter.ts_utils'
; local M = {}
; local tokens = {
;     python = {
;         assignment = 'expression_statement',
;         stop_criterion = {'identifier', 'subscript', 'call'},
;     }
; }
; local outputs = {
;     python = 'print(f\'%s: {%s}\')',
;     bash = 'echo \'%s\': "%s"',
;     nim = 'echo "%s: ", %s',
;     typescript = 'console.log(\'%s: \', %s)',
; }
;
; local function is_in(tab, val)
;     for index, value in ipairs(tab) do
;         if value == val then
;             return true
;         end
;     end
;     return false
; end
;
; local function get_keys(tab)
;     local keys = {}
;     for k, v in pairs(DATA) do
;         table.insert(keys, k)
;     end
;     return keys
; end
;
; local function equal_check(first, second)
;     return first == second
; end
;
; local function traverse_ancestors_until(input_node, until_)
;     local node = input_node
;     local check_function = equal_check
;     if type(until_) == 'table'
;     then
;         check_function = is_in
;     end
;     repeat
;         node = node:parent()
;     until(check_function(until_, node:type()))
;     return node
; end
;
; local function get_indention_as_string(line)
;   local prefix = ''
;   for _ = 1, vim.fn.indent(line) do prefix = prefix .. ' ' end
;   return prefix
; end
;
; M.get_output = function ()
;     local filetype = vim.bo.filetype
;     -- if not is_in(get_keys(tokens), filetype)
;     -- then
;     --     return nil
;     -- end
;     local node = ts.get_node_at_cursor()
;     if node:type() == tokens[filetype]['assignment']
;     then
;         return nil
;     end
;     local expression_indentation = traverse_ancestors_until(node, tokens[filetype]['assignment'])
;     local starting_row, starting_col = expression_indentation:start()
;     local ending_row, ending_col = expression_indentation:end_()
;     local prefix = get_indention_as_string(starting_row + 1)
;     local ancestor = node
;     if node:type() ~= 'identifier'
;     then
;     ancestor = traverse_ancestors_until(node, tokens[filetype]['stop_criterion'])
;     end
;     local ancestor_content = ts.get_node_text(ancestor, vim.fn.bufnr('%'))[1]
;     local output = string.format(outputs[filetype], ancestor_content, ancestor_content)
;     vim.fn.append(ending_row + 1, prefix .. output)
; end
;
; M.get_output()
; return M
;
