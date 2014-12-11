(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'load-path "~/.mylisp/")
(add-to-list 'load-path "~/.mylisp/cedet/")
(add-to-list 'load-path "~/.mylisp/helm/")
;;(add-to-list 'load-path "~/.mylisp/yasnippet")
(add-to-list 'load-path "~/.emacs.d/elpa/ecb-20140215.114/")  
(load-file (concat user-emacs-directory "cedet/cedet-devel-load.el"))
(load-file (concat user-emacs-directory "cedet/contrib/cedet-contrib-load.el"))
;;使用google 代码规范
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
;;使用yas进行代码快速插入,如doc，插入注释
;;(require 'yasnippet)
;; (yas-global-mode 1)
;;代码浏览框架
(require 'cedet)
(require 'semantic)
;;cpp和header快速切换
(require 'eassist nil 'noerror)
(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
;;(semantic-load-enable-gaudy-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)
;;(semantic-load-enable-semantic-debugging-helpers)
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
(require 'helm-config)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.mylisp/ac-dict")
(ac-config-default)
(require 'auto-complete-clang)
(require 'xcscope)
(setq ac-clang-auto-save t)
(setq ac-auto-start t)
(setq ac-quick-help-delay 0.5)
(setq cscope-do-not-update-database t)
;; (ac-set-trigger-key "TAB")
(define-key ac-mode-map  [(control tab)] 'auto-complete)
(defun my-ac-config ()
    (setq ac-clang-flags
	          (mapcar(lambda (item)(concat "-I" item))
			                (split-string
					                 "
/usr/lib/gcc/x86_64-redhat-linux/4.1.2/../../../../include/c++/4.1.2
 /usr/lib/gcc/x86_64-redhat-linux/4.1.2/../../../../include/c++/4.1.2/x86_64-redhat-linux
 /usr/lib/gcc/x86_64-redhat-linux/4.1.2/../../../../include/c++/4.1.2/backward
 /usr/local/include
 /usr/lib/gcc/x86_64-redhat-linux/4.1.2/include
 /usr/include
")))
      (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
        (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
	  ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
	  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
	    (add-hook 'css-mode-hook 'ac-css-mode-setup)
	      (add-hook 'auto-complete-mode-hook 'ac-common-setup)
	        (global-auto-complete-mode t))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;; ac-source-gtags
(my-ac-config)
(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
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
;;(global-set-key "C-xt" 'insert-current-time) 
(defun cpplint ()
  "check source code format according to Google Style Guide"
  (interactive)
    (compilation-start (concat "/usr/bin/cpplint.py " (buffer-file-name))))
(semanticdb-enable-cscope-databases)  ;;This is causing problems
;;(setq debug-on-error t)
