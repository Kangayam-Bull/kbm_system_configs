;;; init.el --- Emfy 0.4.0 <https://github.com/susam/emfy>

;;; Commentary:

;; A very basic dark and sleek Emacs setup for general purpose
;; editing and programming.

;;; Code:


;;; Look and Feel ====================================================

;; Tweak UI.
(when (display-graphic-p)
  (tool-bar-mode 0)
  (scroll-bar-mode 0))
(setq inhibit-startup-screen t)
(column-number-mode)

;;Themes ef-theme
(add-to-list 'load-path "~/.emacs.d/manual-packages/ef-themes")
(require 'ef-themes)
(setq ef-themes-headings ; read the manual's entry or the doc string
      '((0 variable-pitch light 1.9)
        (1 variable-pitch light 1.8)
        (2 variable-pitch regular 1.7)
        (3 variable-pitch regular 1.6)
        (4 variable-pitch regular 1.5)
        (5 variable-pitch 1.4) ; absence of weight means `bold'
        (6 variable-pitch 1.3)
        (7 variable-pitch 1.2)
        (t variable-pitch 1.1)))

;; If you like two specific themes and want to switch between them, you
;; can specify them in `ef-themes-to-toggle' and then invoke the command
;; `ef-themes-toggle'.  All the themes are included in the variable
;; `ef-themes-collection'.
(setq ef-themes-to-toggle '(ef-duo-light ef-eagle))

;; They are nil by default...
(setq ef-themes-mixed-fonts t
      ef-themes-variable-pitch-ui t)

;; Disable all other themes to avoid awkward blending:
(mapc #'disable-theme custom-enabled-themes)

;; Load the theme of choice:
(load-theme 'ef-duo-light :no-confirm)

;; Enable line numbers while writing config, code, or text.
(dolist (hook '(prog-mode-hook conf-mode-hook text-mode-hook))
  (add-hook hook 'display-line-numbers-mode))

;; Highlight matching pairs of parentheses.
(setq show-paren-delay 0)
(show-paren-mode)

;; Auto-complete inputs in the minibuffer.
(fido-vertical-mode)

;; (set-face-attribute 'default nil :font "Intel One Mono" :height 144)
(set-face-attribute 'default nil :font "Fira Code" :height 136)
;; (set-face-attribute 'default nil :font "JetBrains Mono" :height 136)
;; (set-face-attribute 'default nil :font "IBM Plex Mono" :height 136)
;; (set-face-attribute 'default nil :font "Consolas" :height 136)
;; (set-face-attribute 'default nil :font "Roboto Mono" :height 136)
;; (set-face-attribute 'default nil :font "Berkeley Mono" :height 136)

;;; Whitespace =======================================================

;; Show trailing whitespace while writing config, code, or text.
(dolist (hook '(conf-mode-hook prog-mode-hook text-mode-hook))
  (add-hook hook (lambda () (setq show-trailing-whitespace t))))

;; Show stray blank lines.
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;; Add a newline automatically at the end of a file while saving.
(setq require-final-newline t)

;; Consider a period followed by a single space to be end of sentence.
(setq sentence-end-double-space nil)

;; Use spaces, not tabs, for indentation.
(setq-default indent-tabs-mode nil)

;; Display the distance between two tab stops as 4 characters wide.
(setq-default tab-width 4)

;; Indentation setting for various languages.
(setq c-basic-offset 4)
(setq js-indent-level 2)
(setq css-indent-offset 2)


;;; Clean Working Directories ========================================

;; Write auto-saves and backups to separate directory.
(make-directory "~/.tmp/emacs/auto-save/" t)
(setq auto-save-file-name-transforms '((".*" "~/.tmp/emacs/auto-save/" t)))
(setq backup-directory-alist '(("." . "~/.tmp/emacs/backup/")))

;; Do not move the current file while creating backup.
(setq backup-by-copying t)

;; Disable lockfiles.
(setq create-lockfiles nil)

;; Write customizations to a separate file instead of this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)


;;; Custom Command and Key Sequences =================================

;; Custom command.
(defun show-current-time ()
  "Show current time."
  (interactive)
  (message (current-time-string)))

;; Custom key sequences.
(global-set-key (kbd "C-c t") 'show-current-time)
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)


;;; Emacs Server =====================================================

(require 'server)
(unless (server-running-p)
  (server-start))


;;; Package Setup ====================================================

(defun install-packages ()
  "Install and set up packages for the first time."
  (interactive)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents)
  (dolist (package '(markdown-mode paredit rainbow-delimiters))
    (unless (package-installed-p package)
      (package-install package))))


;;; Paredit Configuration ============================================

;; Enable Paredit on various Lisp modes.
(when (fboundp 'paredit-mode)
  (dolist (hook '(emacs-lisp-mode-hook
                  eval-expression-minibuffer-setup-hook
                  ielm-mode-hook
                  lisp-interaction-mode-hook
                  lisp-mode-hook))
    (add-hook hook 'enable-paredit-mode)))

;; Do not bind RET to paredit-RET which prevents input from being
;; evaluated on RET in M-:, ielm, etc.
(with-eval-after-load 'paredit
  (define-key paredit-mode-map (kbd "RET") nil))


;;; Rainbow Delimiters Configuration =================================

(when (fboundp 'rainbow-delimiters-mode)
  (dolist (hook '(emacs-lisp-mode-hook
                  ielm-mode-hook
                  lisp-interaction-mode-hook
                  lisp-mode-hook))
    (add-hook hook 'rainbow-delimiters-mode)))

(with-eval-after-load 'rainbow-delimiters
  (set-face-foreground 'rainbow-delimiters-depth-1-face "#c66")  ; red
  (set-face-foreground 'rainbow-delimiters-depth-2-face "#6c6")  ; green
  (set-face-foreground 'rainbow-delimiters-depth-3-face "#69f")  ; blue
  (set-face-foreground 'rainbow-delimiters-depth-4-face "#cc6")  ; yellow
  (set-face-foreground 'rainbow-delimiters-depth-5-face "#6cc")  ; cyan
  (set-face-foreground 'rainbow-delimiters-depth-6-face "#c6c")  ; magenta
  (set-face-foreground 'rainbow-delimiters-depth-7-face "#ccc")  ; light gray
  (set-face-foreground 'rainbow-delimiters-depth-8-face "#999")  ; medium gray
  (set-face-foreground 'rainbow-delimiters-depth-9-face "#666")) ; dark gray


;;; The End ==========================================================

(provide 'init)

;;; init.el ends here
