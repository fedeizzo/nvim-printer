(module nvim-printer.python
        {require {ts_utils nvim-treesitter.ts_utils
                  nvim aniseed.nvim
                  core aniseed.core
                  printer nvim-printer.printer}})

(def- stop_criterions [:identifier :subscript :call :assignment])
(def- call_triggers [:identifier :subscript :call :assignment])

(def- output "print(f\'%s: {%s}\')")
(fn generate-output-string [content]
  (let [escaped (string.gsub content "'" "\"")
        doubled (string.gsub escaped "{" "{{")
        doubled (string.gsub doubled "}" "}}")]
    (string.format output doubled escaped)))

(fn traverse [node until]
  (let [pos (printer.get-indentation node :expression_statement)
        ancestor (printer.traverse-ancestors-until node until)
        ancestor-text (printer.get-node-text ancestor)
        content (generate-output-string ancestor-text)]
    (printer.place-text content (. pos 1) (. pos 2))))

(fn generic-handler [node]
  (traverse node stop_criterions))

(fn call-check [node parent]
  (and (= (node:type) :identifier) (= (parent:type) :call)))
(fn subscript-check [node parent]
  (and (= (node:type) :string) (= (parent:type) :subscript)))

(fn variable-check [node parent]
  (= (node:type) :identifier))
(fn current-node-handler [node]
  (let [node-text (printer.get-node-text node)
        content (generate-output-string node-text)
        pos (printer.get-indentation node :expression_statement)]
    (printer.place-text content (. pos 1) (. pos 2))))

(fn nested-identifier-check [node parent]
  (and (= (node:type) :identifier)
       (or (= (parent:type) :identifier) (= (parent:type) :attribute))))
(fn nested-identifier-handler [node]
  (traverse node [:call]))

(fn list-dict-check [node parent]
  (or (= (node:type) :list) (= (node:type) :dictionary)))
(fn list-dict-handler [node]
  (current-node-handler node))

(def- conditions [list-dict-check
                  call-check
                  nested-identifier-check
                  subscript-check
                  variable-check])
(def- handlers [list-dict-handler
                generic-handler
                nested-identifier-handler
                generic-handler
                current-node-handler])

(var printed false)
(defn get_output []
  (let [node (ts_utils.get_node_at_cursor)
        parent (node:parent)]
    (for [i 1 (table.getn conditions) :until printed]
      (if ((. conditions i) node parent)
        (do
          ((. handlers i) node)
          (set printed true)))))
  (set printed false))

get_output
