(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(require 'package)
(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)

(use-package auto-package-update
:config
(auto-package-update-maybe)
:ensure t)

(menu-bar-mode -1) 
(tool-bar-mode -1) 
(scroll-bar-mode -1) 
(setq-default frame-title-format nil)
(setq frame-resize-pixelwise nil)

(save-place-mode 1)
(setq desktop-load-locked-desktop nil)

;; (setq desktop-save t)
;; ;; (setq desktop-path '("~/.emacs.d/desktop/")) 
;; (setq desktop-restore-frames t)
;; (desktop-save-mode 1)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(savehist-mode 1)

(use-package beacon
:ensure t)
(beacon-mode 1)

(setq visible-bell t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(set-default 'truncate-lines t)

(setq package-install-upgrade-built-in t)

(setq pixel-scroll-precision-mode t)

(use-package super-save
  :config
  (super-save-mode +1))
(setq super-save-auto-save-when-idle t)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(use-package which-key
    :config
    (which-key-mode))

(use-package general
  :config
  (general-evil-setup t))

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'visual)
;; (add-to-list 'focus-in-hook (lambda () (setq display-line-numbers-type 'visual)))
;; (add-to-list 'focus-out-hook (lambda () (setq display-line-numbers-type t)))

;; (add-hook 'focus-in-hook (lambda () (message "Emacs is gainging focus...")))
;; (add-hook 'focus-out-hook (lambda () (message "Emacs is losing focus...")))

(use-package all-the-icons
  :if (display-graphic-p))

;; (all-the-icons-install-fonts)

(setq flymake-no-changes-timeout 0.1)

(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; (add-hook 'org-mode-hook 'org-indent-mode)
;; (setq org-startup-indented t)

(setq org-src-preserve-indentation nil
      org-src-tab-acts-natively t
      org-hide-emphasis-markers t
      org-agenda-tags-column 0
      org-pretty-entities t
      org-ellipsis "…"
      org-edit-src-content-indentation 2
      org-catch-invisible-edits 'show-and-error)

(use-package org-modern)
(setq org-modern-hide-stars t
      org-modern-star 'replace)
(global-org-modern-mode)

;; (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
;; (custom-set-variables '(org-modern-table nil))

(setq org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-confirm-babel-evaluate nil)

(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-tempo
  :ensure nil)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("ha" . "src haskell"))

(general-nmap
  "<leader>t" 'org-babel-tangle)

;; (setq org-startup-numerated t)

(setq org-startup-with-inline-images t)

(use-package restart-emacs)
(general-nmap
  "<leader>re" '(lambda ()
		  (interactive)
		  (save-some-buffers t)
		  (org-babel-tangle)
		  (restart-emacs)))
(setq confirm-kill-processes nil)

(set-face-attribute 'default nil
                    :family "Fira Code" 
                    :height 130
                    :weight 'medium)
(set-face-attribute 'variable-pitch nil
                    :font "Ubuntu"
                    :height 130
                    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
                    :font "Fira Code"
                    :height 130
                    :weight 'medium)

(use-package ligature
  :load-path "path-to-ligature-repo"
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia and Fira Code ligatures in programming modes
  (ligature-set-ligatures '(prog-mode text-mode)
                          '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                            ;; =:= =!=
                            ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                            ;; ;; ;;;
                            (";" (rx (+ ";")))
                            ;; && &&&
                            ("&" (rx (+ "&")))
                            ;; !! !!! !. !: !!. != !== !~
                            ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                            ;; ?? ??? ?:  ?=  ?.
                            ("?" (rx (or ":" "=" "\." (+ "?"))))
                            ;; %% %%%
                            ("%" (rx (+ "%")))
                            ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                            ;; |->>-||-<<-| |- |== ||=||
                            ;; |==>>==<<==<=>==//==/=!==:===>
                            ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                            "-" "=" ))))
                            ;; \\ \\\ \/
                            ("\\" (rx (or "/" (+ "\\"))))
                            ;; ++ +++ ++++ +>
                            ("+" (rx (or ">" (+ "+"))))
                            ;; :: ::: :::: :> :< := :// ::=
                            (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                            ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                            ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                            "="))))
                            ;; .. ... .... .= .- .? ..= ..<
                            ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                            ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                            ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                            ;; *> */ *)  ** *** ****
                            ("*" (rx (or ">" "/" ")" (+ "*"))))
                            ;; www wwww
                            ("w" (rx (+ "w")))
                            ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                            ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                            ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                            ;; << <<< <<<<
                            ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                            "-"  "/" "|" "="))))
                            ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                            ;; >> >>> >>>>
                            (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                            ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                            ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                         (+ "#"))))
                            ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                            ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                            ;; __ ___ ____ _|_ __|____|_
                            ("_" (rx (+ (or "_" "|"))))
                            ;; Fira code: 0xFF 0x12
                            ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                            ;; Fira code:
                            "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                            ;; The few not covered by the regexps.
                            "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t)
  :ensure t)

(use-package doom-modeline
  :init (doom-modeline-mode 1))
;; (setq doom-modeline-minor-modes t)
(column-number-mode)

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(setq scroll-conservatively 101)

(setq mouse-wheel-scroll-amount '(3 ((shift) . 3)))

(setq mouse-wheel-progressive-speed t)

(setq mouse-wheel-follow-mouse 't)

(use-package bug-hunter)

(use-package undohist
  :config
  (undohist-initialize))

(use-package page-break-lines)
(global-page-break-lines-mode)

(use-package projectile
  :config
  (projectile-global-mode 1)
  :ensure t)
(setq projectile-enable-caching t)

(use-package neotree)
(setq-default neo-show-hidden-files t)
(setq neo-theme 'icons)
(setq neo-window-fixed-size nil)
(setq neo-window-width 27)

(setq neo-smart-open t)

(setq projectile-switch-project-action 'neotree-projectile-action)

(use-package dashboard
  :config
  (dashboard-setup-startup-hook))
(setq dashboard-projects-backend 'projectile)
(setq dashboard-items '((recents . 9)
                        (projects . 9)
                        (agenda . 9)
                        (bookmarks . 3)
                        (registers . 3)))
(setq dashboard-center-content t)
(setq dashboard-show-shortcuts nil)
(setq dashboard-icon-type 'all-the-icons) 
;; (setq dashboard-set-heading-icons t)
;; (setq dashboard-set-file-icons t)

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (evil-mode))
(evil-set-undo-system 'undo-redo)
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd ":") 'evil-repeat-find-char)
  (define-key evil-motion-state-map (kbd ";") 'evil-ex))

(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-goggles
  :config
  (evil-goggles-mode))
;; (evil-goggles-use-diff-faces)

(use-package evil-commentary
  :config
  (evil-commentary-mode))
(general-nmap
  "<leader>c" 'evil-commentary-line)
(general-vmap
  "<leader>c" 'evil-commentary)

(evil-set-leader nil (kbd "SPC"))

(evil-select-search-module 'evil-search-module 'evil-search)
(general-nmap
  "<leader>SPC" 'evil-ex-nohighlight)

(evil-define-key 'normal global-map (kbd "<up>") 'ignore)
(evil-define-key 'normal global-map (kbd "<down>") 'ignore)
(evil-define-key 'normal global-map (kbd "<left>") 'ignore)
(evil-define-key 'normal global-map (kbd "<right>") 'ignore)
(evil-define-key 'insert global-map (kbd "<up>") 'ignore)
(evil-define-key 'insert global-map (kbd "<down>") 'ignore)
(evil-define-key 'insert global-map (kbd "<left>") 'ignore)
(evil-define-key 'insert global-map (kbd "<right>") 'ignore)
(evil-define-key 'visual global-map (kbd "<up>") 'ignore)
(evil-define-key 'visual global-map (kbd "<down>") 'ignore)
(evil-define-key 'visual global-map (kbd "<left>") 'ignore)
(evil-define-key 'visual global-map (kbd "<right>") 'ignore)

(use-package gcmh
  :config
  (gcmh-mode 1))

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(setq gc-cons-threshold (* 2 1000 1000))

(add-hook
 'compilation-finish-functions
 'switch-to-buffer-other-window
 'compilation)

(setq compilation-scroll-output 'first-error)

(general-nmap compilation-mode-map
  "<escape>" '(lambda ()
		(interactive)
		(bury-buffer)
		(delete-window (get-buffer-window (get-buffer "*compilation*")))))

(setq compilation-auto-jump-to-first-error t)

(use-package magit)

(use-package haskell-mode)

(general-nmap haskell-mode-map
  "<f5>" '(lambda ()
            (interactive)
            (save-some-buffers t)
            (setq-local haskell-compile-cabal-build-command "cabal build")
            (haskell-compile)))

(general-nmap haskell-mode-map
  "<f7>" '(lambda ()
            (interactive)
            (save-some-buffers t)
            (setq-local haskell-compile-cabal-build-command "cabal test")
            (haskell-compile)))

(general-nmap haskell-mode-map
  "<f10>" '(lambda ()
             (interactive)
             (projectile-run-async-shell-command-in-root "kitty -e cabal run")))

(add-to-list 'display-buffer-alist
	     (cons "\\*Async Shell Command\\*.*" (cons #'display-buffer-no-window nil)))

;; (defun compilation-exit-autoclose (status code msg)
;;   (when (and (eq status 'exit) (zerop code))
;;     (bury-buffer)
;;     (delete-window (get-buffer-window (get-buffer "*compilation*"))))
;;   (cons msg code))
;; (setq compilation-exit-message-function 'compilation-exit-autoclose)

(use-package nix-mode
  :hook (nix-mode . lsp-deferred))

(use-package lsp-nix
  :ensure lsp-mode
  :after (lsp-mode)
  :demand t
  :custom
  (lsp-nix-nil-formatter ["nixpkgs-fmt"]))

;;(use-package parinfer-rust-mode
;;:hook emacs-lisp-mode
;;:init
;;(setq parinfer-rust-auto-download t))
;;(setq parinfer-rust-check-before-enable 'disabled)

(use-package
  elisp-autofmt
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :config (setq elisp-autofmt-on-save-p 'always)
  :hook (emacs-lisp-mode . elisp-autofmt-mode))

(use-package rust-mode)

(use-package yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package counsel)
(ivy-mode 1)

(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions.
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package yasnippet)
(yas-global-mode 1)
(use-package yasnippet-snippets)

(use-package company)
(add-hook 'after-init-hook 'global-company-mode)
(use-package company-cabal)
(add-to-list 'company-backends 'company-cabal)

(use-package company-box
  :hook (company-mode . company-box-mode))

(add-hook 'prog-mode-hook 'eglot-ensure)
(add-hook 'gfm-mode-hook 'eglot-ensure)
(add-hook 'yaml-mode-hook 'eglot-ensure)
(setq eglot-confirm-server-initiated-edits nil)

(general-nmap "<leader>d" 'xref-find-definitions)
(general-nmap "<leader>f" 'eglot-format-buffer)
(general-nmap "<leader>a" 'eglot-code-actions)
(general-nmap "<leader>h" 'eldoc-doc-buffer)
;; (general-nmap "<leader>r" 'eglot-rename)

(use-package git-auto-commit-mode)
(setq-default gac-automatically-push-p t)
(setq-default gac-automatically-add-new-files-p t)

(use-package git-modes)

(use-package emojify
  :hook 
  (after-init . global-emojify-mode))
(setq emojify-download-emojis-p t)

(xterm-mouse-mode 1)



(use-package flycheck-aspell)
(add-to-list 'flycheck-checkers 'tex-aspell-dynamic)
(add-to-list 'flycheck-checkers 'markdown-aspell-dynamic)
(add-to-list 'flycheck-checkers 'html-aspell-dynamic)
(add-to-list 'flycheck-checkers 'xml-aspell-dynamic)
(add-to-list 'flycheck-checkers 'nroff-aspell-dynamic)
(add-to-list 'flycheck-checkers 'texinfo-aspell-dynamic)
(add-to-list 'flycheck-checkers 'c-aspell-dynamic)
(add-to-list 'flycheck-checkers 'mail-aspell-dynamic)

(setq ispell-program-name "aspell")
;; I am not really if its needed at all.
;; (setq ispell-dictionary "en_US")
(setq ispell-silently-savep t)

(advice-add #'ispell-pdict-save :after #'flycheck-maybe-recheck)
(defun flycheck-maybe-recheck (_)
  (when (bound-and-true-p flycheck-mode)
    (flycheck-buffer)))

(use-package flyspell)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'flyspell-buffer)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
(add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_SRC" . "#\\+END_SRC"))

(defun my-save-word ()
  (interactive)
  (let ((current-location (point))
        (word (flyspell-get-word)))
    (when (consp word)    
      (flyspell-do-correct 'save nil (car word) current-location (cadr word) (caddr word) current-location))))

(general-nmap
  "zg" 'my-save-word)
(general-nmap
  "z=" 'flyspell-correct-word-before-point)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package dired
  :ensure nil)
(use-package all-the-icons-dired)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(use-package diff-hl)
(global-diff-hl-mode)

(diff-hl-dired-mode)
(diff-hl-margin-mode)
(diff-hl-flydiff-mode)

(defun my/org-mode/load-prettify-symbols ()
  (interactive)
  (setq prettify-symbols-alist
	'(("lambda" . ?λ)))
  (prettify-symbols-mode 1))
(add-hook 'org-mode-hook 'my/org-mode/load-prettify-symbols)

(use-package aggressive-indent)
(global-aggressive-indent-mode 1)

(add-to-list
 'aggressive-indent-dont-indent-if
 '(and (derived-mode-p 'c++-mode)
       (null (string-match "\\([;{}]\\|\\b\\(if\\|for\\|while\\)\\b\\)"
                           (thing-at-point 'line)))))

(use-package solaire-mode)
(solaire-global-mode +1)

(use-package hl-todo)
(global-hl-todo-mode)

(defun find-all-todos ()
  "Find all TODOs"
  (interactive)
  (projectile-grep "-- TODO"))

(general-nmap "<leader>lt" 'find-all-todos)

(use-package moom
  :init (moom-mode 1))

(use-package org-tree-slide
  :hook ((org-tree-slide-play . (lambda() (moom-toggle-frame-maximized)))
         (org-tree-slide-stop . (lambda() (moom-toggle-frame-maximized))))
  :custom
  (org-tree-slide-cursor-init)
  (org-image-actual-width nil))
(general-nmap "<leader>p" 'org-tree-slide-mode)
(general-nmap "<leader>vm" 'view-mode)
(define-key org-tree-slide-mode-map (kbd "C-<down>") 'org-tree-slide-move-next-tree)
(define-key org-tree-slide-mode-map (kbd "C-<up>") 'org-tree-slide-move-previous-tree)

(defun my-add-slide-number ()
  (add-to-list 'global-mode-string
               '(:eval (concat "" (org-tree-slide--update-modeline) " "))))
(defun my-remove-slide-number ()
  (setq global-mode-string
        (remove '(:eval (concat "" (org-tree-slide--update-modeline) " "))
                global-mode-string)))
(add-hook 'org-tree-slide-play-hook #'my-add-slide-number)
(add-hook 'org-tree-slide-stop-hook #'my-remove-slide-number)


