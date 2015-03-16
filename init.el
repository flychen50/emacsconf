(unless (= emacs-major-version 24)
  (error "Emacs version 24 is required"))
;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: Tou must place this *before* any CEDET component (including
;; EIEIO) gets activated by another package (Gnus, auth-source, ...).
(load-file "~/.emacs.d/cedet/cedet-devel-load.el")
;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)
;; Enable Semantic
;;(semantic-mode 1)
;; Enable EDE (Project Management) features
;;(global-ede-mode 1)
(defvar init-dir (file-name-directory load-file-name))
(defvar tmp-dir (expand-file-name "tmp" init-dir))
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
(package-initialize)
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'use-package)
; helm
(require 'helm-config)
(require 'imenu-anywhere)
(setq enable-recursive-minibuffers t)
(bind-key "C-c h" 'helm-mini)
(bind-key "M-l" 'helm-locate)
(bind-key "M-t" 'helm-top)
(bind-key "C-." 'helm-imenu-anywhere)
(bind-key "C-x C-f" 'helm-find-files)
;(bind-key "M-x" 'helm-M-x)
(bind-key "M-l" 'helm-eshell-history)

; eshell
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map
                [remap eshell-pcomplete]
                'helm-esh-pcomplete)))


(use-package undo-tree
  :init (global-undo-tree-mode 1)
  :config
  (progn
    (setq undo-tree-visualizer-diff t)
    (setq undo-tree-history-directory-alist (expand-file-name ".undo" tmp-dir))
    (setq undo-tree-visualizer-timestamps t)))


(use-package switch-window
  :bind (("C-x o" . switch-window)))

;; Git
(use-package magit
  :init
  (progn
    (use-package magit-blame)
    (bind-key "C-c C-a" 'magit-just-amend magit-mode-map))
  :config
  (progn
    (setq magit-default-tracking-name-function 'magit-default-tracking-name-branch-only)
    (setq magit-set-upstream-on-push t)
    (setq magit-completing-read-function 'magit-ido-completing-read)
    (setq magit-stage-all-confirm nil)
    (setq magit-unstage-all-confirm nil)
    (setq magit-restore-window-configuration t))
  :bind (("M-g s" . magit-status)
	 ("M-g l" . magit-log)
	 ("M-g f" . magit-pull)
	 ("M-g p" . magit-push)))

(use-package git-blame)
(use-package git-commit-mode)
(use-package git-rebase-mode)
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


(use-package browse-kill-ring
    :bind (("M-y" . browse-kill-ring)))




(defun load-local (filename)
  (let ((file (s-concat (f-expand filename user-emacs-directory) ".el")))
    (if (f-exists? file)
	(load-file file))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#262626" "#d70000" "#5f8700" "#af8700" "#0087ff" "#af005f" "#00afaf" "#626262"])
 '(anzu-deactivate-region t)
 '(anzu-mode-lighter "")
 '(anzu-replace-to-string-separator " => ")
 '(anzu-search-threshold 1000)
 '(background-color nil)
 '(background-mode dark)
 '(cursor-color nil)
 '(foreground-color nil))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" init-dir))
(load-theme 'noctilux t)

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
					;(load-local "keys")
;; Map files to modes
(load-local "mode-mappings")
(when (eq system-type 'darwin)
    (load-local "osx"))


;;;; Common

(add-hook 'prog-mode-hook 'show-prog-keywords)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun my-hook ()
  (idle-highlight-mode t))

;;;; Packages

(use-package ht)

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

;; (use-package company
;;   :config
;;   (company-mode 1))

;; NOW you can (require) your ELPA packages and configure them as normal
(add-to-list 'load-path "~/.mylisp/")
(load-file (concat user-emacs-directory "/cedet/contrib/cedet-contrib-load.el"))
(setq semanticdb-project-roots
       (list (expand-file-name "/")));semantic检索范围
;;设置semantic cache临时文件的路径，避免到处都是临时文件
(setq semanticdb-default-save-directory "~/.emacs.d/")
;;使用google 代码规范
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
;;使用yas进行代码快速插入,如doc，插入注释
(require 'yasnippet)
 (yas-global-mode 1)
;;代码浏览框架
(require 'cedet)
(require 'semantic)
(require 'ede)
;;(global-ede-mode)
;;cpp和header快速切换
(require 'eassist nil 'noerror)
(semantic-load-enable-minimum-features)
(setq semanticdb-default-save-directory "~/.emacs.d/semanticdb")
;;(semantic-load-enable-code-helpers)
;;(semantic-load-enable-gaudy-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)
;;(semantic-load-enable-semantic-debugging-helpers)
(require 'cc-mode)
(require 'semantic)
;;(global-semanticdb-minor-mode 1)
;;(global-semantic-idle-scheduler-mode 1)
;;(semantic-mode 1)
(semantic-add-system-include "/usr/include/boost" 'c++-mode)
(require 'ecb)
;;(require 'ecb-autoloads)
;;(ecb-activate)
(when (require 'ecb nil 'noerror)
  (setq ecb-tip-of-the-day nil)
  (setq ecb-auto-compatibility-check nil)
  (setq ecb-primary-secondary-mouse-buttons 'mouse-1--C-mouse-1))
(global-set-key (kbd "<f9>") 'semantic-ia-fast-jump)   ; 打开ejb
(global-set-key (kbd "<f8>") 'eassist-switch-h-cpp)   ; 打开ejb
(global-set-key (kbd "<f7>") 'ecb-minor-mode)   ; 打开ejb
(global-set-key (kbd "<f6>") 'ecb-goto-window-edit1)
(global-set-key (kbd "<f5>") 'ecb-goto-window-methods)
(global-set-key (kbd "<f4>") 'ecb-goto-window-sources)
(global-set-key (kbd "<f3>") 'ecb-goto-window-history)
;;(add-to-list 'load-path (expand-file-name "~/.mylisp"))
;;
;; And the following to your ~/.emacs startup file.
;;
;;(require 'init-ecb)

;;(global-linum-mode 'linum-mode);;在左边显示行号
;;设置home键指向buffer开头，end键指向buffer结尾
;;(global-set-key [home] 'beginning-of-buffer)
;;(global-set-key [end] 'end-of-buffer)
;;(setq x-select-enable-clipboard t);支持emacs和外部程序的粘贴
;;;;ejb 快捷键
;; (require 'helm-config)
;; (helm-mode 1)
;; (global-set-key (kbd "M-y") 'helm-show-kill-ring)
(require 'xcscope)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(magit-diff-options nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; insert-current-time
(defun insert-current-time ()
  "Insert the current time"
  (interactive "*")
  (insert (current-time-string)))
;(global-set-key "C-xt" 'insert-current-time)
(defun cpplint ()
  "check source code format according to Google Style Guide"
  (interactive)
    (compilation-start (concat "/usr/bin/cpplint.py " (buffer-file-name))))
(defun format-function ()
  "Format the whole buffer."
  (setq tab-width 4) ;; change this to taste, this is what K&R uses <img src="http://zhanxw.com/blog/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley">
  (setq c-basic-offset tab-width)
  (c-set-offset 'substatement-open 0)
  ;; next line is strange, I copied it from .emacs, but it cannot find c-lineup-arglist-intro-after-paren
  ;; however, disable this line seems working as well.
  ;;(c-set-offset 'arglist-intro c-lineup-arglist-intro-after-paren)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max))
  (save-buffer)
    )
;;(semanticdb-enable-cscope-databases)  ;;This is causing problems
;;auto company
(add-to-list 'load-path "~/.mylisp/company-mode/")
(autoload 'company-mode "company" nil t)
(setq bc-bookmark-file "~/.emacs.d/bookmark")
(setq bc-bookmark-limit 300)
(defun my-rpm-changelog-increment-version ()
  (interactive)
  (goto-char (point-min))
  (let* ((max (search-forward-regexp rpm-section-regexp))
	 (version (rpm-spec-field-value "Version" max)))
    (rpm-add-change-log-entry (concat "Upgrade version to " version))
    )
    )
;; (require 'elpy nil t)
;; (elpy-enable)
;; (setq elpy-rpc-backend "jedi")
;;(setq elpy-rpc-python-command "python2.4")
(put 'dired-find-alternate-file 'disabled nil)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))


(bind-key "C-z  " 'undo)
(bind-key "C-c b" 'switch-to-prev-buffer)
;;(add-hook 'after-init-hook 'global-company-mode)
;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
(define-key c-mode-map  [(control tab)] 'company-complete)
(define-key c++-mode-map  [(control tab)] 'company-complete)
;; company-c-headers
(add-to-list 'company-backends 'company-c-headers)

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)

;; Package: smartparens
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)

(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;; Package: projejctile
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)
