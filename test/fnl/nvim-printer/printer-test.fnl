(module nvim-printer.printer-test
        {autoload {printer nvim-printer.printer}})

(deftest is-in-with-empty-list
  (t.= false (printer.is-in? [] :test)))
