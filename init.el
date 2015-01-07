(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (require 'package)
;; (setq package-archives
;;       '(("gnu" . "http://elpa.gnu.org/packages/")
;; 	("marmalade" . "http://marmalade-repo.org/packages/")
;; 	("melpa" . "http://melpa.milkbox.net/packages/")))
;;(package-initialize)
(add-to-list 'load-path "~/.mylisp/")
(add-to-list 'load-path "~/.emacs.d/cedet/")
(add-to-list 'load-path "~/.mylisp/helm/")
(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20141117.327/")
(add-to-list 'load-path "~/.emacs.d/elpa/ecb-20140215.114/")  
(load-file (concat user-emacs-directory "/cedet/cedet-devel-load.el"))
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
(global-ede-mode)
;;cpp和header快速切换
(require 'eassist nil 'noerror)
(semantic-load-enable-minimum-features)
(setq semanticdb-default-save-directory "~/.emacs.d/semanticdb")
(semantic-load-enable-code-helpers)
;;(semantic-load-enable-gaudy-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)
;;(semantic-load-enable-semantic-debugging-helpers)
(require 'cc-mode)
(require 'semantic)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)
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
(require 'helm-config)
(helm-mode 1)
(require 'xcscope)
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
(semanticdb-enable-cscope-databases)  ;;This is causing problems
;;auto company
(add-to-list 'load-path "~/.mylisp/company-mode/")
(autoload 'company-mode "company" nil t)
(setq bc-bookmark-file "~/.emacs.d/bookmark")
(setq bc-bookmark-limit 300)
;; Configuration of Python IDE
;; https://github.com/jorgenschaefer/elpy
;;(require 'elpy nil t)
;;(elpy-enable)
(put 'dired-find-alternate-file 'disabled nil)
