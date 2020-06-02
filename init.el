;;; Emacs Settings
;;;; Keyboard Layout
(shell-command
 "setxkbmap -layout us -cariant altgr-intl -option caps:escape")

;;;; Emacs UI
(menu-bar-mode -1)
(display-time-mode 1)
(scroll-bar-mode 0)
(tool-bar-mode -1)
(blink-cursor-mode 0)
(show-paren-mode 1)
(global-visual-line-mode t)
(fringe-mode 1)
(display-battery-mode t)

;;;; Emacs Misc
(setq-default tab-width 2)
(mouse-wheel-mode -1)
(setq show-paren-delay 0)

(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
			kept-new-versions 4
			kept-old-versions 2
			version-control t)

(setq enable-recursive-minibuffers t)

(defalias 'yes-or-no-p 'y-or-n-p)

;;;; Font
(set-face-attribute 'default nil :font "deja vu sans mono 12")
(set-frame-font "deja vu sans mono 12" nil t)

;;;; Prefered Webbrowser
(setq browse-url-browser-function 'browse-url-generic
			browse-url-generic-program "qutebrowser")

;;;; Modeline
(defun modeline-alignment (left right)
	(let* ((available-width (-(window-width)(length left) 2)))
		(format (format "%%s %%%ds " available-width) left right)))

(setq battery-mode-line-format "[%p%%]")
(setq-default mode-line-format
							'((:eval (modeline-alignment
												;;left
												(format-mode-line
												 (list
													"   "
													;; Filestatus -:---
													mode-line-mule-info
													mode-line-modified
													mode-line-client
													mode-line-remote
													mode-line-front-space
													;; Buffername
													"%b"
													;; VC/Git
													'(vc-mode vc-mode)))
												;;right
												(format-mode-line
												 (list
													"%p%%"
													"  "
													;; Date (Week Year-Month-Day)
													'(:eval(propertize(format-time-string "w%V %a %d/%h")))
													;; Time (Hour:Minutes:Seconds)
													'(:eval(propertize(format-time-string "  %H:%M  ")))
													;; Battery Life
													;;(my/battery-modeline)
													battery-mode-line-string
													))))))

;;;; Line Numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;;;; Org-settings
(setq org-src-window-setup 'current-window)

;;; Packages
;;;; Straight
(defvar bootstrap-version)
(let ((bootstrap-file
			 (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
			(bootstrap-version 5))
	(unless (file-exists-p bootstrap-file)
		(with-current-buffer
				(url-retrieve-synchronously
				 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
				 'silent 'inhibit-cookies)
			(goto-char (point-max))
			(eval-print-last-sexp)))
	(load bootstrap-file nil 'nomessage))

;;;; Evil
(straight-use-package 'evil)
(add-to-list 'load-path (concat user-emacs-directory "straight/build/undo-tree"))
(evil-mode)
(setq evil-emacs-state-modes nil)
(setq evil-insert-state-modes nil)
(setq evil-motion-state-modes nil)

(define-key evil-normal-state-map (kbd "C-u") (lambda ()
																								(interactive)
																								(evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-d") (lambda ()
																								(interactive)
																								(evil-scroll-down nil)))
(define-key evil-normal-state-map (kbd "Q") (lambda ()
																							(interactive)
																							(quit-window)))

;;;; Dired
(add-hook 'dired-mode-hook
					(lambda ()
						(dired-hide-details-mode)))

;;;; Undo-Tree
(straight-use-package 'undo-tree)
(global-undo-tree-mode)

;;;; Hydra
(straight-use-package 'hydra)

;;;;; Hydra-menu
(defhydra hydra-menu ()
	"Hydra Menu"
	("w" hydra-window/body "hydra-window" :exit t)
	("e" hydra-pulseaudio/body "hydra-pulseaudio" :exit t)
	("s-SPC" nil "quit"))

(global-set-key (kbd "s-SPC") 'hydra-menu/body)

;;;;; Hydra-window
(defhydra hydra-window ()
	"window-menu"
	("w" other-window "toggle")
	("c" delete-window "delete")
	("x" delete-other-windows "xor")
	("TAB" previous-buffer "prev")
	("s" split-window-below "split-below")
	("v" split-window-right "split-right")
	("0" balance-windows "balance")
	(")" balance-windows-area "area")
	("l" enlarge-window-horizontally "hor+")
	("h" shrink-window-horizontally "hor-")
	("k" enlarge-window "hor+")
	("j" shrink-window "hor-")
	("b" hydra-menu/body "back" :exit t)
	("s-SPC" nil "quit"))

;;;;; Hydra-pulseaudio
(defhydra hydra-pulseaudio ()
	"pulseaudio-menu"
	("-" pulseaudio-control-decrease-volume "dec -10")
	("=" pulseaudio-control-increase-volume "inc +10")
	("_" pulseaudio-control-select-sink-by-name "select sink")
	("+" pulseaudio-control-toggle-current-sink-mute "mute sink")
	("b" hydra-menu/body "back" :exit t)
	("s-SPC" nil "quit" :exit t))

;;;; Ivy
(straight-use-package 'ivy)
(ivy-mode)

;;;;; Counsel
(straight-use-package 'counsel)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)

;;;;; Swiper
(straight-use-package 'swiper)
(global-set-key (kbd "\C-s") 'swiper)

;;;; Avy
(straight-use-package 'avy)

;;;; Which Key
(straight-use-package 'which-key)
(which-key-mode)
(setq which-key-show-prefix 'left)

;;;; Colorschemes

;;;;; Spacemacs Theme
(straight-use-package 'spacemacs-theme)
(load-theme 'spacemacs-dark t)

;;;; Outshine
(straight-use-package 'outshine)
(add-hook 'emacs-lisp-mode-hook 'outshine-mode)

;;;; Org-brain
(straight-use-package 'org-brain)
(global-set-key (kbd "s-b") 'org-brain-visualize)

;;;;; Keybinds
;; (require 'evil)
;; (evil-define-key 'normal 'org-brain-visualize-mode-map
;; 	(kbd "m") 'org-brain-visualize-mind-map
;; 	(kbd "j") 'forward-button
;; 	(kbd "k") 'backward-button
;; 	(kbd "H") 'org-brain-visualize-back
;; 	(kbd "c") 'org-brain-add-child
;; 	(kbd "C") 'org-brain-remove-child
;; 	(kbd "e") 'org-brain-annotate-edge
;; 	(kbd "p") 'org-brain-add-parent
;; 	(kbd "P") 'org-brain-remove-parent
;; 	(kbd "f") 'org-brain-add-friendship
;; 	(kbd "F") 'org-brain-remove-friendship
;; 	(kbd "b") 'org-brain-pin
;; 	(kbd "s") 'org-brain-select-dwim
;; 	(kbd "S") 'org-brain-select-map
;; 	(kbd "t") 'org-brain-set-title
;; 	(kbd "T") 'org-brain-set-tags
;; 	(kbd "d") 'org-brain-delete-entry
;; 	(kbd "l") 'org-brain-visualize-add-resource
;; 	(kbd "r") 'org-brain-open-resource
;; 	(kbd "L") 'org-brain-visualize-paste-resource
;; 	(kbd "o") 'org-brain-goto-current
;; 	(kbd "O") 'org-brain-goto
;; 	(kbd "v") 'org-brain-visualize
;; 	(kbd "V") 'org-brain-visualize-follow
;; 	(kbd "R") 'org-brain-refile
;; 	(kbd "M") 'org-brain-change-local-parent
;; 	(kbd "-") 'org-brain-show-descendant-level
;; 	(kbd "=") 'org-brain-hide-descendant-level
;; 	(kbd "_") 'org-brain-show-ancestor-level
;; 	(kbd "+") 'org-brain-hide-ancestor-level)

;;;; Code Completion Engines

;;;;; Yasnippet
(straight-use-package 'yasnippet)
(add-to-list 'load-path
						 "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

;;;;; Company
(straight-use-package 'company)
(add-hook 'after-init-hook 'global-company-mode)

;;;;; Company-lsp
(straight-use-package 'company-lsp)
(require 'company-lsp)
(push 'company-lsp company-backends)
(setq company-lsp-cache-candidates t)
(setq company-lsp-async t)
(setq company-lsp-enable-snippet t)

;;;; ESS
(straight-use-package 'ess)
(require 'ess-r-mode)

;;;; Org-babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)))

;;;; Magit
(straight-use-package 'magit)

;;;;; Keybinds
(require 'evil)
(evil-define-key 'normal 'evil-normal-state-map
	(kbd "C-x g") 'magit-status)
(evil-define-key 'normal magit-mode-map
	(kbd "j") 'magit-section-forward
	(kbd "k") 'magit-section-backward
	(kbd "p") 'magit-pull
	(kbd "s") 'magit-stage-file
	(kbd "u") 'magit-unstage-file
	(kbd "c") 'magit-commit
	(kbd "m") 'magit-merge
	(kbd "P") 'magit-push
	(kbd "f") 'magit-fetch
	(kbd "l") 'magit-log
	(kbd "i") 'magit-gitignore
	(kbd "r") 'magit-refresh
	(kbd "g") 'beginning-of-buffer
	(kbd "G") 'end-of-buffer
	(kbd "M") 'magit-remote
	(kbd "d") 'magit-diff
	(kbd "b") 'magit-branch
	(kbd "R") 'magit-reset
	(kbd "Q") 'magit-mode-bury-buffer)

;;;; Org-bullets
(straight-use-package 'org-bullets)
(defun org-bullet-mode()
	(org-bullets-mode 1))
(add-hook 'org-mode-hook 'org-bullet-mode)

;;;; Aggressive Indent
(straight-use-package 'aggressive-indent)
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)

;;;; Pdf-tools
(straight-use-package 'pdf-tools)
(pdf-tools-install)
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))

;;;;; Keybinds
(require 'evil)
(evil-define-key 'normal pdf-view-mode-map
	(kbd "j") 'pdf-view-scroll-up-or-next-page
	(kbd "k") 'pdf-view-scroll-down-or-previous-page
	(kbd "C-j") 'pdf-view-next-line-or-next-page
	(kbd "C-k") 'pdf-view-previous-line-or-previous-page
	(kbd "J") 'pdf-view-next-page-command
	(kbd "K") 'pdf-view-previous-page-command
	(kbd "h") 'image-backward-hscroll
	(kbd "l") 'image-forward-hscroll
	(kbd "f") 'pdf-view-goto-page
	(kbd "r") 'pdf-view-revert-buffer
	(kbd "=") 'pdf-view-enlarge
	(kbd "+") 'pdf-view-enlarge
	(kbd "-") 'pdf-view-shrink
	(kbd "0") 'pdf-view-scale-reset
	(kbd "H") 'pdf-view-fit-height-to-window
	(kbd "W") 'pdf-view-fit-width-to-window
	(kbd "P") 'pdf-view-fit-page-to-window
	(kbd "/") 'isearch-forward-word
	(kbd "n") 'isearch-repeat-forward
	(kbd "N") 'isearch-repeat-backward
	(kbd "G") 'pdf-view-first-page
	(kbd "o") 'pdf-outline)

;;;; Rainbow Delimiters
(straight-use-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;;; Ox-twbs
(straight-use-package 'ox-twbs)

;;;; Smartparens
(straight-use-package 'smartparens)
(require 'smartparens-config)
(add-hook 'org-mode-hook #'smartparens-mode)
(add-hook 'prog-mode-hook #'smartparens-mode)
;;(sp-local-pair 'c-mode "'" nil :actions :rem)
;;(sp-local-pair 'c-mode "'" "'")
(sp-local-pair 'emacs-lisp-mode "`" "'")
(setq-default sp-escape-quotes-after-insert nil)
;;Symbol's function definition is void: sp-local-pair

;;;; Flycheck
(straight-use-package 'flycheck)
(global-flycheck-mode)
(with-eval-after-load 'flycheck
	(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;;;; LSP-mode
(straight-use-package 'lsp-mode)
(require 'lsp-mode)
(add-hook 'c++-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'java-mode-hook #'lsp)
(add-hook 'lsp-mode-hook #'lsp)
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp)

;;;;; Dap-mode
(straight-use-package 'dap-mode)
(dap-mode 1)
(dap-ui-mode 1)
(dap-tooltip-mode 1)
(tooltip-mode 1)

;;;;; CCLS
(with-eval-after-load 'lsp
	(straight-use-package 'ccls)
	(require 'ccls)
	(setq ccls-executable "/usr/bin/ccls")
	(add-hook 'c-mode-hook #'lsp)
	(add-hook 'objc-mode-hook #'lsp)
	(add-hook 'c++-mode-hook #'lsp))

;;;;; LSP-java
(with-eval-after-load 'lsp
	(straight-use-package 'lsp-java)
	(require 'dap-java)
	(require 'lsp-java))

;;;;; LSP-haskell
(with-eval-after-load 'lsp
	(straight-use-package 'lsp-haskell)
	(require 'lsp-haskell))

;;;;; LSP-tex
(with-eval-after-load 'lsp
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection "digestif")
									:major-modes '(latex-mode plain-tex-mode)
									:server-id 'digestif))
(add-to-list 'lsp-language-id-configuration '(latex-mode . "latex"))
(add-to-list 'lsp-language-id-configuration '(plain-tex-mode . "plaintex"))

(require 'company-lsp)
(add-to-list 'company-lsp-filter-candidates '(digestif . nil)))

;;;;; LSP-r
(with-eval-after-load 'lsp
	(lsp-register-client
	 (make-lsp-client :new-connection
										(lsp-stdio-connection '("R" "--slave" "-e" "languageserver::run()"))
										:major-modes '(ess-r-mode inferior-ess-r-mode)
										:server-id 'lsp-R)))

;;;;; LSP-python
(with-eval-after-load 'lsp
	(require 'dap-python))

;;;; Common Lisp
(require 'cl)

;;;; My/set-brightness
(defun my/set-brightness()
	(interactive)

	(setq my/max-brightness-file "/sys/class/backlight/intel_backlight/max_brightness")
	(setq my/brightness-file "/sys/class/backlight/intel_backlight/brightness")

	(let* ((my/max-brightness
					(string-to-number(f-read-text my/max-brightness-file)))
				 (my/brightness-ratio
					(/ (string-to-number(read-from-minibuffer "Brightness 0-100: ")) 100.0))
				 (my/brightness
					(floor(* my/max-brightness my/brightness-ratio))))
		(shell-command
		 (concat "echo " (number-to-string my/brightness) " > " my/brightness-file))))

;;;; Pulseaudio-control
(straight-use-package 'pulseaudio-control)
