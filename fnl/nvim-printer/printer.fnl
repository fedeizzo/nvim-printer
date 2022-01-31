(module nvim-printer.printer
        {require {ts_utils nvim-treesitter.ts_utils
                  nvim aniseed.nvim
                  core aniseed.core}})

(def- tokens {:python {:assignment :expression_statement
                       :variable :identifier
                       :stop_criterions [:identifier :subscript :call :assignment]}
              :fennel {}})
(def- outputs {:python  "print(f\'%s: {%s}\')"
               :bash  "echo \'%s\': \"%s\""
               :nim  "echo \"%s: \", %s"
               :typescript  "console.log(\'%s: \', %s)"})

(fn is-in? [list element]
  (let [first (core.first list)
        rest (core.rest list)]
    (if (not (core.nil? first))
      (if (= first element)
        true
        (is-in? rest element))
      false)))

(fn supported-filetype? [filetype]
  (if (is-in? (core.keys tokens) filetype)
    true
    false))

(fn get-node-text [node]
  (core.first (ts_utils.get_node_text node (nvim.fn.bufnr "%"))))

(fn get-node-position [node]
  (let [(start-row start-col) (node:start)
        (end-row end-col) (node:end_)]
    [start-row start-col end-row end-col]))

(fn format-string [filetype content]
  (string.format
   (. outputs filetype)
   content
   content))

(fn traverse-ancestors-until [input-node until]
  (let [parent-node (input-node:parent)
        parent-node-type (parent-node:type)]
    (if (not (is-in? until parent-node-type))
      (traverse-ancestors-until parent-node until)
      parent-node)))

(fn get-indentation [node filetype]
  (let [indent-node (traverse-ancestors-until node [(. (. tokens filetype) :assignment)])
        pos (get-node-position node)
        start-col (. pos 2)
        end-row (. pos 3)]
    [(+ end-row 1)  start-col]))

(fn place-text [text row col]
  (var prefix "")
  (for [i 1 col]
    (set prefix (core.str prefix " ")))
  (nvim.fn.append row (core.str prefix text)))

(fn get-content [node filetype]
  (let [ancestor (traverse-ancestors-until node (. (. tokens filetype) :stop_criterions))
        content (get-node-text ancestor)]
    (format-string filetype content)))

(defn get-output []
  (let [filetype nvim.bo.filetype
        node (ts_utils.get_node_at_cursor)]
    (when (supported-filetype? filetype)
      (if (= (node:type) (. (. tokens filetype) :variable))
        (let [content (format-string filetype (get-node-text node))
              pos (get-node-position node)
              start-col (. pos 2)
              end-row (. pos 3)]
          (place-text content (+ end-row 1) start-col))
        (when (~= (node:type) (. (. tokens filetype) :assignment))
          (print "assignment")
          (let [pos (get-indentation node filetype)
                content (get-content node filetype)]
            (place-text content (. pos 1) (. pos 2))))))))
