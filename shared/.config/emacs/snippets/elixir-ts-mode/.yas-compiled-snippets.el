;;; Compiled snippets and support files for `elixir-ts-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'elixir-ts-mode
                     '((">iois" "|> IO.inspect(label: \"$1\")"
                        "piped IO.inspect" nil nil nil
                        "/home/hubbe/.config/emacs/snippets/elixir-ts-mode/piped IO.inspect"
                        nil nil)
                       ("iois" "IO.inspect($1, label: \"$2\")\n"
                        "IO.inspect() with label" nil nil nil
                        "/home/hubbe/.config/emacs/snippets/elixir-ts-mode/iois"
                        nil nil)
                       ("def" "def $1($2) do\n  $0\nend" "def" nil nil
                        nil
                        "/home/hubbe/.config/emacs/snippets/elixir-ts-mode/def"
                        nil nil)))


;;; Do not edit! File generated at Sat Mar 29 21:33:55 2025
