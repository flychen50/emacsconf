
(load-file "~/.emacs.d/cedet/cedet-devel-load.el")
;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
;;(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)
;; Enable Semantic
;;(semantic-mode 1)
;; Enable EDE (Project Management) features
;;(global-ede-mode 1)
(require 'package)
;; this is intended for manually installed libraries
;; (add-to-list 'load-path "~/.emacs.d/elpa/")
;; ;; load the package system and add some repositories
;; (add-to-list 'package-archives
;; 	     '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (add-to-list 'package-archives
;; 	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; Install a hook running post-init.el *after* initialization took place
;; Do here basic initialization, (require) non-ELPA packages, etc.

;; disable automatic loading of packages after init.el is done
(setq package-enable-at-startup nil)
;; and force it to happen now




;; package --- Summary

;;; Commentary:

;;; Code:

(unless (= emacs-major-version 24)
  (error "Emacs version 24 is required"))

(defvar init-dir (file-name-directory load-file-name))
(defvar tmp-dir (expand-file-name "tmp" init-dir))
(add-to-list 'load-path (expand-file-name "custom" init-dir))

(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'use-package)
(require 'python-environment)
(require 'py-autopep8)
(if (display-graphic-p)
    (require 'nyan-mode))

                                        ; helm
(require 'helm-config)
;;(require 'imenu-anywhere)
(setq enable-recursive-minibuffers t)
(bind-key "C-c h" 'helm-mini)
(bind-key "M-l" 'helm-locate)
(bind-key "M-t" 'helm-top)
;;(bind-key "C-." 'helm-imenu-anywhere)
(bind-key "C-x C-f" 'helm-find-files)
                                        ;(bind-key "M-x" 'helm-M-x)
(bind-key "M-l" 'helm-eshell-history)

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

; eshell
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map
                [remap eshell-pcomplete]
                'helm-esh-pcomplete)))

(setq default-directory (f-full (getenv "HOME")))
(exec-path-from-shell-initialize)

; highlight URLs in comments/strings
(add-hook 'find-file-hooks 'goto-address-prog-mode)

(defun load-local (filename)
  (let ((file (s-concat (f-expand filename user-emacs-directory) ".el")))
    (if (f-exists? file)
        (load-file file))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#262626" "#d70000" "#5f8700" "#af8700" "#0087ff" "#af005f" "#00afaf" "#626262"])
 '(anzu-deactivate-region t)
 '(anzu-mode-lighter "")
 '(anzu-replace-to-string-separator " => ")
 '(anzu-search-threshold 1000)
 '(background-color nil)
 '(background-mode dark)
 '(cursor-color nil)
 '(custom-safe-themes
   (quote
    ("1a85b8ade3d7cf76897b338ff3b20409cb5a5fbed4e45c6f38c98eee7b025ad4" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "7bde52fdac7ac54d00f3d4c559f2f7aa899311655e7eb20ec5491f3b5c533fe8" "49eea2857afb24808915643b1b5bd093eefb35424c758f502e98a03d0d3df4b1" "0c311fb22e6197daba9123f43da98f273d2bfaeeaeb653007ad1ee77f0003037" "978ff9496928cc94639cb1084004bf64235c5c7fb0cfbcc38a3871eb95fa88f6" "08efabe5a8f3827508634a3ceed33fa06b9daeef9c70a24218b70494acdf7855" "c043d365773b9f01e516f392b771b2ff46a8071852cc3ebf0f50d48fd3d32765" default)))
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.40")
 '(foreground-color nil)
 '(magit-diff-options nil))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" init-dir))
;;(load-theme 'noctilux t)
(load-theme 'xiaoming t)

(add-hook 'emacs-startup-hook
          (lambda ()
            (when (string= (buffer-name) "*scratch*")
              (animate-string "Emacs Makes All Computing Simple" (/ (frame-height) 2)))))

;;;; Local

(load-local "helper")
(load-local "misc")
(load-local "functions")
(load-local "modeline")
(load-local "hs-minor-mode-conf")
(load-local "smartparens-config")
;; key-chord
(load-local "keys")
;; Map files to modes
(load-local "mode-mappings")
(when (eq system-type 'darwin)
  (load-local "osx"))

;;;; Common

;;(add-hook 'prog-mode-hook 'show-prog-keywords)
;;(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun my-hook ()
  (idle-highlight-mode t))

;;;; Packages

(use-package ht)
(use-package autopair)

;; hippie-expand
(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

;;(use-package powerline
;;  :config
;;  (powerline-ha-theme))

(global-hl-line-mode +1)
(use-package hl-line
  :config (set-face-background 'hl-line "#111"))

(use-package direx
  :bind (("C-x C-j" . direx:jump-to-directory)))

; A modern list api for Emacs
(use-package dash
  :config (dash-enable-font-lock))

(use-package switch-window
  :bind (("C-x o" . switch-window)))

(use-package smex
  :init (smex-initialize)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)))
  :config (setq smex-save-file (expand-file-name ".smex-items" tmp-dir))

;; (use-package sql
;;   :config
;;   (progn
;;     (add-hook 'sql-mode-hook (lambda ()
;;                                (setq sql-product 'mysql)
;;                                (sql-highlight-mysql-keywords)))))

;; (use-package auto-complete)
;; (use-package auto-complete-config
;;   :config
;;   (progn
;;     (ac-config-default)
;;     (ac-flyspell-workaround)
;;     (global-auto-complete-mode t)
;;     (setq ac-auto-show-menu t)
;;     (setq ac-dwim t)
;;     (setq ac-use-menu-map t)
;;     (setq ac-quick-help-delay 1)
;;     (setq ac-quick-help-height 60)
;;     (set-default 'ac-sources
;;                  '(ac-source-dictionary
;;                    ac-source-words-in-buffer
;;                    ac-source-words-in-same-mode-buffers
;;                    ac-source-words-in-all-buffer))
;;     (dolist (mode '(magit-log-edit-mode log-edit-mode text-mode haml-mode css-mode
;;                                         sass-mode yaml-mode csv-mode espresso-mode
;;                                         scss-mode html-mode nxml-mode web-mode
;;                                         lisp-mode js2-mode markdown-mode))
;;       (add-to-list 'ac-modes mode))
;;     (add-to-list 'ac-dictionary-directories tmp-dir)
;;     (setq ac-comphist-file (expand-file-name ".ac-comphist.dat" tmp-dir))
;;     ;;Key triggers
;;     (ac-set-trigger-key "TAB")
;;     (define-key ac-completing-map (kbd "C-M-n") 'ac-next)
;;     (define-key ac-completing-map (kbd "C-M-p") 'ac-previous)
;;     (define-key ac-completing-map "\t" 'ac-complete)
;;     (define-key ac-completing-map "\r" nil)))



(add-hook 'after-init-hook 'global-company-mode)
(use-package projectile
  :config
  (progn
    (projectile-global-mode)
    (setq projectile-enable-caching t)
    (setq projectile-file-exists-local-cache-expire (* 5 60))
    (setq projectile-require-project-root nil)))

(use-package ido
  :init (ido-mode 1)
  :config
  (progn
    (setq ido-case-fold t)
    (setq ido-everywhere t)
    (setq ido-enable-prefix nil)
    (setq ido-enable-flex-matching t)
    (setq ido-create-new-buffer 'always)
    (setq ido-max-prospects 10)
    (setq ido-save-directory-list-file (expand-file-name "ido-saved-places" tmp-dir))
    (setq ido-file-extensions-order '(".py" ".el" ".coffee" ".js" ".css" ".scss"))
    (add-hook 'ido-setup-hook (lambda ()
                                (define-key ido-completion-map [up] 'previous-history-element)))
    (add-to-list 'ido-ignore-files "\\.DS_Store")))

(use-package flx-ido
  :config
  (flx-ido-mode 1))

(use-package ido-ubiquitous
  :config
  (ido-ubiquitous-mode t))

(use-package diff-hl
  :if window-system
  :config
  (progn
    (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
    (add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode)))

;; (use-package json-reformat
;;   :bind (("C-x i" . json-reformat-region)))

(use-package browse-kill-ring
  :bind (("M-y" . browse-kill-ring)))

(use-package ace-jump-mode
  :bind (("C-c SPC" . ace-jump-word-mode)
         ("C-c TAB" . ace-jump-line-mode)))

(use-package find-file-in-repository
  :bind (("C-x f" . find-file-in-repository)))

(use-package multiple-cursors
  :bind (("C-c m" . mc/mark-next-like-this)
         ("C-c ;" . mc/edit-lines)
         ("C-c n" . mc/mark-previous-like-this)))

;; Git
(use-package magit
  :init
  (progn
    (use-package magit-blame)
    (bind-key "C-c C-a" 'magit-just-amend magit-mode-map))
  :config
  (progn
    (setq magit-last-seen-setup-instructions "1.4.0")
    (setq magit-default-tracking-name-function 'magit-default-tracking-name-branch-only)
    (setq magit-set-upstream-on-push t)
    (setq magit-completing-read-function 'magit-ido-completing-read)
    (setq magit-stage-all-confirm nil)
    (setq magit-unstage-all-confirm nil)
    (setq magit-restore-window-configuration t)
    (add-hook 'magit-mode-hook 'rinari-launch))
  :bind (("M-g s" . magit-status)
         ("M-g l" . magit-log)
         ("M-g f" . magit-pull)
         ("M-g p" . magit-push)))

(use-package git-blame)
;;(use-package git-commit-mode)
;;(use-package git-rebase-mode)
(use-package gitignore-mode)
(use-package gitconfig-mode)

(setq-default
 magit-save-some-buffers nil
 magit-process-popup-time 10
 magit-diff-refine-hunk t
 magit-completing-read-function 'magit-ido-completing-read)
(add-hook 'git-commit-mode-hook 'goto-address-mode)

;; End

(use-package git-gutter
  :config
  (progn
    (global-git-gutter-mode t)
    (git-gutter:linum-setup)
    (add-hook 'python-mode-hook 'git-gutter-mode)
    (custom-set-variables
     '(git-gutter:window-width 2)
     '(git-gutter:modified-sign "☁")
     '(git-gutter:added-sign "☀")
     '(git-gutter:deleted-sign "☂")
     '(git-gutter:unchanged-sign " ")
     '(git-gutter:separator-sign "|")
     '(git-gutter:hide-gutter t))
    (set-face-background 'git-gutter:modified "purple") ;; background color
    (set-face-foreground 'git-gutter:added "green")
    (set-face-foreground 'git-gutter:deleted "red")
    (set-face-background 'git-gutter:unchanged "yellow")
    (set-face-foreground 'git-gutter:separator "yellow")
    (add-to-list 'git-gutter:update-hooks 'focus-in-hook))
  :bind (("C-x C-g" . git-gutter:toggle)
         ("C-x v =" . git-gutter:popup-hunk)
         ("C-x p" . git-gutter:previous-hunk)
         ("C-x n" . git-gutter:next-hunk)
         ("C-x v s" . git-gutter:stage-hunk)
         ("C-x v r" . git-gutter:revert-hunk)))

;; When you visit a file, point goes to the last place where it was when you previously visited the same file.
(use-package saveplace
  :config
  (progn
    (setq-default save-place t)
    (setq save-place-file "~/.emacs.d/saved-places")))

;; (use-package flycheck
;;   :config
;;   (progn
;;     (add-hook 'after-init-hook 'global-flycheck-mode)))

(use-package yasnippet
  :init
  (progn
    (use-package yasnippets)
    (yas-global-mode 1)
    (setq-default yas/prompt-functions '(yas/ido-prompt))))

;; (use-package yaml-mode
;;   :mode ("\\.yml$" . yaml-mode))

;; (use-package css-mode
;;   :config
;;   (progn
;;     (setq css-indent-offset 4)))

;; (use-package js2-mode
;;   :mode (("\\.js$" . js2-mode))
;;   :interpreter ("node" . js2-mode)
;;   :config
;;   (progn
;;     (setq js2-use-font-lock-faces t
;;           mode-name "JS2")
;;     (setq-default js2-bounce-indent-p nil
;;                   js-indent-level 4
;;                   js2-basic-indent 2
;;                   js2-basic-offset 4
;;                   js2-auto-indent-p t
;;                   js2-cleanup-whitespace t
;;                   js2-enter-indents-newline t
;;                   js2-global-externs "jQuery $"
;;                   js2-indent-on-enter-key t
;;                   js2-mode-indent-ignore-first-tab t
;;                   js2-global-externs '("module" "require" "buster"
;;                                        "sinon" "assert" "refute"
;;                                        "setTimeout" "clearTimeout"
;;                                        "setInterval" "clearInterval"
;;                                        "location" "__dirname"
;;                                        "console" "JSON"))

;;     (add-hook 'js2-mode-hook 'ac-js2-mode)
;;     (add-hook 'js-mode-hook 'js2-minor-mode)
;;     (js2-imenu-extras-setup)))

;; (use-package js2-refactor
;;   :config
;;   (progn
;;     (js2r-add-keybindings-with-prefix "M-m")))

;; (use-package coffee-mode
;;   :config
;;   (progn
;;     (add-hook 'coffee-mode-hook
;;               (lambda ()
;;                 (setq coffee-tab-width 2)
;;                 (setq coffee-args-compile '("-c" "-m"))
;;                 (add-hook 'coffee-after-compile-hook 'sourcemap-goto-corresponding-point)
;;                 (setq coffee-cleanup-whitespace nil)))))

;; (use-package sh-script
;;   :config (setq sh-basic-offset 4))

(use-package anzu
  :init (global-anzu-mode +1)
  :config
  (progn
     (set-face-attribute 'anzu-mode-line nil
                         :foreground "yellow" :weight 'bold)
     (custom-set-variables
      '(anzu-mode-lighter "")
      '(anzu-deactivate-region t)
      '(anzu-search-threshold 1000)
      '(anzu-replace-to-string-separator " => ")))
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp)))

;; (use-package scss-mode
;;   :config
;;   (progn
;;     ;; Default not execute scss-compile
;;     (setq scss-compile-at-save nil)))

(use-package eshell
  :bind ("M-1" . eshell)
  :init
  (add-hook 'eshell-first-time-mode-hook
            (lambda ()
              (add-to-list 'eshell-visual-commands "htop")))
  :config
  (progn
    (setq eshell-history-size 5000)
    (setq eshell-save-history-on-exit t)))

(use-package plim-mode
  :init (progn
          (add-to-list 'auto-mode-alist '("\\.plim\\'" . plim-mode))))

;; (use-package web-mode
;;   :config
;;   (progn
;;     (add-hook 'web-mode-hook
;;               (lambda ()
;;                 (web-mode-set-engine "mako")
;;                 (setq web-mode-disable-auto-pairing t)
;;                 (setq web-mode-css-indent-offset 4)
;;                 (setq web-mode-indent-style 4)
;;                 (setq web-mode-markup-indent-offset 4)
;;                 (setq web-mode-block-padding 4)
;;                 (setq web-mode-style-padding 4)
;;                 (setq web-mode-code-indent-offset 4)
;;                 (setq web-mode-script-padding 4)))))

(use-package ibuffer
  :config (setq ibuffer-expert t)
  :bind ("C-x C-b" . ibuffer))

;; From purcell's emacs.d
;; https://github.com/purcell/emacs.d/blob/master/lisp/init-ibuffer.el
(defun ibuffer-set-up-preferred-filters ()
  (ibuffer-vc-set-filter-groups-by-vc-root)
  (unless (eq ibuffer-sorting-mode 'filename/process)
    (ibuffer-do-sort-by-filename/process)))

(add-hook 'ibuffer-hook 'ibuffer-set-up-preferred-filters)

(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
   ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
   (t (format "%8d" (buffer-size)))))

(use-package ibuffer-vc
  :config
  (progn
    ;; Modify the default ibuffer-formats (toggle with `)
    (setq ibuffer-formats
          '((mark modified read-only vc-status-mini " "
                  (name 18 18 :left :elide)
                  " "
                  (size-h 9 -1 :right)
                  " "
                  (mode 16 16 :left :elide)
                  " "
                  filename-and-process)
            (mark modified read-only vc-status-mini " "
                  (name 18 18 :left :elide)
                  " "
                  (size-h 9 -1 :right)
                  " "
                  (mode 16 16 :left :elide)
                  " "
                  (vc-status 16 16 :left)
                  " "
                  filename-and-process)))
    (setq ibuffer-filter-group-name-face 'font-lock-doc-face)))
;; End

(use-package ag
  :config
  (setq ag-arguments
        '("--smart-case" "--nogroup" "--column" "--smart-case" "--stats" "--")
        ag-highlight-search t)
  :bind (("C-x C-y" . ag-project)))

(use-package undo-tree
  :init (global-undo-tree-mode 1)
  :config
  (progn
    (setq undo-tree-visualizer-diff t)
    (setq undo-tree-history-directory-alist (expand-file-name ".undo" tmp-dir))
    (setq undo-tree-visualizer-timestamps t)))

(use-package idle-highlight-mode
  :init (idle-highlight-mode))

(use-package rainbow-mode
  :config
  (--each '(web-mode-hook
            emacs-lisp-mode-hook
            css-mode-hook
            scss-mode-hook
            sass-mode-hook)
    (add-hook it 'rainbow-mode)
    (add-hook it 'my-hook)))

(use-package drag-stuff
  :config
  (progn
    (drag-stuff-global-mode t)))

(use-package expand-region
  :bind (("C-c x" . er/expand-region)))

(use-package smart-forward
  :bind (("C-c <up>" . smart-up)
         ("C-c <down>" . smart-down)
         ("C-c <left>" . smart-backward)
         ("C-c <right>" . smart-forward)))

;; Open ssh; or open in su(do).
;;
;;  Normally: C-x C-f /path/to/file
;;  Through ssh: C-x C-f /ssh:username@myhost.univ:/path/to/file
;;  Using sudo: C-x C-f /su::/etc/hosts

(use-package tramp
  :config
  (progn
    (setq tramp-default-method "ssh")
    (setq tramp-default-method "plink")
    (setq tramp-default-user "myname")))

(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package recentf
  :bind (("C-x C-r" . recentf-ido-find-file))
  :config
  (progn
    (setq recentf-save-file (expand-file-name ".recentf" tmp-dir)
          recentf-max-saved-items 250)
    (recentf-mode 1)))

;; Save minibuffer history.
(use-package savehist
  :config
  (progn
    (setq savehist-file (expand-file-name ".savehist" tmp-dir))
    (savehist-mode)
    (setq savehist-save-minibuffer-history 1)))

(use-package dired-k
  :config
  (progn
    (define-key dired-mode-map (kbd "K") 'dired-k)
    (add-hook 'dired-initial-position-hook 'dired-k)
    ))

(use-package direx-k
  :config
  (define-key direx:direx-mode-map (kbd "K") 'direx-k)
  :bind (("C-c o" . direx-project:jump-to-project-root-other-window)))

(use-package isend-mode
  :bind (("C-c t" . isend-send)
         ("C-c y" . isend-associate))
  :config
  (progn
    (add-hook 'isend-mode-hook 'isend-default-shell-setup)
    (add-hook 'isend-mode-hook 'isend-default-python-setup)
    (add-hook 'isend-mode-hook 'isend-default-ipython-setup)))

(use-package project-explorer
  :bind (("C-c [" . project-explorer-open)
         ("C-c ]" . project-explorer-helm)))

(use-package virtualenvwrapper
  :config
  (progn
    (venv-initialize-interactive-shells)
    (venv-initialize-eshell)))

(use-package golden-ratio
  :config
  (golden-ratio-mode 1))

;; Lisp

;;;; Auto Insert by yasnippet

(defun my-autoinsert-yas-expand()
  "Replace text in yasnippet template."
  (yas-expand-snippet (buffer-string) (point-min) (point-max)))

(setq-default auto-insert-directory (expand-file-name "auto-insert" init-dir))
(auto-insert-mode)
(setq auto-insert-query nil)

(define-auto-insert "\\.el$" ["elisp-auto-insert" my-autoinsert-yas-expand])
(define-auto-insert "\\.py$" ["python-auto-insert" my-autoinsert-yas-expand])

;; Python

(define-minor-mode auto-pep8
  :init-value t
  " Autopep8")

(defun python-hooks ()
  (if auto-pep8
      (add-hook 'before-save-hook 'py-autopep8-before-save)
    (remove-hook 'before-save-hook 'py-autopep8-before-save))

  (flycheck-list-errors-only-when-errors))

(use-package python-mode
  :init
  (progn
    (setq
     python-shell-interpreter "ipython"
     python-shell-interpreter-args ""
     python-shell-prompt-regexp "In \\[[0-9]+\\]: "
     python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
     python-shell-completion-setup-code
     "from IPython.core.completerlib import module_completion"
     python-shell-completion-module-string-code
     "';'.join(module_completion('''%s'''))\n"
     python-shell-completion-string-code
     "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")
    (add-hook 'python-mode-hook 'jedi:setup)
    (add-hook 'python-mode-hook 'my-hook)
    (setq jedi:complete-on-dot t)
    ;;(setq python-remove-cwd-from-path nil)
    (setq py-electric-colon-active t)
    (setenv "LC_CTYPE" "UTF-8"))
  :bind (("M-." . jedi:goto-definition)
         ("M-," . jedi:goto-definition-pop-marker)
         ("C-c d" . jedi:show-doc)
         ("M-SPC" . jedi:complete)))


;; Make C-c C-c behave like C-u C-c C-c in Python mode
;; (require 'python)
;; (define-key python-mode-map (kbd "C-c C-c")
;;     (lambda () (interactive) (python-shell-send-buffer t)))
(add-hook 'python-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'python-hooks)))

;; (use-package emmet-mode
;;   :config
;;   (progn
;;     (add-hook 'sgml-mode-hook 'emmet-mode)
;;     (add-hook 'scss-mode-hook 'emmet-mode)
;;     (add-hook 'css-mode-hook  'emmet-mode))
;;   :bind
;;   ("M-TAB" . emmet-expand-line))

(use-package visual-regexp
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         ("C-c m" . vr/mc-mark)))

(use-package discover-my-major
  :bind (("C-h C-m" . discover-my-major)))

(use-package crontab-mode)
(use-package transpose-frame)

;; (use-package aggressive-indent
;;   :config
;;   (progn
;;     (global-aggressive-indent-mode 1)
;;     (add-to-list 'aggressive-indent-excluded-modes 'html-mode)))

;; helm-swoop
(use-package helm-swoop
  :bind (("M-i" . helm-swoop)
         ("M-I" . helm-swoop-back-to-last-point)
         ("C-c M-i" . helm-multi-swoop)
         ("C-x M-i" . helm-multi-swoop-all))
  :config
  (progn
    (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
    (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
    (setq helm-multi-swoop-edit-save t)
    (setq helm-swoop-split-with-multiple-windows nil)
    (setq helm-swoop-split-direction 'split-window-vertically)
    (setq helm-swoop-speed-or-color nil)))

;; helm-css-scss
;; (use-package helm-css-scss
;;   :config
;;   (progn
;;     (setq helm-css-scss-insert-close-comment-depth 4)
;;     (setq helm-css-scss-split-with-multiple-windows nil)
;;     (setq helm-css-scss-split-direction 'split-window-vertically)
;;     (--each '(css-mode-hook
;;               scss-mode-hook
;;               less-css-mode-hook)
;;       (add-hook it (lambda ()
;;                      (local-set-key (kbd "s-i") 'helm-css-scss)
;;                      (local-set-key (kbd "s-I") 'helm-css-scss-back-to-last-point))))
;;     (define-key isearch-mode-map (kbd "s-i") 'helm-css-scss-from-isearch)
;;     (define-key helm-css-scss-map (kbd "s-i") 'helm-css-scss-multi-from-helm-css-scss)))

;; helm-descbinds
(use-package helm-descbinds
  :init (helm-descbinds-mode))

;; helm-ipython
;;(use-package helm-ipython)
(use-package helm-ag)

;; helm-open-github
                                        ;(use-package helm-open-github
                                        ;  :config
                                        ;  (progn
                                        ;    (global-set-key (kbd "C-c o f") 'helm-open-github-from-file)
                                        ;    (global-set-key (kbd "C-c o c") 'helm-open-github-from-commit)
                                        ;    (global-set-key (kbd "C-c o i") 'helm-open-github-from-issues)
                                        ;    (global-set-key (kbd "C-c o p") 'helm-open-github-from-pull-requests)))

(require 'ido-hacks)
(use-package ido-hacks
  :init (ido-hacks-mode))

(use-package template)



;;;; Bindings

(bind-key "C-x h" 'my-help)

(bind-key "C-z  " 'undo)
(bind-key "C-c b" 'switch-to-previous-buffer)
(bind-key "M-p  " 'hold-line-scroll-down)
(bind-key "M-n  " 'hold-line-scroll-up)
(bind-key "C-c v" 'py-taglist)

;; Toggle Fullscreen
(bind-key "C-c f" 'toggle-fullscreen)

;(if (display-graphic-p)
;  (toggle-fullscreen))

;; Reload File
(bind-key  [f5] 'revert-buffer)
(bind-key  [C-f5] 'revert-buffer-with-coding-system)

;; Change windows
(bind-key "C-x <up>" 'windmove-up)
(bind-key "C-x <down>" 'windmove-down)
(bind-key "C-x <right>" 'windmove-right)
(bind-key "C-x <left>" 'windmove-left)

;; search in GitHub/Google
(bind-key "C-c G" 'search-github)
(bind-key "C-c g" 'search-google)
(bind-key "C-c q" 'search-stackoverflow)

;; automatically add the comment.
(bind-key "C-c j" 'comment-dwim)
;; Align Text use "="
(bind-key "C-c k" 'align-to-equals)


;; Load you local settings
(load-local "local-settings")

                                        ;(provide 'init)
;;; init.el ends here



;; NOW you can (require) your ELPA packages and configure them as normal
;;(add-to-list 'load-path "~/.mylisp/")
(load-file (concat user-emacs-directory "/cedet/contrib/cedet-contrib-load.el"))
;; (setq semanticdb-project-roots
;;       (list (expand-file-name "/")));semantic检索范围
;;设置semantic cache临时文件的路径，避免到处都是临时文件
(setq semanticdb-default-save-directory "~/.emacs.d/")
;;代码浏览框架
(require 'cedet)
(require 'semantic)
;;(require 'ede)
;;(require 'ecb)
;;(require 'eassist nil 'noerror)
;;(global-ede-mode)
;;cpp和header快速切换
(semantic-load-enable-minimum-features)
(setq semanticdb-default-save-directory "~/.emacs.d/semanticdb")
(semantic-load-enable-code-helpers)
(semantic-load-enable-gaudy-code-helpers)
(semantic-load-enable-excessive-code-helpers)
;;(semantic-load-enable-semantic-debugging-helpers)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)
;;(semantic-add-system-include "/usr/include/boost" 'c++-mode)
;;(require 'ecb-autoloads)
;;(ecb-activate)
;; (when (require 'ecb nil 'noerror)
;;   (setq ecb-tip-of-the-day nil)
;;   (setq ecb-auto-compatibility-check nil)
;;   (setq ecb-primary-secondary-mouse-buttons 'mouse-1--C-mouse-1))
;; (global-set-key (kbd "<f9>") 'semantic-ia-fast-jump)   ; 打开ejb
;; (global-set-key (kbd "<f8>") 'eassist-switch-h-cpp)   ; 打开ejb
;; (global-set-key (kbd "<f7>") 'ecb-minor-mode)   ; 打开ejb
;; (global-set-key (kbd "<f6>") 'ecb-goto-window-edit1)
;; (global-set-key (kbd "<f5>") 'ecb-goto-window-methods)
;; (global-set-key (kbd "<f4>") 'ecb-goto-window-sources)
;; (global-set-key (kbd "<f3>") 'ecb-goto-window-history)





;; ;; ;;使用google 代码规范
;; ;; (require 'google-c-style)
;; ;; (add-hook 'c-mode-common-hook 'google-set-c-style)
;; ;; (add-hook 'c-mode-common-hook 'google-make-newline-indent)
;; ;;使用yas进行代码快速插入,如doc，插入注释
;; (require 'yasnippet)
;; (yas-global-mode 1)

(require 'xcscope)
(cscope-setup)
;; (put 'set-goal-column 'disabled nil)
;; (put 'upcase-region 'disabled nil)
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
;; ;; insert-current-time
;; (defun insert-current-time ()
;;   "Insert the current time"
;;   (interactive "*")
;;   (insert (current-time-string)))
;;                                         ;(global-set-key "C-xt" 'insert-current-time)
;; (defun cpplint ()
;;   "check source code format according to Google Style Guide"
;;   (interactive)
;;   (compilation-start (concat "/usr/bin/cpplint.py " (buffer-file-name))))
;; (defun format-function ()
;;   "Format the whole buffer."
;;   (setq tab-width 4) ;; change this to taste, this is what K&R uses <img src="http://zhanxw.com/blog/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley">
;;   (setq c-basic-offset tab-width)
;;   (c-set-offset 'substatement-open 0)
;;   ;; next line is strange, I copied it from .emacs, but it cannot find c-lineup-arglist-intro-after-paren
;;   ;; however, disable this line seems working as well.
;;   ;;(c-set-offset 'arglist-intro c-lineup-arglist-intro-after-paren)
;;   (indent-region (point-min) (point-max) nil)
;;   (untabify (point-min) (point-max))
;;   (save-buffer)
;;   )
;; ;;(semanticdb-enable-cscope-databases)  ;;This is causing problems
;; ;;auto company
;; ;;(add-to-list 'load-path "~/.mylisp/company-mode/")
;; ;;(autoload 'company-mode "company" nil t)


;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)

;; ;; replace the `completion-at-point' and `complete-symbol' bindings in
;; ;; irony-mode's buffers by irony-mode's function
;; (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map [remap completion-at-point]
;;     'irony-completion-at-point-async)
;;   (define-key irony-mode-map [remap complete-symbol]
;;     'irony-completion-at-point-async))
;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; (setq bc-bookmark-file "~/.emacs.d/bookmark")
;; (setq bc-bookmark-limit 300)
;; (defun my-rpm-changelog-increment-version ()
;;   (interactive)
;;   (goto-char (point-min))
;;   (let* ((max (search-forward-regexp rpm-section-regexp))
;;          (version (rpm-spec-field-value "Version" max)))
;;     (rpm-add-change-log-entry (concat "Upgrade version to " version))
;;     )
;;   )

;; ;; (require 'company)
;; ;; (add-hook 'after-init-hook 'global-company-mode)
;; ;; (delete 'company-clang company-backends)
;; ;; (define-key c-mode-map  [(control tab)] 'company-complete)
;; ;; (define-key c++-mode-map  [(control tab)] 'company-complete)
;; ;; ;; company-c-headers
;; ;; (add-to-list 'company-backends 'company-c-headers)
;; ;; The following lines are always needed. Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-agenda-files '("~/org"))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(setq org-src-fontify-natively t)
(setq org-log-done 'time)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (sh . t)
   (python . t)
   (R . t)
   (ruby . t)
   (ditaa . t)
   (dot . t)
   (octave . t)
   (sqlite . t)
   (perl . t)
   (C . t)
   ))
(setq org-src-fontify-natively t)
(setq org-publish-project-alist
      '(("orgfiles"
         :base-directory "."
         :base-extension "org"
         :publishing-directory "/ssh:root@107.182.190.245:/home/wwwroot/default"
         :publishing-function org-html-publish-to-html
;;         :exclude "PrivatePage.org"   ;; regexp
         :headline-levels 2
         :table-of-contens t
         :section-numbers t
         :with-toc t
                        :html-head "<link rel=\"stylesheet\"
                       href=\"../other/mystyle.css\" type=\"text/css\"/>"
                        :html-preamble t)

        ;; ("images"
        ;;  :base-directory "~/images/"
        ;;  :base-extension "j\\|gif\\|png"               :publishing-directory "/ssh:user@host:~/html/images/"
        ;;  :publishing-function org-publish-attachment)

        ;; ("other"
        ;;  :base-directory "~/other/"
        ;;  :base-extension "css\\|el"
        ;;  :publishing-directory "/ssh:user@host:~/html/other/"
        ;;  :publishing-function org-publish-attachment)
        ;;               ("website" :components ("orgfiles" "images" "other"))))
        ))

;; (put 'dired-find-alternate-file 'disabled nil)

;; ;; (global-set-key (kbd "<M-left>") 'ecb-goto-window-methods)
;; ;; (global-set-key (kbd "<M-right>") 'ecb-goto-window-edit1)
;; ;; ;; disable semantic in all non C/C++ buffers
;; ;; (add-to-list 'semantic-inhibit-functions
;; ;;              (lambda () (not (member major-mode '(c-mode c++-mode)))))
;; ;;(set-fontset-font "fontset-default" 'han '("STHeiti"))
;; ;;(set-default-font "Source Code Pro-12")
;; ;;(set-fontset-font "fontset-default" 'gb18030' ("STHeiti" . "unicode-bmp"))
;; ;; set Chinese font, or the when showing Italic Chinese characters, only rectangle block shown
;; ;; (set-fontset-font
;; ;;  (frame-parameter nil 'font)
;; ;;  'han
;; ;;  (font-spec :family "Hiragino Sans GB" ))
;; (eval-after-load 'autoinsert
;;   '(define-auto-insert '("\\.c\\'" . "C skeleton")
;;      '(
;;        "Short description: "
;;        "/**\n * "
;;        (file-name-nondirectory (buffer-file-name))
;;        " -- " str \n
;;        " *" \n
;;        " * Written on " (format-time-string "%A, %e %B %Y.") \n
;;        " */" > \n \n
;;        "#include <stdio.h>" \n
;;        "#include \""
;;        (file-name-sans-extension
;;         (file-name-nondirectory (buffer-file-name)))
;;        ".h\"" \n \n
;;        "int main()" \n
;;        "{" > \n
;;        > _ \n
;;               "}" > \n)))
(setq debug-on-error t)
