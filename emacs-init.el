(setq initial-major-mode 'text-mode)

;;;; prefer UTF8

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;;; detect operating system

(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-a-linux* (eq system-type 'gnu/linux))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;;; essential settings

(when *is-a-mac*
  (setq mac-option-modifier 'meta)
  (custom-set-variables '(ns-use-srgb-colorspace nil)))

(setq-default
 buffers-menu-max-size 30
 case-fold-search t
 column-number-mode t
 delete-selection-mode t
 indent-tabs-mode nil
 mouse-yank-at-point t
 save-interprogram-paste-before-kill t
 scroll-preserve-screen-position 'always
 set-mark-command-repeat-pop t
 tooltip-delay 1.5
 truncate-lines nil
 truncate-partial-width-windows nil
 visible-bell nil)

(setq use-file-dialog nil
      x-gtk-use-system-tooltips t
      use-dialog-box nil
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      require-final-newline t
      create-lockfiles nil
      indicate-empty-lines t)

;; do not ask follow link
(customize-set-variable 'find-file-visit-truename t)

;; modes

(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'set-scroll-bar-mode)
    (set-scroll-bar-mode nil))
(if (fboundp 'menu-bar-mode)
    (menu-bar-mode -1))

(global-auto-revert-mode t)
(global-hl-line-mode +1)
(transient-mark-mode t)
(global-prettify-symbols-mode t)
(electric-indent-mode t)
(electric-quote-mode t)
(electric-pair-mode t)
(show-paren-mode t)
(cua-selection-mode t)
(winner-mode t)

(fset 'yes-or-no-p 'y-or-n-p)
;; Don't disable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; Don't disable case-change functions
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(setq tramp-ssh-controlmaster-options
      "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")

;;;; MELPA

(setq package-check-signature nil)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
(setq load-prefer-newer t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

(eval-when-compile
  (require 'use-package))
(use-package diminish)

;; refresh packages list before use-package’s first ensure installation
(defun technoidentity/package-install-refresh-contents (&rest args)
  (package-refresh-contents)
  (advice-remove 'package-install 'technoidentity/package-install-refresh-contents))

(advice-add 'package-install :before 'technoidentity/package-install-refresh-contents)

;; load ~/.emacs-pre-local.el before anything

(when (file-exists-p "~/.emacs-pre-local.el")
  (load-file "~/.emacs-pre-local.el"))

;; auto update packages
(use-package auto-package-update
  :config
  (auto-package-update-maybe))

;;;; libraries

(use-package dash)
(use-package s)

;;;; keys

(use-package which-key
  :diminish which-key-mode

  :init
  (which-key-mode))

(use-package bind-key)

(use-package auto-compile
  :config
  (auto-compile-on-load-mode)
  (auto-compile-on-save-mode))

(use-package no-littering
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;;;; UI

(use-package darkokai-theme :defer t)

(setq darkokai-mode-line-padding 1) ;; Default mode-line box width
(load-theme 'darkokai t)

(defun technoidentity/font-available-p (font)
  "Check if FONT available on the system."
  (-contains? (font-family-list) font))

(defconst *technoidentity-default-fonts*
  '("Monaco"
    "Consolas"
    "Ubuntu Mono"
    "Source Code Pro"
    "mononoki"
    "Roboto Mono"
    "Fira Code"
    "Hack"
    "Dejavu Sans Mono"))

(-when-let (font (-first 'technoidentity/font-available-p
                         *technoidentity-default-fonts*))
  (set-frame-font (concat font " 13")))

;; Essential

(use-package server
  :config
  (if (not (server-running-p))
      (server-start)))

(use-package savehist
  :init
  (setq enable-recursive-minibuffers  t    ; Allow commands in minibuffers
        history-length                1000
        kill-ring-max                 19
        savehist-autosave-interval    60
        savehist-additional-variables '(mark-ring
                                        global-mark-ring
                                        kill-ring
                                        search-ring
                                        regexp-search-ring
                                        extended-command-history))

  :config
  (savehist-mode t))

(use-package saveplace
  :init
  (setq save-place t)

  :config
  (when (fboundp 'save-place-mode)
    (save-place-mode +1)))

(use-package recentf
  :init
  (setq recentf-max-saved-items 100)
  (setq recentf-auto-save-timer (run-with-idle-timer 600 t 'recentf-save-list))
  (setq recentf-exclude '("/tmp/" "/ssh:"))

  :config
  (add-to-list 'recentf-exclude (file-truename no-littering-var-directory))
  (add-to-list 'recentf-exclude (file-truename no-littering-etc-directory))
  (add-to-list 'recentf-exclude
               (file-truename (concat user-emacs-directory "elpa/")))

  (recentf-mode +1))

(use-package noflet
  :config
  ;; do not ask to kill processes
  (defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
    (noflet ((process-list ())) ad-do-it)))

;;;; Completion, Search

(use-package ivy
  :demand t
  :diminish ivy-mode
  :bind (("C-'" . avy-goto-char-2)
         ("C-c '" . avy-goto-char-2)
         ("M-'" . avy-goto-word-or-subword-1))
  :init
  (setq ivy-use-virtual-buffers t
        ivy-use-selectable-prompt t
        ivy-count-format "(%d/%d) ")

  :config
  ;; Use C-j for immediate termination with the current value, and RET
  ;; for continuing completion for that directory. This is the ido behaviour.
  (define-key ivy-minibuffer-map (kbd "C-j") #'ivy-immediate-done)
  (define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
  (ivy-mode))

(use-package swiper)

(use-package counsel
  :bind (("M-x"     . counsel-M-x)
         ("C-x C-f" . counsel-find-file))

  :init
  (setq counsel-mode-override-describe-bindings t))

(use-package avy
  :init
  (setq avy-keys (number-sequence ?a ?z))
  (setq avy-background t)

  :config
  (avy-setup-default))

;;;; Window management

(use-package ace-window
  :bind ("C-x o" . ace-window)
  :init
  (setq aw-dispatch-always t))

(winner-mode)
(windmove-default-keybindings)

(use-package winum
  :init
  (setq winum-auto-setup-mode-line nil)

  :config
  (winum-mode))

(use-package buffer-move
  :bind (("<C-S-up>" . buf-move-up)
         ("<C-S-down>" . buf-move-down)
         ("<C-S-left>" . buf-move-left)
         ("<C-S-right>" . buf-move-right)))

(use-package uniquify
  :ensure nil
  :init
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets
        uniquify-ignore-buffers-re "^\\*"))

;;; Editing

(bind-key [remap just-one-space] 'cycle-spacing)
(bind-key "RET" 'newline-and-indent)

(use-package whitespace
  :diminish whitespace-mode
  :defer t

  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook #'whitespace-cleanup)

  :config
  (setq whitespace-line-column 80) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail)))

(use-package move-dup
  :bind (("M-S-<down>" . md/move-lines-down)
         ("M-s-<down>" . md/duplicate-down)
         ("M-s-<up>" . md/duplicate-up)
         ("M-S-<up>" . md/move-lines-up)))

(use-package easy-kill
  :defer t

  :init
  (global-set-key [remap kill-ring-save] 'easy-kill)
  (global-set-key [remap mark-sexp] 'easy-mark))

(use-package expand-region
  :bind (("C-=" . er/expand-region)
         ("C-c =" . er/expand-region)))

(use-package multiple-cursors
  :bind (("C-c C-c" . mc/edit-lines)
         ("C-c C-e" . mc/edit-ends-of-lines)
         ("C-c C-a" . mc/edit-beginnings-of-lines)
         ("C-c >" . mc/mark-next-like-this)
         ("C-c <" . mc/mark-previous-like-this)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)))

(use-package goto-chg
  :bind(
        ("C-." . goto-last-change)
        ("C-," . goto-last-change-reverse)
        ("C-c ." . goto-last-change)
        ("C-c ," . goto-last-change-reverse)))

(use-package undo-tree
  :defer t
  :diminish undo-tree-mode

  :init
  (setq undo-tree-auto-save-history t)
  (add-hook 'after-init-hook 'global-undo-tree-mode))

(use-package iedit
  :diminish iedit-mode)

(use-package zop-to-char
  :bind (("M-z" . zop-up-to-char)
         ("M-Z" . zop-to-char)))

(use-package super-save
  :diminish super-save-mode

  :config
  (super-save-mode +1))

(use-package crux
  :bind (("M-o" . crux-smart-open-line)
         ("M-O" . crux-smart-open-line-above)
         ("C-^" . crux-top-join-line)
         ("C-c ^" . crux-top-join-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("C-c <backspace>" . crux-kill-line-backwards)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([remap kill-whole-line] . crux-kill-whole-line)))

;;;; Git

(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)
         :map magit-status-mode-map
         ("C-M-<up>" . magit-section-up))

  :init
  (setq   magit-log-arguments '("--graph" "--show-signature")
          magit-completing-read-function 'ivy-completing-read
          magit-process-popup-time 10
          magit-diff-refine-hunk t
          magit-push-always-verify nil)

  :config
  (global-git-commit-mode))

(use-package ediff
  :defer t
  :init
  (setq  ediff-window-setup-function 'ediff-setup-windows-plain
         ediff-split-window-function 'split-window-horizontally
         ediff-merge-split-window-function 'split-window-horizontally))

(use-package diff-hl
  :init
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  :config
  (global-diff-hl-mode +1))

;;;; Programming

(use-package imenu
  :demand t
  :bind(("M-i" . imenu)))

(use-package imenu-anywhere
  :bind(("M-I" . imenu-anywhere)))

(use-package yasnippet
  :diminish yas-minor-mode
  :defer t

  :init
  (add-hook 'prog-mode-hook #'yas-minor-mode)

  :config
  (yas-reload-all))

(use-package eldoc
  :diminish eldoc-mode
  :defer t

  :init
  (add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode)
  (add-hook 'ielm-mode-hook #'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook #'eldoc-mode))

(use-package exec-path-from-shell
  :config
  (custom-set-variables '(exec-path-from-shell-check-startup-files nil))
  (exec-path-from-shell-initialize)
  (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO"
                 "LANG" "LC_CTYPE" "JAVA_HOME" "JDK_HOME"))
    (add-to-list 'exec-path-from-shell-variables var)))

(use-package flycheck
  :defer t
  :diminish flycheck-mode

  :init
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq flycheck-check-syntax-automatically '(save new-line mode-enabled)
        flycheck-idle-change-delay 0.8)
  (setq flycheck-display-errors-function
        #'flycheck-display-error-messages-unless-error-list))

(use-package company
  :diminish company-mode " ⓐ"
  :defer t

  :init
  (setq company-idle-delay 0.2
        tab-always-indent 'complete
        company-tooltip-limit 10
        company-minimum-prefix-length 2
        company-tooltip-flip-when-above t)

  (add-to-list 'completion-styles 'initials t)
  (add-hook 'emacs-lisp-mode-hook #'company-mode)

  :config
  (setq company-minimum-prefix-length 2))

(use-package projectile
  :diminish projectile-mode

  :init
  (setq projectile-enable-caching t
        projectile-completion-system 'ivy
        projectile-sort-order 'recentf)

  :config
  (projectile-mode)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;;;; Clojure

(use-package paredit :defer t)

(use-package parinfer
  :diminish " ⓟ"

  :init
  (setq parinfer-auto-switch-indent-mode t)
  (setq parinfer-extensions
        '(defaults       ; should be included.
           pretty-parens ; different paren styles for different modes.
           paredit       ; Introduce some paredit commands.
           smart-tab     ; C-b & C-f jump positions,smart shift with tab & S-tab
           smart-yank))  ; Yank behavior depend on mode.

  (add-hook 'clojure-mode-hook #'parinfer-mode)
  (add-hook 'emacs-lisp-mode-hook #'parinfer-mode))

(use-package clojure-mode
  :defer t

  :init
  (defun clojure-mode-setup ()
    (subword-mode)
    (company-mode)
    (eldoc-mode))
  (add-hook 'clojure-mode-hook 'clojure-mode-setup)

  :config
  (define-clojure-indent
    (defroutes 'defun)
    (prop/for-all 'defun)
    (GET 2)
    (POST 2)
    (PUT 2)
    (DELETE 2)
    (HEAD 2)
    (ANY 2)
    (context 2)))

(use-package clj-refactor
  :diminish clj-refactor-mode
  :init
  (add-hook 'clojure-mode-hook 'clj-refactor-mode)

  :config
  (cljr-add-keybindings-with-prefix "C-c C-f"))

(use-package cider
  :init
  (setq cider-show-error-buffer nil
        cider-overlays-use-font-lock t
        nrepl-buffer-name-show-port t
        cider-save-file-on-load nil

        cider-repl-use-clojure-font-lock t
        cider-repl-wrap-history t
        cider-repl-pop-to-buffer-on-connect nil)

  (defun cider-repl-mode-setup ()
    (subword-mode)
    (company-mode))

  (add-hook 'cider-repl-mode-hook 'cider-repl-mode-setup))

(when (file-exists-p "~/.emacs-post-local.el")
  (load-file "~/.emacs-post-local.el"))

(use-package spaceline
  :init
  (setq spaceline-window-numbers-unicode t)

  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme))

;;; init.el ends here
