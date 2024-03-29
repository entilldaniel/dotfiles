(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(setq load-prefer-newer t)
(setq user-full-name "Daniel Figueroa")
(setq use-short-answers t)

(defun display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'display-startup-time)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  (auto-package-update-delete-old-versions t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "11:59"))

(use-package no-littering)
(setq custom-file (expand-file-name "custom.el" "~/.config/emacs/"))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(delete-selection-mode t)
(transient-mark-mode t)
(show-paren-mode 1)
(window-divider-mode)
(column-number-mode t)
(size-indication-mode t)
(blink-cursor-mode -1)
(global-display-line-numbers-mode t)
(setq-default cursor-type 'box)
(setq next-line-add-newlines t)
(recentf-mode 1)
(set-default 'truncate-lines 1)
(setq history-length 25)
(savehist-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers 1)
(setq use-dialog-box nil)
(setq kill-whole-line t)
(setq next-line-add-newlines t)
(setq next-screen-context-lines 10)
(line-number-mode t)
(dolist (mode '(org-mode-hook
                treemacs-mode-hook
                term-mode-hook
                eshell-mode-hook
                eat-mode-hook
                markdown-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))

(setq initial-scratch-message (concat
                               ";;; Emacs started: "
                               (format-time-string "%Y-%m-%d - %H:%m")
                               "\n;;; Happy Hacking!"))

(setq ring-bell-function 'ignore)
(setq x-select-enable-clipboard t)
(setq inhibit-startup-screen t)
(setq confirm-kill-emacs 'y-or-n-p)
(setq dired-dwim-target t)
(setq delete-by-moving-to-thrash t)
(setq global-auto-revert-non-file-buffers t)
(make-directory "~/.emacs_backups/" t)
(make-directory "~/.emacs_autosave/" t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs_autosave/" t)))
(setq backup-directory-alist '(("." . "~/.emacs_backups")))
(setq proced-enable-color-flag t)
(setq create-lockfiles nil)

;; Emacs 29 specific
(repeat-mode)

;; Disable warnings for native comp
(setq native-comp-async-report-warnings-errors nil)
(use-package page-break-lines)

(use-package dimmer
  :config
  (setq dimmer-adjustment-mode :foreground)
  (setq dimmer-fraction 0.5)
  (dimmer-configure-which-key))
(dimmer-mode)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-x p") 'proced)
(global-set-key (kbd "C-x r m") 'counsel-bookmark)
(global-unset-key (kbd "C-z"))

(defun close-frame-p ()
  (interactive)
  (if (yes-or-no-p "Close Frame?") 
      (delete-frame)))
(if (daemonp)
    (global-set-key (kbd "C-x C-c") 'close-frame-p))

(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))
(set-frame-parameter nil 'internal-border-width 0)

(use-package spacious-padding
  :custom
  (setq spacious-padding-subtle-mode-line t)
  :config
  (spacious-padding-mode 1))

(setq dired-listing-switches "-alh")
(setq dired-kill-when-opening-new-dired-buffer t)

(use-package dired-open
  :config
  (setq dired-open-extensions '(("mp4" . "vlc"))))

(use-package all-the-icons)
(use-package all-the-icons-dired
  :config (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(use-package doom-themes
  :init (load-theme 'doom-monokai-pro t))
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

(cond ((equal (system-name) "endive") (add-to-list 'default-frame-alist '(font . "Hack Nerd Font 20")))
      ((equal (system-name) "archie") (add-to-list 'default-frame-alist '(font . "Hack Nerd Font 14")))
      ((equal "" "") (add-to-list 'default-frame-alist '(font . "Hack Nerd Font 14"))))

(dolist (char/ligature-re
         `((?-  . ,(rx (or (or "-->" "-<<" "->>" "-|" "-~" "-<" "->") (+ "-"))))
           (?/  . ,(rx (or (or "/==" "/=" "/>" "/**" "/*") (+ "/"))))
           (?*  . ,(rx (or (or "*>" "*/") (+ "*"))))
           (?<  . ,(rx (or (or "<<=" "<<-" "<|||" "<==>" "<!--" "<=>" "<||" "<|>" "<-<"
                               "<==" "<=<" "<-|" "<~>" "<=|" "<~~" "<$>" "<+>" "</>"
                               "<*>" "<->" "<=" "<|" "<:" "<>"  "<$" "<-" "<~" "<+"
                               "</" "<*")
                           (+ "<"))))
           (?:  . ,(rx (or (or ":?>" "::=" ":>" ":<" ":?" ":=") (+ ":"))))
           (?=  . ,(rx (or (or "=>>" "==>" "=/=" "=!=" "=>" "=:=") (+ "="))))
           (?!  . ,(rx (or (or "!==" "!=") (+ "!"))))
           (?>  . ,(rx (or (or ">>-" ">>=" ">=>" ">]" ">:" ">-" ">=") (+ ">"))))
           (?&  . ,(rx (+ "&")))
           (?|  . ,(rx (or (or "|->" "|||>" "||>" "|=>" "||-" "||=" "|-" "|>"
                               "|]" "|}" "|=")
                           (+ "|"))))
           (?.  . ,(rx (or (or ".?" ".=" ".-" "..<") (+ "."))))
           (?+  . ,(rx (or "+>" (+ "+"))))
           (?\[ . ,(rx (or "[<" "[|")))
           (?\{ . ,(rx "{|"))
           (?\? . ,(rx (or (or "?." "?=" "?:") (+ "?"))))
           (?#  . ,(rx (or (or "#_(" "#[" "#{" "#=" "#!" "#:" "#_" "#?" "#(")
                           (+ "#"))))
           (?\; . ,(rx (+ ";")))
           (?_  . ,(rx (or "_|_" "__")))
           (?~  . ,(rx (or "~~>" "~~" "~>" "~-" "~@")))
           (?$  . ,(rx "$>"))
           (?^  . ,(rx "^="))
           (?\] . ,(rx "]#"))))
  (let ((char (car char/ligature-re))
        (ligature-re (cdr char/ligature-re)))
    (set-char-table-range composition-function-table char
                          `([,ligature-re 0 font-shape-gstring]))))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c a" . mc/mark-all-like-this)))

(use-package windmove
  :config
  (windmove-default-keybindings 'ctrl))

(use-package ace-window
  :bind
  (("M-o" . ace-window)))

;; Make it so keyboard-escape-quit doesn't delete-other-windows
(require 'cl-lib)
(defadvice keyboard-escape-quit
    (around keyboard-escape-quit-dont-delete-other-windows activate)
  (cl-letf (((symbol-function 'delete-other-windows)
             (lambda () nil)))
    ad-do-it))

(use-package move-text
  :bind (("M-<up>" . move-text-up)
         ("M-<down>" . move-text-down)))

(use-package treemacs)
(doom-themes-treemacs-config)
(use-package treemacs-projectile
  :after (treemacs projectile))
(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))
(use-package treemacs-magit
  :after (treemacs magit))

(global-set-key (kbd "C-c t") 'treemacs)
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))
(add-hook 'pdf-view-mode-hook (lambda() (display-line-numbers-mode -1)))

(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))
(global-set-key (kbd "<f2>") 'hydra-text-scale/body)

(use-package perspective
  :bind
  (("C-x C-b" . persp-list-buffers)
   ("C-x k" . persp-kill-buffer*))
  :custom
  (persp-mode-prefix-key (kbd "C-x x"))
  :init
  (persp-mode))

(use-package diminish)

(use-package hl-line
  :config (global-hl-line-mode))

(use-package command-log-mode
  :commands command-log-mode)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package kubel
  :config
  (setq kubel-log-tail-n 250))

(use-package proced)

(use-package mastodon
  :config
  (setq mastodon-instance-url "https://emacs.ch")
  (setq mastodon-active-user "entilldaniel"))

(defun my-yank ()
  "I want to access the most recent kill when I cut and paste"
  (interactive)
  (counsel-yank-pop 0))

(use-package swiper)
(setq kill-do-not-save-duplicates t)
(use-package counsel
  :bind(("M-x" . counsel-M-x)
        ("C-x b" . persp-counsel-switch-buffer)
        ("C-x C-f" . counsel-find-file)
        ("C-y" . my-yank)
        ("C-s" . swiper)
        :map minibuffer-local-map
        ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package ivy
  :diminish
  :config
  (ivy-mode t)
  (setq ivy-use-virtual-buffers t)
  (setq enabe-recursive-minibuffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-re-builders-alist
        '((ivy-switch-buffer . ivy--regex-plus)
          (t . ivy--regex-fuzzy)))
  (setq ivy-magic-slash-non-match-action nil)
  (setq ivy-format-function 'ivy-format-function-line))

(use-package ivy-prescient
  :after counsel
  :config
  (setq prescient-sort-length nil)
  (ivy-prescient-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package ivy-hydra)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(global-set-key (kbd "M-p") 'completion-at-point)

(use-package counsel-spotify)
(setq counsel-spotfiy-client-id "590302fb731a455cb820da4b5aa0b250")
(setq counsel-spotify-client-secret "78f30e787321411ca670a25f19d34e0f")

(use-package markdown-mode
  :hook
  (markdown-mode . nb/markdown-unhighlight)
  :config
  (defvar nb/current-line '(0 . 0)
    "(start . end) of current line in current buffer")
  (make-variable-buffer-local 'nb/current-line)

  (defun nb/unhide-current-line (limit)
    "Font-lock function"
    (let ((start (max (point) (car nb/current-line)))
          (end (min limit (cdr nb/current-line))))
      (when (< start end)
        (remove-text-properties start end
                                '(invisible t display "" composition ""))
        (goto-char limit)
        t)))

  (defun nb/refontify-on-linemove ()
    "Post-command-hook"
    (let* ((start (line-beginning-position))
           (end (line-beginning-position 2))
           (needs-update (not (equal start (car nb/current-line)))))
      (setq nb/current-line (cons start end))
      (when needs-update
        (font-lock-fontify-block 3))))

  (defun nb/markdown-unhighlight ()
    "Enable markdown concealling"
    (interactive)
    (markdown-toggle-markup-hiding 'toggle)
    (font-lock-add-keywords nil '((nb/unhide-current-line)) t)
    (add-hook 'post-command-hook #'nb/refontify-on-linemove nil t))
  :custom-face
  (markdown-header-delimiter-face ((t (:foreground "#616161" :height 0.9))))
  (markdown-header-face-1 ((t (:height 1.6  :foreground "#A3BE8C" :weight extra-bold :inherit markdown-header-face))))
  (markdown-header-face-2 ((t (:height 1.4  :foreground "#EBCB8B" :weight extra-bold :inherit markdown-header-face))))
  (markdown-header-face-3 ((t (:height 1.2  :foreground "#D08770" :weight extra-bold :inherit markdown-header-face))))
  (markdown-header-face-4 ((t (:height 1.15 :foreground "#BF616A" :weight bold :inherit markdown-header-face))))
  (markdown-header-face-5 ((t (:height 1.1  :foreground "#b48ead" :weight bold :inherit markdown-header-face))))
  (markdown-header-face-6 ((t (:height 1.05 :foreground "#5e81ac" :weight semi-bold :inherit markdown-header-face))))
  :hook
  (markdown-mode . abbrev-mode))

(defun org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode)
  (visual-line-mode))


(defun org-font-setup ()
  ;; replace list hyphen with dot"
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\)"
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

;; (use-package org
;;   :hook (org-mode . org-mode-setup)
;;   :config
;;   (setq org-ellipsis " ▾")
;;   (org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun org-mode-visual-fill ()
  (setq visual-fill-column-width 120
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . org-mode-visual-fill))

(use-package org-journal
  :ensure t
  :defer t
  :init
  ;; Change default prefix key; needs to be set before loading org-journal
  (setq org-journal-prefix-key "C-c j ")
  :config
  (setq org-journal-dir "~/Documents/org/journal/"
        org-journal-date-format "%A, %d %B %Y"))

(setq calendar-week-start-day 1)
(setq org-agenda-files (list "~/Documents/org/todo.org"
                             "~/Documents/org/work.org"
                             "~/Documents/org/ideas.org"
                             "~/Documents/org/archive.org"))

(setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 9)))
(setq org-outline-path-complete-in-steps nil)  ;; Refile in a single go
(setq org-refile-use-outline-path t)           ;; Show full paths for refiling
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/Documents/org/todo.org" "Tasks")
         "* TODO %?\n %i\n")
        ("i" "IDEA" entry (file+headline "~/Documents/org/ideas.org" "Ideas")
         "* IDEA: %?\n %i\n")
        ("n" "NOTE" entry (file+headline "~/Documents/org/ideas.org" "Notes")
         "* %?\n %i\n")
        ("o" "OBSIDIAN ENTRY" entry (file+headline "~/Documents/org/obsidian.org" "Obisidan Entries")
         "* OBSIDIAN: %?\n %i\n")))

(add-hook 'org-capture-mode-hook 'delete-other-windows)
(global-set-key (kbd "C-c c") 'org-capture)

(defun myfuns/start-presentation ()
  (interactive)
  (org-present-big)
  (org-display-inline-images)
  (org-present-hide-cursor)
  (org-present-read-only))

(defun myfuns/end-presentation ()
  (interactive)
  (org-present-small)
  (org-remove-inline-images)
  (org-present-show-cursor)
  (org-present-read-write))

(use-package org-present)
(add-hook 'org-present-mode-hook 'myfuns/start-presentation)
(add-hook 'org-present-mode-quit-hook 'myfuns/end-presentation)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("b"   . "src bash"))
(add-to-list 'org-structure-template-alist '("py"  . "src python"))
(add-to-list 'org-structure-template-alist '("exs" . "src elixir"))
(add-to-list 'org-structure-template-alist '("el"  . "src emacs-lisp"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (elixir . t)
   (python . t)))

(setq org-confirm-babel-evaluate nil)

(defun org-babel-tangle-config ()
  (when (eq (string-match "/home/.*/.dotfiles/.*.org" (buffer-file-name)) 0)
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'org-babel-tangle-config)))

(defun configure-eshell ()
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt)
(use-package eshell
  :hook (eshell-first-time-mode . configure-eshell)
  :config
  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh"))))

(use-package exec-path-from-shell
  :config
  (when (daemonp)
    (exec-path-from-shell-initialize)))

(use-package vterm
:commands vterm
:config
(setq vterm-shell "zsh")
(setq vterm-max-scrollback 10000))


(use-package multi-vterm)

(use-package restclient)

(use-package yasnippet)
(yas-global-mode 1)

(use-package flycheck)

(use-package docker
  :bind ("C-c d" . docker))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  (setq projectile-project-search-path '("~/Projects"))
  (setq projectile-switch-project-action #'projectile-dired)
  (setq projectile-create-missing-test-files t))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :diminish lsp-mode
  :config
  (lsp-enable-which-key-integration)
  :custom
  ;;Rust config
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :bind
  (("C-<f8>" . dap-breakpoint-toggle))
  :config
  (lsp-enable-which-key-integration))


(use-package lsp-treemacs
  :config
  (setq lsp-treemacs-sync-mode 1)
  :after lsp)

(use-package lsp-ivy)
(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable t))

(use-package lsp-origami
  :bind
  (("C-c q" . origami-toggle-node))
  :hook
  ((lsp-after-open . lsp-origami-try-enable))
  :config
  (setq lsp-enable-folding t))

(use-package lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t))


(use-package dap-mode
  :after lsp-mode
  :commands dap-debug
  :hook ((elixir-mode . dap-ui-mode) (elixir-mode . dap-mode))
  :config
  (require 'dap-elixir)
  (setq dap-auto-configure-features '(sessions locals controls tooltip)) 
  (add-hook 'dap-stopped-hook
	    (lambda (arg) (call-interactively #'dap-hydra))))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(use-package emmet-mode
  :bind ("M-/" . emmet-expand-line))

(use-package yaml-mode)
(use-package toml-mode)
(use-package markdown-mode)

(use-package ob-elixir)
  (use-package elixir-mode
    :init
    (add-to-list 'exec-path "/home/hubbe/.config/emacs/var/lsp/server/elixir-ls")
    :hook ((elixir-mode . lsp-deferred)
           (before-save-hook . elixir-format))
    :config
    (require 'dap-elixir))

  (use-package mix)
(use-package ob-elixir)
(use-package elixir-mode
  :init
  (add-to-list 'exec-path "/home/hubbe/.config/emacs/var/lsp/server/elixir-ls")
  :hook ((elixir-mode . lsp-deferred)
         (before-save-hook . elixir-format))
  :config
  (require 'dap-elixir))

(use-package mix)
(use-package exunit
  :diminish t
  :bind
  ("C-c e ." . exunit-verify-single)
  ("C-c e b" . exunit-verify)
  ("C-c e u a" . exunit-verify-all-in-umbrella)
  ("C-c e a" . exunit-verify-all)
  ("C-c e l" . exunit-rerun))

(defun dap-elixir--populate-start-file-args (conf)
  "Populate CONF with the required arguments."
  (-> conf
      (dap--put-if-absent :dap-server-path '("debugger.sh"))
      (dap--put-if-absent :type "Elixir")
      (dap--put-if-absent :name "mix test")
      (dap--put-if-absent :request "launch")
      (dap--put-if-absent :task "test")
      (dap--put-if-absent :projectDir (lsp-find-session-folder (lsp-session) (buffer-file-name)))
      (dap--put-if-absent :cwd (lsp-find-session-folder (lsp-session) (buffer-file-name)))))

;;   (dap-register-debug-template
;;    "Elixir::Elixir Application"
;;    (list :type "Elixir"
;;          :program nil
;;          :dap-server-path '("/home/hubbe/.config/emacs/var/lsp/server/elixir-ls/debugger.sh")
;;          :projectDir "/home/hubbe/Projects/elixir/gen_chat"
;;          :cwd "/home/hubbe/Projects/elixir/gen_chat"
;;          :name "gen chat"))

;;   (dap-register-debug-template
;;    "Elixir::Blog"
;;    (list :type "Elixir"
;;          :task "phx.server"
;;          :dap-server-path '("/home/hubbe/.config/emacs/var/lsp/server/elixir-ls/debugger.sh")
;;          :projectDir "/home/hubbe/Projects/elixir/blog"
;;          :cwd "/home/hubbe/Projects/elixir/blog"
;;          :name "phoenix blog"))

;; (dap-register-debug-template
;;    "Elixir::Pento"
;;    (list :type "Elixir"
;;          :task "phx.server"
;;          :dap-server-path '("/home/hubbe/.config/emacs/var/lsp/server/elixir-ls/debugger.sh")
;;          :projectDir "/home/hubbe/Projects/elixir/pento"
;;          :cwd "/home/hubbe/Projects/elixir/pento"
;;          :name "phoenix pento"))

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode . paredit-mode)
         (ielm-mode . paredit-mode)
         (lisp-mode . paredit-mode)
         (clojure-mode . paredit-mode)
         (eval-expression-minibuffer . paredit-mode)))



(use-package rustic
  :hook (rustic-mode . lsp-deferred)
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)))

(use-package elpy
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-virtualenv-path "~/.config/emacs/pyenv"))

(use-package python-mode
  :hook ((python-mode . lsp-deferred)))

(defun epoch-to-string (epoch)
  (interactive "insert epoch")
  (message (format-time-string
            "%Y-%m-%d %H:%M:%S"
            (seconds-to-time (string-to-number
                              (buffer-substring-no-properties (region-beginning) (region-end))
                              )))))

(defun insert-current-date ()
  (interactive)
  (insert
   (format-time-string "%Y-%m-%d")))

(load-file "~/.config/emacs/custom.el")

(defun list-all-fonts ()
  (interactive)
  (get-buffer-create "fonts")
  (switch-to-buffer "fonts")
  (dolist (font (x-list-fonts "*"))
    (insert (format "%s\n" font)))
  (beginning-of-buffer))
