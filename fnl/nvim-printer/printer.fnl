(module nvim-printer.printer
        {require {ts_utils nvim-treesitter.ts_utils
                  nvim aniseed.nvim
                  core aniseed.core}})

(defn is-in? [list element]
  (let [first (core.first list)
        rest (core.rest list)]
    (if (not (core.nil? first))
      (if (= first element)
        true
        (is-in? rest element))
      false)))

(defn get-node-text [node]
  (core.first (ts_utils.get_node_text node (nvim.fn.bufnr "%"))))

(defn get-node-position [node]
  (let [(start-row start-col) (node:start)
        (end-row end-col) (node:end_)]
    [start-row start-col end-row end-col]))

(defn traverse-ancestors-until [input-node until]
  (let [parent-node (input-node:parent)
        parent-node-type (parent-node:type)]
    (if (not (is-in? until parent-node-type))
      (traverse-ancestors-until parent-node until)
      parent-node)))

(defn get-indentation [node assignment-token]
  (let [indent-node (traverse-ancestors-until node [assignment-token])
        pos (get-node-position indent-node)
        start-col (. pos 2)
        end-row (. pos 3)]
    [(+ end-row 1)  start-col]))

(defn place-text [text row col]
  (var prefix "")
  (for [i 1 col]
    (set prefix (core.str prefix " ")))
  (nvim.fn.append row (core.str prefix text)))

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
