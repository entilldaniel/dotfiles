;; -*- lexical-binding: t -*-

(setq gc-cons-threshold 100000000
  read-process-output-max (* 1024 1024)
  load-prefer-newer t
  user-full-name "Daniel Figueroa"
  use-short-answers t)

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
(recentf-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)
(line-number-mode t)
(repeat-mode)
(electric-indent-mode -1)

(setq-default cursor-type 'box)

(setq next-line-add-newlines t
      history-length 25
      global-auto-revert-non-file-buffers 1
      use-dialog-box nil
      kill-whole-line t
      next-screen-context-lines 10
      kill-do-not-save-duplicates t)

(dolist (mode '(org-mode-hook
                treemacs-mode-hook
                term-mode-hook
                eshell-mode-hook
                markdown-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))

(setq initial-scratch-message (concat
                               ";;; Emacs started: "
                               (format-time-string "%Y-%m-%d - %H:%m")
                               "\n;;; Happy Hacking!\n"))

(setq ring-bell-function 'ignore
      x-select-enable-clipboard t
      inhibit-startup-screen t
      confirm-kill-emacs 'y-or-n-p
      dired-dwim-target t
      delete-by-moving-to-thrash t
      global-auto-revert-non-file-buffers t
      auto-save-file-name-transforms '((".*" "~/.emacs_autosave/" t))
      backup-directory-alist '(("." . "~/.emacs_backups"))
      proced-enable-color-flag t
      create-lockfiles nil)
(make-directory "~/.emacs_backups/" t)
(make-directory "~/.emacs_autosave/" t)

;; Disable warnings for native comp
(setq native-comp-async-report-warnings-errors nil)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-unset-key (kbd "C-z"))

(defun close-frame-p ()
  (interactive)
  (if (yes-or-no-p "Close Frame?") 
      (delete-frame)))
(if (daemonp)
    (global-set-key (kbd "C-x C-c") 'close-frame-p))

(setq scroll-step 1
      scroll-conservatively 10000
      auto-window-vscroll nil)

(setq dired-listing-switches "-alh"
      dired-kill-when-opening-new-dired-buffer t)

(use-package dired-open
  :config
  (setq dired-open-extensions '(("mp4" . "vlc"))))

(use-package all-the-icons)
(use-package all-the-icons-dired
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(use-package modus-themes
  :config
  (setq modus-themes-region '(accented)
        modus-themes-mode-line '(accented borderless)
        modus-themes-org-blocks 'tinted-background
        modus-themes-paren-match '(bold intense)
        modus-themes-prompts '(light)
        modus-themes-syntax '(faint)
        modus-themes-completions
        '((matches . (extrabold))
          (selection . (italic)))
        modus-themes-headings
        '((1 . (rainbow overline background 1.4))
          (2 . (rainbow background 1.3))
          (3 . (rainbow bold 1.2))
          (t . (semilight 1.1)))
        modus-themes-common-palette-overrides
        '((border-mode-line-active bg-mode-line-active)
          (border-mode-line-inactive bg-mode-line-inactive)
          (modus-themes-preset-overrides-faint))
        modus-themes-scale-headings t))

(defun my-modus-themes-invisible-dividers (&rest _)
  "Make window dividers invisible.
    Add this to the `modus-themes-post-load-hook'."
  (let ((bg (face-background 'default)))
    (custom-set-faces
     `(fringe ((t :background ,bg :foreground ,bg)))
     `(window-divider ((t :background ,bg :foreground ,bg)))
     `(window-divider-first-pixel ((t :background ,bg :foreground ,bg)))
     `(window-divider-last-pixel ((t :background ,bg :foreground ,bg))))))

(defun my-modus-themes-custom-faces (&rest _)
  (modus-themes-with-colors
    (custom-set-faces
     ;; Add "padding" to the mode lines
     `(mode-line ((,c :underline ,border-mode-line-active
                      :overline ,border-mode-line-active
                      :box (:line-width 5 :color ,bg-mode-line-active))))
     `(mode-line-inactive ((,c :underline ,border-mode-line-inactive
                               :overline ,border-mode-line-inactive
                               :box (:line-width 5 :color ,bg-mode-line-inactive)))))))

;; ESSENTIAL to make the underline move to the bottom of the box:
(setq x-underline-at-descent-line t)

(add-hook 'modus-themes-after-load-theme-hook #'my-modus-themes-custom-faces)
;;(add-hook 'modus-themes-after-load-theme-hook #'my-modus-themes-invisible-dividers)

(load-theme 'modus-vivendi-tinted t)

(use-package spacious-padding
  :config
  (setq spacious-padding-subtle-mode-line
        `( :mode-line-active 'default
           :mode-line-inactive vertical-border))
  :init
  (spacious-padding-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

(use-package smart-mode-line
  :config
  (sml/setup)
  (setq sml/theme 'respectful
        sml/no-confirm-load-theme t))

(use-package fontaine
  :config
  (setq fontaine-presets
	'((tight
	   :default-family "FiraCode Nerd Font Mono"
	   :default-height 110
	   :fixed-pitch-family "FiraCode Nerd Font Mono"
	   :variable-pitch-family "Iosevka"
	   :italic-family "FiraCode Nerd Font Mono"
	   :line-spacing 1)
      (regular
	   :default-family "FiraCode Nerd Font Mono"
	   :default-height 140
	   :fixed-pitch-family "FiraCode Nerd Font Mono"
	   :variable-pitch-family "Iosevka"
	   :italic-family "FiraCode Nerd Font Mono"
	   :line-spacing 1)
	  (large
	   :default-family "FiraCode Nerd Font Mono"
	   :default-height 180
	   :fixed-pitch-family "FiraCode Nerd Font Mono"
	   :variable-pitch-family "Iosevka"
	   :italic-family "FiraCode Nerd Font Mono"
	   :line-spacing 1))))

(cond ((equal (system-name) "endive") (fontaine-set-preset 'large))
	  ((equal (system-name) "archie") (fontaine-set-preset 'regular))
      ((equal (system-name) "slartibartfast") (fontaine-set-preset 'tight))
	  ((equal "" "") (fontaine-set-preset 'regular)))

(use-package ligature
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(use-package page-break-lines
  :init
  (global-page-break-lines-mode))

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

(use-package treemacs
  :bind
  (("C-c t" . treemacs)))
(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))
(use-package treemacs-magit
  :after (treemacs magit))

(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))
(add-hook 'pdf-view-mode-hook (lambda() (display-line-numbers-mode -1)))

(transient-define-prefix transient-scale-text ()
  "Scale Text in or out"
  ["Actions"
   ("j" "Increase scale" text-scale-increase :transient t)
   ("k" "Decrease scale" text-scale-decrease :transient t)])

(global-set-key (kbd "<f2>") 'transient-scale-text)

(use-package perspective
  :bind
  (("C-x C-b" . persp-buffer-menu)
   ("C-x b"   . persp-switch-to-buffer*)
   ("C-x k"   . persp-kill-buffer*))
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
  (setq which-key-idle-delay 0.5))

(use-package undo-tree
  :config (global-undo-tree-mode))

(use-package vertico
  :init
  (vertico-mode)
  :config
  (setq vertico-resize -1)
  (setq vertico-count 15)
  (setq vertico-cycle t))

(use-package consult
  :bind
  (("C-s"     . consult-line)
   ("C-x b"   . consult-buffer)
   ("C-x r m" . consult-bookmark)
   ("C-y"     . consult-yank-pop)))

(use-package consult-project-extra
  :bind
  (("C-x p f" . consult-project-extra-find)))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match t)        ;; Never quit, even if there is no match
  (corfu-preview-current t)      ;; Disable current candidate preview
  (corfu-preselect 'prompt)      ;; Preselect the prompt
  (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (corfu-scroll-margin 5)        ;; Use scroll margin
  ;; Enable Corfu only for certain modes.
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode))

(use-package embark
  :bind
  (("C-," . embark-act)
   ("C-." . embark-cycle))
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package kubel
  :config
  (setq kubel-log-tail-n 250))

(use-package proced)

(use-package mastodon
  :config
  (setq mastodon-instance-url "https://emacs.ch")
  (setq mastodon-active-user "entilldaniel"))

(use-package consult-spotify
  :config
  (setq espotfiy-client-id "590302fb731a455cb820da4b5aa0b250"
        espotify-client-secret "78f30e787321411ca670a25f19d34e0f"))

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

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun org-mode-visual-fill ()
  (setq visual-fill-column-width 140
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
                             "~/Documents/org/inbox.org"
                             "~/Documents/org/work.org"
                             "~/Documents/org/ideas.org"
                             "~/Documents/org/archive.org"))

(setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 9)))
(setq org-outline-path-complete-in-steps nil)  ;; Refile in a single go
(setq org-refile-use-outline-path t)           ;; Show full paths for refiling
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(defun df/project-notes-path ()
  "uses project.el project name to get the current path of the project"
  (let ((path (concat (project-root (project-current)) "notes.org")))
    (find-file path)
    (unless (org-find-exact-headline-in-buffer "Notes")
      (org-insert-heading nil nil t)
      (insert "Notes"))))

(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/Documents/org/todo.org" "Tasks")
         "* TODO %?\n %i\n")
        ("b" "INBOX" entry (file+headline "~/Documents/org/inbox.org" "Tasks")
         "**  %?\n %i\n")
        ("i" "IDEA" entry (file+headline "~/Documents/org/ideas.org" "Ideas")
         "** IDEA: %?\n %i\n")
        ("n" "NOTE" entry (file+headline "~/Documents/org/ideas.org" "Notes")
         "** %?\n %i\n")
        ("p" "NOTE" entry (function df/project-notes-path)
         "** NOTE: %?\n %i\n")
        ("o" "OBSIDIAN ENTRY" entry (file+headline "~/Documents/org/obsidian.org" "Obisidan Entries")
         "** ENTRY: %?\n %i\n")))

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
(add-to-list 'org-structure-template-alist '("sql" . "src sql"))
(add-to-list 'org-structure-template-alist '("el"  . "src emacs-lisp"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (elixir . t)
   (python . t)
   (sql . t)))

(setq org-confirm-babel-evaluate nil)

(defun org-babel-tangle-config ()
  (when (eq (string-match "/home/.*/.dotfiles/.*.org" (buffer-file-name)) 0)
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'org-babel-tangle-config)))

(defun configure-eshell ()
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (setq eshell-history-size         300
        eshell-buffer-maximum-lines 300
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
  (setq exec-path-from-shell-arguments '("-l" "-i"))
  (when (daemonp)
    (exec-path-from-shell-initialize)))

(use-package vterm
:commands vterm
:config
(setq vterm-shell "zsh")
(setq vterm-max-scrollback 5000))

(use-package multi-vterm)

(use-package restclient)
(use-package yasnippet
  :init
  (yas-global-mode 1)
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/snippets" "~/.dotfiles/snippets")))
(use-package flycheck)
(use-package docker)
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package eglot
  :ensure nil
  :defer t
  :hook ((elixir-mode . eglot-ensure)
         (rust-mode . eglot-ensure))
  :config
  (add-to-list
   'eglot-server-programs '(elixir-ts-mode "~/.local/opt/elixir_ls/language_server.sh"))
  (setq eglot-autoshutdown 1))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(setq treesit-language-source-alist
      '((heex       "https://github.com/phoenixframework/tree-sitter-heex")
        (elixir     "https://github.com/elixir-lang/tree-sitter-elixir")
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")))

(setq major-mode-remap-alist
      '((elixir-mode . elixir-ts-mode)
        (rust-mode . rust-ts-mode)))

(use-package emmet-mode
  :bind ("M-/" . emmet-expand-line))

(use-package yaml-mode)
(use-package toml-mode)
(use-package markdown-mode)

(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t))

  (use-package cargo
    :hook (rust-mode . cargo-minor-mode))

(add-to-list 'auto-mode-alist '("/Dockerfile\\'" . dockerfile-ts-mode))

(use-package mix)
(use-package ob-elixir)
(use-package elixir-ts-mode
  :hook (elixir-ts-mode . eglot-ensure)
  (elixir-ts-mode . mix-minor-mode)
  (elixir-ts-mode
   .
   (lambda ()
     (push '(">=" . ?\u2265) prettify-symbols-alist)
     (push '("<=" . ?\u2264) prettify-symbols-alist)
     (push '("!=" . ?\u2260) prettify-symbols-alist)
     (push '("==" . ?\u2A75) prettify-symbols-alist)
     (push '("=~" . ?\u2245) prettify-symbols-alist)
     (push '("<-" . ?\u2190) prettify-symbols-alist)
     (push '("->" . ?\u2192) prettify-symbols-alist)
     (push '("<-" . ?\u2190) prettify-symbols-alist)
     (push '("|>" . ?\u25B7) prettify-symbols-alist)))
     (before-save . eglot-format))

(use-package exunit
  :diminish t
  :bind
  ("C-c e ." . exunit-verify-single)
  ("C-c e b" . exunit-verify)
  ("C-c e u a" . exunit-verify-all-in-umbrella)
  ("C-c e a" . exunit-verify-all)
  ("C-c e l" . exunit-rerun))

(use-package flymake-easy)
(use-package flymake-elixir
  :hook (elixir-ts-mode . flymake-elixir-load))

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode . paredit-mode)
         (ielm-mode . paredit-mode)
         (lisp-mode . paredit-mode)
         (clojure-mode . paredit-mode)
         (eval-expression-minibuffer . paredit-mode)))

;; Someday

(use-package elpy
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-virtualenv-path "~/.config/emacs/pyenv"))

(use-package python-mode)

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

(defun list-all-fonts ()
  (interactive)
  (get-buffer-create "fonts")
  (switch-to-buffer "fonts")
  (dolist (font (x-list-fonts "*"))
    (insert (format "%s\n" font)))
  (beginning-of-buffer))
