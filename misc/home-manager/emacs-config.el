(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(use-package beacon
:ensure t)
(beacon-mode 1)

(setq org-src-preserve-indentation nil
      org-src-tab-acts-natively t
      org-src-fontify-natively t
      org-hide-emphasis-markers t
      org-agenda-tags-column 0
      org-pretty-entities t
      org-ellipsis "…"
      org-confirm-babel-evaluate nil
      org-edit-src-content-indentation 2
      org-catch-invisible-edits 'show-and-error)

(general-nmap
  "<leader>t" 'org-babel-tangle)

;; (setq org-startup-numerated t)

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

(advice-add #'ispell-pdict-save :after #'flycheck-maybe-recheck)
(defun flycheck-maybe-recheck (_)
  (when (bound-and-true-p flycheck-mode)
    (flycheck-buffer)))

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

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package diff-hl)
(global-diff-hl-mode)

(diff-hl-dired-mode)
(diff-hl-margin-mode)
(diff-hl-flydiff-mode)

(use-package hl-todo)
(global-hl-todo-mode)

(defun find-all-todos ()
  "Find all TODOs"
  (interactive)
  (projectile-grep "-- TODO"))

(general-nmap "<leader>lt" 'find-all-todos)

(defun my-add-slide-number ()
  (add-to-list 'global-mode-string
               '(:eval (concat "" (org-tree-slide--update-modeline) " "))))
(defun my-remove-slide-number ()
  (setq global-mode-string
        (remove '(:eval (concat "" (org-tree-slide--update-modeline) " "))
                global-mode-string)))
(add-hook 'org-tree-slide-play-hook #'my-add-slide-number)
(add-hook 'org-tree-slide-stop-hook #'my-remove-slide-number)


