;;*****************************************************************
;;
;;                     KBM's emacs config - Init
;;
;;*****************************************************************

;;BuiltIn Package System
(require 'package)
(add-to-list 'package-archives '(("melpa" . "https://melpa.org/packages/")
				 ("org" . "https://orgmode.org/elpa/")
				 ("gnu" . "https://elpa.gnu.org/packages/")
				 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;-----------------------------------------------------------------
;;                         User Interface
;;-----------------------------------------------------------------

;;(tool-bar-mode -1)     ; Disable toolbar
;;(menu-bar-mode -1)     ; Disable the menubar
;;(tooltip-mode -1)      ; Disable tooltips

;;(scroll-bar-mode -1)   ; Disable visible scrollbar
(set-fringe-mode -1)   ; Give some breathing room

(global-display-line-numbers-mode 1)   ; Enable line numbers on left margin
(setq line-number-mode t)    ; To show the line number in the status buffer
(setq column-number-mode t)   ; To show the column number in the status buffer

;;Setup the visible bell instead of sound queue
(setq visible-bell t)


;;Setting Themes
(load-theme 'modus-operandi)

(set-face-attribute 'default nil :font "Intel One Mono" :height 144)
;; (set-face-attribute 'default nil :font "Fira Code" :height 136)

;;----------------------------------------------------------------
;; Functionalities
;;----------------------------------------------------------------

;;Activating the EVIL mode
;;(require 'evil)
;;(evil-mode 1)

;; Ledger-Mode
(use-package ledger-mode
  :mode ("\\.dat\\'"
         "\\.ledger\\'")
  :custom (ledger-clear-whole-transactions t))

(use-package flycheck-ledger :after ledger-mode)


(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1))

(use-package company-capf
  :ensure nil
  :after (company lsp-mode)
  :config
  (add-to-list 'company-backends 'company-capf))


;;-----------------------------------------------------------------
;; RUST
;;-----------------------------------------------------------------

(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t))

(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (rust-mode . lsp-deferred)
  :config
  (setq lsp-rust-analyzer-server-command '("rust-analyzer")))
