;;; Emacs Settings
;;;; Keyboard Layout
(shell-command
 "setxkbmap -layout us -variant altgr-intl -option caps:escape")

;;;; Emacs UI
(menu-bar-mode -1)
(display-time-mode 1)
(scroll-bar-mode 0)
(tool-bar-mode -1)
(blink-cursor-mode 0)
(show-paren-mode 1)
(global-visual-line-mode t)
(fringe-mode 0)
(display-battery-mode t)

;;;; Emacs Misc
(setq-default tab-width 2)
(mouse-wheel-mode -1)
(setq show-paren-delay 0)

(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
			kept-new-versions 4
			kept-old-versions 2
			version-control t)

(setq enable-recursive-minibuffers t)

(defalias 'yes-or-no-p 'y-or-n-p)

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

;;;; Prefered Webbrowser
(setq browse-url-browser-function 'browse-url-generic
			browse-url-generic-program "qutebrowser")

;;;; Battery
(require 'battery)
(setq battery-mode-line-format "%th - %p")

;;;; Line Numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;;;; NixOS
;; Load emacs packages from nixOS directory
(setq load-path (append load-path (file-expand-wildcards (expand-file-name "~/.nix-profile/share/emacs/site-lisp/elpa/*"))))

;;;; Initial-buffer
(setq initial-buffer-choice t)

;;;; Mark-ring
(setq mark-ring-max 8)
(setq global-mark-ring-max 8)
(global-set-key (kbd "C-x C-2") 'pop-global-mark)

;;;; Split-threshold
(setq split-height-threshold nil)
(setq split-width-threshold 100)

;;; Packages

;;;; Org-mode
(straight-use-package 'org)
(setq org-src-window-setup 'split-window-below)

;;(setq org-image-actual-width (* 15 (/ (window-width) 3)))
(setq org-log-done 'time)

;; persistent clock
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(setq org-clock-idle-time 15)

(define-key org-mode-map (kbd "C-c l") 'org-store-link)

;;;;; Structured Templates
;; Templates are defined in ~org-structure-template-alist~
(require 'org-tempo)

;;;;; Timestamps
(setq time-stamp-active t     ; enable time-stamps
			time-stamp-line-limit 5 ;check first 5 lines for Time-stamp: <> or Time-stamp: " "
			time-stamp-format "%04Y-%02m-%02d %02H:%02M:%02S (%u)") ; date format
(add-hook 'write-file-functions 'time-stamp) ; update time stamp when saving

;;;;; Org-agenda
(setq org-agenda-files '("~/gtd/inbox.org"
												 "~/gtd/gtd.org"
												 "~/gtd/tickler.org"))

(setq org-capture-templates '(("t" "Todo [inbox]" entry
															 (file+headline "~/gtd/inbox.org" "Tasks")
															 "* Todo %i%?")
															("T" "Tickler" entry
															 (file+headline "~/gtd/tickler.org" "Tickler")
															 "* %i%? \n %U")))

(setq org-refile-targets '(("~/gtd/gtd.org" :maxlevel . 3)
													 ("~/gtd/someday.org" :level . 1)
													 ("~/gtd/tickler.org" :maxlevel . 2)))

(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

(setq org-agenda-custom-commands
			'(("o" "At the office" tags-todo "@office"
				 ((org-agenda-overriding-header "Office")))))

;;;; Flyspell
(add-hook 'org-mode-hook 'flyspell-mode)

;;;; Undo-tree
(straight-use-package 'undo-tree)
(global-undo-tree-mode 1)
(setq evil-undo-system 'undo-tree)

;;;; Evil
(setq evil-want-keybinding nil)
(setq evil-want-integration t)

(straight-use-package 'evil)
(add-to-list 'load-path (concat user-emacs-directory "straight/build/undo-tree"))
(evil-mode)
(setq evil-emacs-state-modes nil
			evil-insert-state-modes nil
			evil-motion-state-modes nil)

(define-key evil-normal-state-map (kbd "C-u") (lambda ()
																								(interactive)
																								(evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-d") (lambda ()
																								(interactive)
																								(evil-scroll-down nil)))
(define-key evil-normal-state-map (kbd "Q") (lambda ()
																							(interactive)
																							(quit-window)))

;;;; Evil-surround
(straight-use-package 'evil-surround)
(global-evil-surround-mode 1)

;;;; Evil-collection
;; https://github.com/emacs-evil/evil-collection
(straight-use-package 'evil-collection)
(setq evil-collection-setup-minibuffer t)
(when (require 'evil-collection nil t)
	(evil-collection-init))

;;;; Colorschemes

;;;;; Spacemacs-theme
(straight-use-package 'spacemacs-theme)

;;;;; Gruvbox-theme
(straight-use-package 'gruvbox-theme)

;;;;; Dracula-theme
(straight-use-package 'dracula-theme)

;;;;; Doom-theme
(straight-use-package 'doom-themes)

;; Set theme
(load-theme 'spacemacs-dark t)

;;;; Font

;;;;; Default-face
(set-face-attribute 'default nil
										:family "deja vu sans mono"
										:height 120)

;;;;; Mode specific font
(defun my/buffer-face-mode-variable ()
	"Set font to a variable width (proportional) fonts in current buffer"
	(setq buffer-face-mode-face '(:family "noto serif" :height 120 :width semicondensed :weight regular))
	(set-face-attribute 'org-table nil :family "deja vu sans mono" :height 120)
	(buffer-face-mode))

(defun my/buffer-face-mode-fixed ()
	"Sets a fixed width (monospace) font in current buffer"
	(setq buffer-face-mode-face '(:family "deja vu sans mono" :height 120))
	(buffer-face-mode))

;; Mode specific fonts
;;(add-hook 'text-mode-hook 'variable-pitch-mode)
(add-hook 'org-mode-hook 'my/buffer-face-mode-variable)

;;;;; Modeline face
(set-face-attribute 'mode-line nil :family "deja vu sans mono" :height 80)
(set-face-attribute 'mode-line-inactive nil :family "deja vu sans mono" :height 80)

;;;;; Org-mode faces
(set-face-attribute 'org-table nil :family "deja vu sans mono")
(set-face-attribute 'org-block nil :family "deja vu sans mono")
(set-face-attribute 'org-code nil :family "deja vu sans mono" :foreground "#696969")
(set-face-attribute 'org-verbatim nil :family "deja vu sans mono")

;;;; Olivetti
(straight-use-package 'olivetti)
(add-hook 'text-mode-hook 'olivetti-mode)

;;;; Mouse-clicks
(dolist (mouseclicks-kill '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]  
														[mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
														[mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]
														[mouse-4] [down-mouse-4] [drag-mouse-4] [double-mouse-4] [triple-mouse-4]
														[mouse-5] [down-mouse-5] [drag-mouse-5] [double-mouse-5] [triple-mouse-5]))
  (global-unset-key mouseclicks-kill))
(define-key evil-motion-state-map [down-mouse-1] nil)
(define-key evil-normal-state-map [down-mouse-1] nil)

;;;; Dired
(add-hook 'dired-mode-hook
					(lambda ()
						(dired-hide-details-mode)))
;; Human readable memory listing
(setq dired-listing-switches "-alh")

;;;; Dired-du
;;(straight-use-package 'dired-du)
;;(setq dired-du-size-format t)

;;;; Common-lisp
(require 'cl)

;;;; Hydra
;; https://github.com/abo-abo/hydra

(straight-use-package 'hydra)

;; | red      |                            |
;; | blue     | :exit t                    |
;; | amaranth | :foreign-keys warn         |
;; | teal     | :foreign-keys warn :exit t |
;; | pink     | :foreign-keys run          |

;;;;; Hydra-menu
(defhydra hydra-menu ()
	"Hydra Menu"
	("b" my/set-brightness "set-brightness" :exit t)
	("e" hydra-pulseaudio/body "hydra-pulseaudio" :exit t)
	("s-SPC" nil "quit" :exit t))

(global-set-key (kbd "s-SPC") 'hydra-menu/body)

;;;;; Hydra-window
(defhydra hydra-window (:hint nil)
	"
Navigation                           ^^Edit                               ^^^^Resize
_C-w_: toggle    _n_: bottom-right   _c_: delete         _H_: move-left     _-_: hor-    _0_: balance
_h_:   left      _y_: top-left       _x_: xor						 _J_: move-down     _=_: hor+    _)_: area
_j_:   down                        _s_: split-below    _K_: move-up       ___: ver-    
_k_:   up                          _v_: split-right    _L_: move-right    _+_: ver+
_l_:   right                       _r_: rotate
"
	("C-w" other-window :exit t)
	("c" delete-window :exit t)
	("x" delete-other-windows :exit t)
	;;("b" previous-buffer)
	;;("n" next-buffer)
	("r" evil-window-rotate-downwards)
	("s" split-window-below :exit t)
	("v" split-window-right :exit t)
	("0" balance-windows :exit t)
	(")" balance-windows-area :exit t)
	("=" (enlarge-window-horizontally 5))
	("-" (shrink-window-horizontally 5))
	("+" (enlarge-window 5))
	("_" (shrink-window 5))
	("h" evil-window-left :exit t)
	("j" evil-window-down :exit t)
	("k" evil-window-up :exit t)
	("l" evil-window-right :exit t)
	("n" evil-window-bottom-right :exit t)
	("y" evil-window-top-left :exit t)
	("H" evil-window-move-far-left :exit t)
	("J" evil-window-move-very-bottom :exit t)
	("K" evil-window-move-very-top :exit t)
	("L" evil-window-move-far-right :exit t)
	("q" nil  :exit t))

(evil-define-key 'normal 'evil-normal-state-map (kbd "C-w") 'hydra-window/body)
;;(global-set-key (kbd "s-q") 'hydra-window/body)

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
(with-eval-after-load 'helm
	(add-hook 'after-init-hook 'ivy-mode))
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

;;;;; Counsel
(straight-use-package 'counsel)
(counsel-mode)
;;(global-set-key (kbd "M-x") 'counsel-M-x)
;;(global-set-key (kbd "C-x b") 'switch-to-buffer)
;;(global-set-key (kbd "C-x d") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)

;;;;; Swiper
(straight-use-package 'swiper)
(global-set-key (kbd "C-s") 'swiper)

;;;; Avy
(straight-use-package 'avy)
(evil-define-key 'normal 'evil-normal-state-map (kbd "C-a a") 'evil-avy-goto-char-2
	(kbd "C-a s") 'evil-avy-goto-char-timer)

;;;; Helm
(straight-use-package 'helm)
(add-hook 'after-init-hook 'helm-mode)
(require 'helm)
(require 'helm-config)

;; ensures helm always splits down and don't toggle off other buffers
(setq helm-always-two-windows nil
			helm-default-display-buffer-functions '(display-buffer-in-side-window))

;;(setq helm-ff-auto-update-initial-value t)
(setq helm-move-to-line-cycle-in-source nil)

;; remove helm header
(setq helm-display-header-line nil)

;;(global-set-key (kbd "C-c h") 'helm-command-prefix)
;;(global-unset-key (kbd "C-x c"))
;;
;;(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
;;(define-key helm-map (kbd "C-z") 'helm-select-action)
;;
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x d") 'helm-find-files)
;;(define-key helm-command-map (kbd "<menu>") 'helm-resume)

;;(setq helm-autoresize-max-height 0
;;helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

;;;; Ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-diff-options "-w")

;;;; Which Key
(straight-use-package 'which-key)
(which-key-mode)
(setq which-key-show-prefix 'left)

;;;; Outshine
(straight-use-package 'outshine)
(add-hook 'emacs-lisp-mode-hook 'outshine-mode)

;;;; Org-brain
(straight-use-package 'org-brain)
(setq org-brain-path "~/Documents/OrgBrain")
(setq org-id-locations-file "~/.emacs.d/.org-id-locations")
(setq org-brain-show-history nil)
(setq org-brain-show-resources nil)
(setq org-brain-open-same-window t)

;;(global-set-key (kbd "s-b") 'org-brain-visualize)
;;(global-set-key (kbd "s-B") 'org-brain-switch-brain)
;;(evil-define-key 'normal org-mode-map (kbd "s-t") 'org-brain-get-id)

;;(with-eval-after-load 'evil
;;(evil-set-initial-state 'org-brain-visualize-mode 'emacs))

;; combined healine-file entries
(setq org-brain-scan-for-header-entries t
			org-id-track-globally t
			org-brain-include-file-entries t)

;; headline entries only
;;(setq org-brain-include-file-entries nil
;;org-brain-file-entries-use-title nil
;;org-id-track-globally t
;;org-brain-headline-entry-name-format-string "%2$s")
;;(add-hook 'before-save-hook #'org-brain-ensure-ids-in-buffer)

;; file entries only
;;(setq org-brain-scan-for-header-entries nil)


(setq org-brain-completion-system 'ivy)

(with-eval-after-load 'org
	(require 'org-brain))

(add-hook 'org-brain-visualize-text-hook 'org-toggle-latex-fragment)
(add-hook 'org-brain-visualize-text-hook 'org-toggle-inline-images)

;;;; Hide-mode-line
(straight-use-package 'hide-mode-line)

(evil-define-key 'normal 'org-roam-mode-map
	(kbd "C-c n t") 'org-roam-buffer-toggle-display
	(kbd "C-c n f") 'org-roam-find-file
	(kbd "C-c n g") 'org-roam-graph)
(evil-define-key 'normal 'org-mode-map
	(kbd "C-C n i") 'org-roam-insert
	(kbd "C-C n I") 'org-roam-insert-immediate)
;;(add-hook 'org-roam-buffer-prepare-hook #'hide-mode-line-mode)

(setq org-roam-completion-everywhere t)

;;;; Image-mode
(setq image-auto-resize 'fit-height)
(evil-set-initial-state 'image-mode 'normal)
;;(evil-define-key 'normal image-mode-map
	;;(kbd "W") 'image-transform-fit-to-width
	;;(kbd "H") 'image-transform-fit-to-height
	;;(kbd "j") 'image-scroll-up
	;;(kbd "k") 'image-scroll-down
	;;(kbd "l") 'image-next-file
	;;(kbd "h") 'image-previous-file)

;;;; Code Completion Engines

;;;;; Yasnippet
(straight-use-package 'yasnippet)
(add-to-list 'load-path
						 "~/.emacs.d/plugins/yasnippet")
(yas-global-mode 1)

;;;;; Company
(straight-use-package 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-dabbrev-other-buffers t
			company-dabbrev-code-other-buffers t)

;;;; Magit
(straight-use-package 'magit)

;;;;; Keybinds
(evil-define-key 'normal 'evil-normal-state-map
	(kbd "C-x g") 'magit-status)
;;(evil-define-key 'normal magit-mode-map
	;;(kbd "j") 'magit-section-forward
	;;(kbd "k") 'magit-section-backward
	;;(kbd "p") 'magit-pull
	;;(kbd "s") 'magit-stage-file
	;;(kbd "u") 'magit-unstage-file
	;;(kbd "c") 'magit-commit
	;;(kbd "m") 'magit-merge
	;;(kbd "P") 'magit-push
	;;(kbd "f") 'magit-fetch
	;;(kbd "l") 'magit-log
	;;(kbd "i") 'magit-gitignore
	;;(kbd "r") 'magit-refresh
	;;(kbd "g") 'beginning-of-buffer
	;;(kbd "G") 'end-of-buffer
	;;(kbd "M") 'magit-remote
	;;(kbd "d") 'magit-diff
	;;(kbd "b") 'magit-branch
	;;(kbd "R") 'magit-reset
	;;(kbd "Q") 'magit-mode-bury-buffer)

;;;; Org-bullets
(straight-use-package 'org-bullets)
(defun org-bullet-mode()
	(org-bullets-mode 1))
(add-hook 'org-mode-hook 'org-bullet-mode)

;;;; Aggressive Indent
(straight-use-package 'aggressive-indent)
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)

;;;; Pdf-tools
(load-library "pdf-tools-autoloads")
(pdf-tools-install)
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))

;;;;; Keybinds
;;(evil-define-key 'normal pdf-view-mode-map
;;(kbd "j") 'pdf-view-scroll-up-or-next-page
;;(kbd "k") 'pdf-view-scroll-down-or-previous-page
;;(kbd "C-j") 'pdf-view-next-line-or-next-page
;;(kbd "C-k") 'pdf-view-previous-line-or-previous-page
;;(kbd "J") 'pdf-view-next-page-command
;;(kbd "K") 'pdf-view-previous-page-command
;;(kbd "h") 'image-backward-hscroll
;;(kbd "l") 'image-forward-hscroll
;;(kbd "f") 'pdf-view-goto-page
;;(kbd "r") 'pdf-view-revert-buffer
;;(kbd "=") 'pdf-view-enlarge
;;(kbd "+") 'pdf-view-enlarge
;;(kbd "-") 'pdf-view-shrink
;;(kbd "0") 'pdf-view-scale-reset
;;(kbd "H") 'pdf-view-fit-height-to-window
;;(kbd "W") 'pdf-view-fit-width-to-window
;;(kbd "P") 'pdf-view-fit-page-to-window
;;(kbd "/") 'isearch-forward-word
;;(kbd "n") 'isearch-repeat-forward
;;(kbd "N") 'isearch-repeat-backward
;;(kbd "G") 'pdf-view-first-page
;;(kbd "o") 'pdf-outline)

;;;; Rainbow Delimiters
(straight-use-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;;; Gnuplot
(straight-use-package 'gnuplot)
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

;;(sp-local-pair 'org-mode "=" nil :actions :rem)
(setq-default sp-escape-quotes-after-insert nil)
;;Symbol's function definition is void: sp-local-pair

;;;; Flycheck
(straight-use-package 'flycheck)
(global-flycheck-mode)
(with-eval-after-load 'flycheck
	(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;;;; Elpy
(straight-use-package 'elpy)
(elpy-enable)

;;;; LSP-mode
(straight-use-package 'lsp-mode)
(require 'lsp-mode)
(add-hook 'lsp-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'java-mode-hook #'lsp)
(add-hook 'lsp-mode-hook #'lsp)
(add-hook 'nxml-mode-hook #'lsp)

;;;;; Dap-mode
(straight-use-package 'dap-mode)
(dap-mode 1)
(dap-ui-mode 1)
(dap-tooltip-mode 1)
(tooltip-mode 1)

;;;;; CCLS
(straight-use-package 'ccls)
(with-eval-after-load 'lsp
	(require 'ccls)
	(setq ccls-executable "/usr/bin/ccls")
	(add-hook 'c-mode-hook #'lsp))

;;;;; LSP-java
(straight-use-package 'lsp-java)
(with-eval-after-load 'lsp
	(require 'dap-java)
	(require 'lsp-java))

;;;; Lua-mode
(straight-use-package 'lua-mode)

;;;; Nxml-mode
(add-hook 'nxml-mode-hook 'line-number-mode)

;;;; Org-babel
(org-babel-do-load-languages
 'org-babel-load-languages '((shell . t)
														 (C . t)))
;;;; Exwm
(straight-use-package 'exwm)
(server-start)
(require 'exwm)

(setq exwm-workspace-number 1)

(add-hook 'exwm-update-class-hook
					(lambda ()
						(unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
												(string= "gimp" exwm-instance-name))
							(exwm-workspace-rename-buffer exwm-class-name))))
(add-hook 'exwm-update-title-hook
					(lambda ()
						(when (or (not exwm-instance-name)
											(string-prefix-p "sun-awt-X11-" exwm-instance-name)
											(string= "gimp" exwm-instance-name))
							(exwm-workspace-rename-buffer exwm-title))))

(setq exwm-input-global-keys
			`(
				;; [s-r] Exit char-mode and fullscreen mode
				([?\s-r] . exwm-reset)
				;; [s-w] Switch workspace interactively
				([?\s-w] . exwm-workspace-switch)
				;; [s-%d] Switch to a workspace by its index
				,@(mapcar (lambda (i)
										`(,(kbd (format "s-%d" i)) .
											(lambda ()
												(interactive)
												(exwm-workspace-switch-create ,i))))
									(number-sequence 0 9))
				;; [s-&][M-&] Launch applications 
				([?\s-&] . (lambda (command)
										 (interactive (list (read-shell-command "$ ")))
										 (start-process-shell-command command nil command)))
				;; Bind "s-<f2>" to start mupdf on this pdf file
				([s-f2] . (lambda ()
										(interactive)
										(start-process "" nil "/usr/bin/mupdf" (f-this-file))))))

(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)
(define-key exwm-mode-map [?\s-c] #'exwm-input-release-keyboard)
(define-key exwm-mode-map [?\s-f] #'exwm-layout-toggle-fullscreen)
(define-key exwm-mode-map [?\C-w] #'hydra-window/body)
(define-key exwm-mode-map [?\s-\ ] #'hydra-menu/body)
(define-key exwm-mode-map [?\s-b ] #'org-brain-visualize)

(evil-set-initial-state 'exwm-mode 'emacs)
(setq exwm-input-simulation-keys
			'(
				;; movement
				([?\C-u] . [prior])
				([?\C-d] . [next])))

(defun exwm-passthrough (orig-fun keymap on-exit &optional foreign-keys)
	(setq exwm-input-line-mode-passthrough t)
	(let ((on-exit (lexical-let ((on-exit on-exit))
									 (lambda ()
										 (setq exwm-input-line-mode-passthrough nil)
										 (when on-exit (funcall on-exit))))))
		(apply orig-fun keymap on-exit (list foreign-keys))))

(advice-add 'hydra-set-transient-map :around #'exwm-passthrough)

(require 'exwm-randr)
(exwm-randr-enable)
(exwm-enable)

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

;;;; ScreenShot
(straight-use-package 'screenshot)
(global-set-key (kbd "s-s") 'screenshot)
(setq screenshot-schemes
			'(
				("local"
				 :dir "~/Media/Screenshots")
				("current-dir"
				 :dir default-directory)))

;;;; Randr-config
(defun generate-randr-config (primary secondary)
  (-flatten `(,(-map (lambda (n) (list n primary)) (number-sequence 1 7))
              (0 secondary)
              ,(-map (lambda (n) (list n secondary)) (number-sequence 8 9)))))

(defun randr-layout-dp1-extend ()
	"Extend the screen to Display Port"

  (interactive)
  (setq exwm-randr-workspace-monitor-plist (generate-randr-config "DP-1" "eDP-1"))
  (exwm-randr-refresh)
	(randr-layout-single)
  (shell-command "xrandr --output DP-1 --left-of eDP-1 --auto --primary"))

(defun randr-layout-hdmi1-extend ()
	"Extend the screen to HDMI"

  (interactive)
  (setq exwm-randr-workspace-monitor-plist (generate-randr-config "HDMI-1" "eDP-1"))
  (exwm-randr-refresh)
	(randr-layout-single)
	(shell-command "xrandr --output HDMI-1 --auto --left-of eDP-1 --auto --primary"))

(defun randr-layout-hdmi1-only ()
	"Only HDMI is shown"

	(interactive)
	(exwm-randr-refresh)
	(shell-command "xrandr --output HDMI-1 --auto --primary")
	(shell-command "xrandr --output eDP-1 --off"))

(defun randr-layout-dp1-only ()
	"Only HDMI is shown"

	(interactive)
	(exwm-randr-refresh)
	(shell-command "xrandr --output DP-1 --auto --primary")
	(shell-command "xrandr --output eDP-1 --off"))

(defun randr-layout-single ()
	"Laptop screen only!"

	(interactive)
	(exwm-randr-refresh)
	(shell-command "xrandr --output eDP-1 --auto --primary")
	(shell-command "xrandr --output HDMI-1 --off")
	(shell-command "xrandr --output DP-1 --off"))

;; xrandr multiple monitor
;;(setq exwm-randr-workspace-output-plist '(1 "DP-1" 2 "DP-2"))
;;(add-hook 'exwm-randr-screen-change-hook
;;(lambda ()
;;(start-process-shell-command
;;"xrandr" nil "xrandr --output DP-1 --right-of LVDS1 --auto")))

;;;; Ido-mode
(ido-mode -1)
(defun ido-mode (&optional rest)
	())

;;;; Libvterm
(load-library "vterm-autoloads")

;;;; Projectile
(straight-use-package 'projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(setq projectile-completion-system 'ivy)

;;;; Org-noter
(straight-use-package 'org-noter)

;;;; Org-roam
(straight-use-package 'org-roam)
(add-hook 'after-init-hook 'org-roam-mode)

(setq org-roam-directory "/home/samcheung/Org/roam-repo/")
(setq org-roam-dailies-directory (concat org-roam-directory "dailies/"))

;; the slug tag are what are passed down from my search
(setq org-roam-capture-templates
			'(("d" "default" plain
				 (function org-roam--capture-get-point)
				 "%?"
				 :file-name "%<%y%m%d>-${slug}"
				 :head "#+title: ${title}\nTime-stamp: <>\n"
				 :unnarrowed t)))

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         #'org-roam-capture--get-point
         "* %?"
         :file-name "dailies/%<%Y-%m-%d>"
         :head "#+title: %<%Y-%m-%d>\n\n")))


;;;;; Org-ref
(straight-use-package 'org-ref)
(require 'org-ref)

;; Bibliography file
(setq reftex-default-bibliography '("~/Syncthing/bibliography/references.bib"))

;; Bibliography file
(setq org-ref-default-bibliography '("~/Syncthing/bibliography/references.bib")
			;; Source pdf locations
			org-ref-pdf-directory "~/Syncthing/bibliography/bib-pdf/")


;;;;; Helm-bibtex
;; Change to ivy-bibtex for ivy front-end
(straight-use-package 'helm-bibtex)
(define-key helm-command-map "b" 'helm-bibtex)

;; Tell where bibtex-completion to find bibliography file
(setq bibtex-completion-bibliography "~/Syncthing/bibliography/references.bib")

;; Source pdf locations
;; https://github.com/tmalsburg/helm-bibtex#pdf-files
(setq bibtex-completion-library-path "~/Syncthing/bibliography/bib-pdf")
(setq bibtex-completion-pdf-field "File")

;;;;; Org-roam-bibtex
(straight-use-package 'org-roam-bibtex)
(require 'org-roam-bibtex)

(with-eval-after-load 'org-roam
	(add-hook 'org-roam-mode-hook #'org-roam-bibtex-mode))

;; Choose which front-end to use (ivy-bibtex, helm-bibtex or generic)
(setq orb-insert-interface 'helm-bibtex)

;; Set citation style
(setq orb-insert-link-description 'citation)

;; Which bibtex fields to grab to use by orb-templates
;; Additional fields defined by helm bibtex:
;; https://github.com/tmalsburg/helm-bibtex/blob/master/bibtex-completion.el#L1147-L1205
(setq orb-preformat-keywords
      '("citekey" "title" "url" "author-or-editor" "keywords" "file")
			orb-process-file-field t
      orb-file-field-extensions "pdf")

;; Templates to use when creating a new bibliographical note
(setq orb-templates
      '(("r" "ref" plain (function org-roam-capture--get-point) ""
				 :file-name "${citekey}"
				 :head "#+TITLE: ${citekey} - ${title}\n#+ROAM_KEY: ${ref}\n"
				 :unnarrowed t)
				("n" "ref+noter" plain (function org-roam-capture--get-point) ""
         :file-name "${citekey}"
         :head "#+TITLE: ${citekey} - ${title}\n#+ROAM_KEY: ${ref}

- keywords :: ${keywords}

* ${title}
:PROPERTIES:
:Custom_ID: ${citekey}
:URL: ${url}
:AUTHOR: ${author-or-editor}
:NOTER_DOCUMENT: ${file}
:NOTER_PAGE:
:END:")))

;;; Doom-modeline
(straight-use-package 'doom-modeline)
(require 'doom-modeline)
(doom-modeline-mode 1)
(add-hook 'after-init-hook #'doom-modeline-mode)
