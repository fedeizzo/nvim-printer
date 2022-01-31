(module nvim-printer.main
        {require {printer nvim-printer.printer
                  nvim aniseed.nvim}})

(defn init []
  (nvim.set_keymap :n :<Leader>c ":lua require'nvim-printer.main'.get_output()<CR>" {:noremap true :silent false}))

{:init init
 :get_output printer.get-output}
