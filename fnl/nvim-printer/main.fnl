(module nvim-printer.main
        {require {printer nvim-printer.printer
                  python nvim-printer.languages.python
                  nvim aniseed.nvim}})

(var filtetypes [:python])

(fn supported-filetype? [filetype]
  (if (is-in? filtetypes filetype)
    true
    false))

(defn get-output []
  (let [filetype nvim.bo.filetype]
    (if (= filetype :python)
      (python))))

(defn init []
  (nvim.set_keymap :n :<Leader>c ":lua require'nvim-printer.main'.get_output()<CR>" {:noremap true :silent false}))

{:init init
 :get_output get-output}
